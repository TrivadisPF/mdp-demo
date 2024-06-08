with prep_vital_signs as (
    SELECT ehrUid            AS ehr_uid
    , operationType          AS operation_type
    , eventName              AS event_name
    , compositionId          AS composition_id
    , vitalSigns.subjectId   AS subject_id
    , vitalSigns.systolic       AS systolic
    , vitalSigns.systolicUnit   AS systolic_unit
    , vitalSigns.diastolic      AS diastolic
    , vitalSigns.diastolicUnit  AS diastolic_unit
    , vitalSigns.position       AS position
    , vitalSigns.positionCode   AS position_code
    , vitalSigns.cuffSize       AS cuff_size
    , vitalSigns.heartRate      AS heart_rate
    , vitalSigns.heartRateUnit  AS heart_rate_unit
    , vitalSigns.respirationRate AS respiration_rate
    , vitalSigns.respirationRateUnit AS respiration_rate_unit
    , vitalSigns.temperatures         AS temperatures
    , vitalSigns.temperatureUnit     AS temperature_unit
    , vitalSigns.weight              AS weight
    , vitalSigns.weightUnit          AS weight_unit
    , vitalSigns.height              AS height
    , vitalSigns.heightUnit          AS height_unit
    , auditDetails.systemId          AS system_id
    , auditDetails.comitter          AS comitter
    , to_timestamp(auditDetails.timeCommitted, "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")     AS time_comitted
    , auditDetails.changeType        AS change_type
    from {{ source('mdp_demo_better_db', 'raw_vital_signs_t') }}
    {% if is_incremental() %}
    where
        last_updated > (select max(last_updated) from {{ this }})
    {% endif %}
)select * 
from prep_vital_signs
