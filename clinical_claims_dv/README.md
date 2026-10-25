# clinical_claims_dv

Governed Data Vault 2.0 on `SYNTHETIC_HEALTHCARE_DATA_CLINICAL_AND_CLAIMS.SILVER`, built with AutomateDV 0.11.2, plus marts, a clean room, a semantic view and a Cortex Agent.
Full lineage, governance and DMF inventory: [`docs/LINEAGE.md`](docs/LINEAGE.md).

| Layer | Schema | Models |
|---|---|---|
| Staging | `STAGING` | `base_*` (patient-aligned sample), `stg_*` (AutomateDV `stage`: hash keys, hashdiffs, LOAD_DATETIME, RECORD_SOURCE) |
| Raw vault | `RAW_VAULT` | 18 hubs, 15 links, 19 satellites (patient PII split into `sat_patient_pii`), all incremental |
| Business vault | `BUSINESS_VAULT` | `as_of_date`, `pit_patient`, `bridge_patient_coverage`, `bv_patient_current`, `bv_encounter_enriched`, `bv_claim_financials` |
| Marts | `MARTS` | `dim_patient` (view, masked), `dim_provider`, `dim_payer`, `fct_encounter`, `fct_claim`, `fct_condition`, `agg_payer_monthly` |
| Clean room | `CLEANROOM` | `cr_member_profile`, `cr_encounter_utilization` (aggregate-only for `PARTNER_ANALYST`), `partner_member_list` (simulated partner) |
| Governance | `GOVERNANCE` | Tags `DATA_LAYER`, `DATA_DOMAIN`, `DATA_OWNER`, `SENSITIVITY`; masking, aggregation and projection policies |
| AI | `MARTS` | Semantic view `CLINICAL_CLAIMS_SV`, Cortex Agent `CLINICAL_CLAIMS_AGENT` |

Role `ATTENDEE_ROLE`, warehouse `DEFAULT_WH` (see `dbt_projects_profiles.yml`). Shared with USER1/USER2 through `ATTENDEE_ROLE`.

## Project layout
| Path | Purpose |
|---|---|
| `macros/governance_tags.sql` | Post-hook: dbt `meta` → Snowflake tags (object + column `sensitivity`), then calls `attach_dmfs` |
| `macros/attach_dmfs.sql` | Attaches system DMFs listed in `meta.dmfs` (idempotent, `TRIGGER_ON_CHANGES`) |
| `macros/helpers.sql` | Exact schema names, load timestamp, `dev_sample()` |
| `scripts/gen_raw_vault_yml.py` | Regenerates `models/raw_vault/_raw_vault.yml` (descriptions, domains, sensitivity, DMFs, tests) |
| `setup/01_governance_setup.sql` | One-time grants, roles (`PHI_READER`, `PARTNER_ANALYST`), tags, masking policies |
| `setup/02_cortex_agent.sql` | Cortex Agent definition |
| `semantic/clinical_claims_sv.yaml` | Semantic view YAML (deploy with `cortex agent-studio sv-deploy`) |

## Packages
`packages.yml` installs AutomateDV through the `DBT_DEPS_EAI` external access integration (hub.getdbt.com, codeload.github.com).
The deployed project object has the integration attached, so deploys run `dbt deps` automatically.

## Run
```sql
USE ROLE ATTENDEE_ROLE;
ALTER DBT PROJECT CLINICAL_CLAIMS_DV.DBT_PROJECTS.CLINICAL_CLAIMS_DV
  DEPLOY FROM 'snow://workspace/user$.public."DEFAULT$"/versions/live/clinical_claims_dv';
-- dev sample: every row for patients where MOD(PATIENT_ID, 50) = 0 (~28k patients)
EXECUTE DBT PROJECT CLINICAL_CLAIMS_DV.DBT_PROJECTS.CLINICAL_CLAIMS_DV ARGS = 'build';
-- full load (use a larger warehouse; CLAIMS_TX has 887M rows)
EXECUTE DBT PROJECT CLINICAL_CLAIMS_DV.DBT_PROJECTS.CLINICAL_CLAIMS_DV ARGS = 'build --full-refresh --vars {"patient_sample_mod": null}';
```

## Notes
- Source has no load timestamp; `LOAD_DATETIME` = run start time, `RECORD_SOURCE` = `SYNTHEA_SILVER.<TABLE>`.
- Masking uses `IS_ROLE_IN_SESSION`, so a user who also holds `PHI_READER` as a secondary role sees clear values. Use `USE SECONDARY ROLES NONE` to demo masking.
- `dim_patient` is a view on purpose: a table built by `ATTENDEE_ROLE` would store already-masked values.
