-- Cortex Agent over the CLINICAL_CLAIMS_SV semantic view (run as ATTENDEE_ROLE).
CREATE OR REPLACE AGENT CLINICAL_CLAIMS_DV.MARTS.CLINICAL_CLAIMS_AGENT
  COMMENT = 'Healthcare clinical & claims analyst built on the CLINICAL_CLAIMS_DV Data Vault'
  PROFILE = '{"display_name": "Clinical & Claims Analyst"}'
  FROM SPECIFICATION $$
models:
  orchestration: auto
orchestration:
  budget:
    seconds: 60
    tokens: 32000
instructions:
  response: >-
    You are a healthcare analytics assistant for a payer/provider analytics team.
    Answer with a short headline sentence, then a compact table. Round currency to whole dollars and
    ratios to one decimal place as percentages. Always state the time period and note that the data is a
    synthetic (Synthea) ~2% patient sample. Never attempt to reveal patient names, SSNs, addresses or other
    direct identifiers; if asked, explain they are masked by Snowflake governance policies.
  orchestration: >-
    Use the clinical_claims_analyst tool for any question about patients, members, providers, payers,
    encounters/visits, claims, costs, coverage, outstanding balances or diagnosed conditions.
    For trends, group by month. When a question is ambiguous about cost, prefer encounter total claim cost.
  sample_questions:
    - question: "Which payers have the lowest coverage ratio?"
    - question: "What are the top 10 active conditions by number of patients?"
    - question: "How many encounters per patient do we see by age band?"
    - question: "What is the outstanding claim balance by month over the last year?"
    - question: "Which provider specialties have the highest average encounter cost?"
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: clinical_claims_analyst
      description: >-
        Text-to-SQL over the CLINICAL_CLAIMS_SV semantic view: patients (demographics, age band, state),
        providers and specialties, payers, encounters (class, cost, payer coverage), claims (charges, payments,
        outstanding balance) and diagnosed conditions.
tool_resources:
  clinical_claims_analyst:
    semantic_view: CLINICAL_CLAIMS_DV.MARTS.CLINICAL_CLAIMS_SV
    execution_environment:
      type: warehouse
      warehouse: DEFAULT_WH
$$;

GRANT USAGE ON AGENT CLINICAL_CLAIMS_DV.MARTS.CLINICAL_CLAIMS_AGENT TO ROLE PHI_READER;
GRANT SELECT ON SEMANTIC VIEW CLINICAL_CLAIMS_DV.MARTS.CLINICAL_CLAIMS_SV TO ROLE PHI_READER;
