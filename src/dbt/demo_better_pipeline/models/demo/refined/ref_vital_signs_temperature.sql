with ref_vital_signs_temperature as (
    SELECT vs.ehr_uid
    , vs.composition_id
    , vs.temperature_unit
    , pos
    , temperature
    , vs.time_comitted
    FROM {{ref ('prep_vital_signs')}} AS vs
    LATERAL VIEW posexplode(vs.temperatures) AS pos, temperature
)select * 
from ref_vital_signs_temperature
