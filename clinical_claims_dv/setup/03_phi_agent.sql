-- PHI-restricted agent that resolves patients by name and asks the de-identified
-- CLINICAL_CLAIMS_AGENT about them through GOVERNANCE.ASK_CLAIMS_AGENT (agent-to-agent).
-- Run as ATTENDEE_ROLE. Prerequisites: PHI_ONLY row access policy, MARTS.PATIENT_IDENTITY (dbt),
-- MARTS.PATIENT_IDENTITY_SV (semantic/patient_identity_sv.yaml), GOVERNANCE.ASK_CLAIMS_AGENT.

CREATE OR REPLACE AGENT CLINICAL_CLAIMS_DV.MARTS.CLINICAL_CLAIMS_PHI_AGENT
  COMMENT = 'PHI_READER-only: name-based patient lookup chained to the Clinical & Claims agent'
  PROFILE = '{"display_name": "Clinical & Claims Analyst (PHI)"}'
  FROM SPECIFICATION $$
models:
  orchestration: auto
orchestration:
  budget:
    seconds: 120
    tokens: 48000
instructions:
  orchestration: >-
    You serve authorized PHI_READER users who need clinical or claims information about a specific, named patient.
    Step 1: always call patient_identity_lookup first to resolve the patient (name, optionally birth date or location) to PATIENT_ID.
    If no patient matches, say so and stop. If more than one patient matches, list the candidates (name, birth date, city, state,
    PATIENT_ID) and ask the user which one they mean before continuing.
    Step 2: once exactly one PATIENT_ID is known, call ask_claims_agent with a question that refers to the patient ONLY by
    PATIENT_ID (never pass names, birth dates or addresses to ask_claims_agent).
    Step 3: combine the answer with the patient's name from Step 1.
    If either tool returns 'ACCESS DENIED' or no rows, tell the user that identified lookups require the PHI_READER role and stop.
  response: >-
    Start with one line identifying the patient (full name, PATIENT_ID, birth date, city/state), then give the clinical or
    claims answer as returned by the Clinical & Claims agent, keeping its tables and time period. Round currency to whole dollars.
    Note that the data is a synthetic (Synthea) ~2% patient sample. Do not reveal SSN, driver's licence, passport or address.
  sample_questions:
    - question: "Show encounters and total encounter cost for Hollis Dicki"
    - question: "What active conditions does the patient named Becker have?"
    - question: "What is the outstanding claim balance for Hollis Dicki?"
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: patient_identity_lookup
      description: >-
        Resolve a patient's first name, last name, birth date, city or state to PATIENT_ID using the PHI-restricted
        PATIENT_IDENTITY_SV semantic view. Returns no rows unless the user has the PHI_READER role.
  - tool_spec:
      type: generic
      name: ask_claims_agent
      description: >-
        Ask the de-identified Clinical & Claims agent a question about patients, encounters, claims, costs, coverage,
        outstanding balances or conditions. Refer to patients only by PATIENT_ID. Returns the agent's text answer, or
        'ACCESS DENIED' if PHI_READER is not in session.
      input_schema:
        type: object
        properties:
          question:
            type: string
            description: "Natural-language question that refers to the patient only by PATIENT_ID, e.g. 'How many encounters did patient 1306300 have?'"
        required: [question]
tool_resources:
  patient_identity_lookup:
    semantic_view: CLINICAL_CLAIMS_DV.MARTS.PATIENT_IDENTITY_SV
    execution_environment:
      type: warehouse
      warehouse: DEFAULT_WH
  ask_claims_agent:
    type: procedure
    identifier: CLINICAL_CLAIMS_DV.GOVERNANCE.ASK_CLAIMS_AGENT
    execution_environment:
      type: warehouse
      warehouse: DEFAULT_WH
      query_timeout: 120
$$;

-- Only PHI_READER can use the agent and its tools
GRANT USAGE ON AGENT CLINICAL_CLAIMS_DV.MARTS.CLINICAL_CLAIMS_PHI_AGENT TO ROLE PHI_READER;
GRANT SELECT ON SEMANTIC VIEW CLINICAL_CLAIMS_DV.MARTS.PATIENT_IDENTITY_SV TO ROLE PHI_READER;
GRANT USAGE ON PROCEDURE CLINICAL_CLAIMS_DV.GOVERNANCE.ASK_CLAIMS_AGENT(STRING) TO ROLE PHI_READER;
