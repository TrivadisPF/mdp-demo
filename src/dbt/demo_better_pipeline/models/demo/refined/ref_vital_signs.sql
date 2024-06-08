with ref_vital_signs as (
    SELECT vs.ehr_uid
    , operation_type
    , event_name
    , composition_id
    , subject_id
    , systolic
    , systolic_unit
    , diastolic
    , diastolic_unit
    , position
    , position_code
    , cuff_size
    , heart_rate
    , heart_rate_unit
    , respiration_rate
    , respiration_rate_unit
    , weight
    , weight_unit
    , height
    , height_unit
    , system_id
    , comitter
    , time_comitted
    , change_type
    FROM prep_vital_signs AS vs
)select * 
from {{ref ('prep_vital_signs')}}
