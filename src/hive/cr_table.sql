docker exec -ti hive-metastore hive


DROP DATABASE IF EXISTS mdp_demo_db CASCADE;


CREATE DATABASE mdp_demo_db;

USE mdp_demo_db;

DROP TABLE IF EXISTS admission_t;


CREATE EXTERNAL TABLE admission_t (sno INTEGER
					            , mrd_no STRING
					            , date_of_arrival DATE
					            , date_of_departure DATE
					            , age INTEGER
					            , gender STRING
					            , rural STRING
					            , type_of_admission STRING
					            , month_year STRING
					            , duration_of_stay INTEGER
					            , duration_of_intensive_unit_stay INTEGER
					            , outcome STRING
					            , smoking INTEGER
					            , alcohol INTEGER
					            , dm INTEGER
					            , htn INTEGER
					            , cad INTEGER
					            , prior_cmo INTEGER
					            , ckd INTEGER
					            , hb STRING
					            , tlc STRING
					            , platelets STRING
					            , glucose STRING
					            , urea STRING
					            , creatinine STRING
					            , bnp STRING
					            , raised_cardiac_enzymes INTEGER
					            , ef STRING
					            , severe_anaemia INTEGER
					            , anaemia INTEGER
					            , stable_angina INTEGER
					            , acs INTEGER
					            , stemi INTEGER
					            , atypical_chest_pain INTEGER
					            , heart_failure INTEGER
					            , hfref INTEGER
					            , hfnef INTEGER
					            , valvular INTEGER
					            , chb INTEGER
					            , sss INTEGER
					            , aki INTEGER
					            , cva_infract INTEGER
					            , cva_bleed INTEGER
					            , af INTEGER
					            , vt INTEGER
					            , psvt INTEGER
					            , congenital INTEGER
					            , uti INTEGER
					            , neuro_cardiogenic_syncope INTEGER
					            , orthostatic INTEGER
					            , dvt INTEGER
					            , cardiogenic_shock INTEGER
					            , shock INTEGER
					            , pulmonary_embolism INTEGER
					            , chest_infection STRING
)
STORED AS parquet
LOCATION 's3a://mdp-demo-bucket/refined/hospital-admission/admission';

CREATE EXTERNAL TABLE mortality_t (sno INTEGER
					            , mrd_no STRING
					            , age INTEGER
					            , gender STRING
					            , rural_urban STRING
					            , date_of_brought_dead DATE
)
STORED AS parquet
LOCATION 's3a://mdp-demo-bucket/refined/hospital-admission/mortality';


CREATE EXTERNAL TABLE pollution_t (date_of_measurement DATE
					            , aqi INTEGER
					            , pm2_5_avg INTEGER
					            , pm2_5_min INTEGER
					            , pm2_5_max INTEGER
					            , pm10_avg INTEGER
					            , pm10_min INTEGER
					            , pm10_max STRING
					            , no2_avg INTEGER
					            , no2_min INTEGER
					            , no2_max STRING
					            , nh3_avg INTEGER
					            , nh3_min INTEGER
					            , nh3_max INTEGER
					            , so2_avg INTEGER
					            , so2_min INTEGER
					            , so2_max INTEGER
					            , co_avg INTEGER
					            , co_min INTEGER
					            , co_max INTEGER
					            , ozone_avg INTEGER
					            , ozone_min INTEGER
					            , ozone_max STRING
					            , prominent_pollutent STRING
					            , max_temp INTEGER
					            , min_temp INTEGER
					            , humidity INTEGER
)
STORED AS parquet
LOCATION 's3a://mdp-demo-bucket/refined/hospital-admission/pollution';


############

CREATE EXTERNAL TABLE synthea_patient_t (id STRING
              , birthdate date
              , deathdate date
              , ssn string
              , drivers string
              , passport string
              , prefix string
              , first string
              , middle string
              , last string
              , suffix string
              , maiden string
              , marital string
              , race string
              , ethnicity string
              , gender string
              , birthplace string
              , address string
              , city string
              , state string
              , county string
              , fips integer
              , zip integer
              , latitude double
              , longitude double
              , healthcare_expenses double
              , healthcare_coverage double
              , income integer
)
STORED AS parquet
LOCATION 's3a://mdp-demo-bucket/refined/synthea-data/patient';

CREATE EXTERNAL TABLE patient_to_admission_t (id STRING
              , mrd_no STRING
)
STORED AS parquet
LOCATION 's3a://mdp-demo-bucket/refined/hospital-admission/patient_to_admission';

############

DROP DATABASE IF EXISTS mdp_demo_better_db CASCADE;


CREATE DATABASE mdp_demo_better_db;

USE mdp_demo_better_db;


DROP TABLE IF EXISTS raw_vital_signs_t;

CREATE EXTERNAL TABLE raw_vital_signs_t
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION 's3a://mdp-demo-better-bucket/raw/mdp.vital-signs.avro.measurement.v1'
TBLPROPERTIES ('avro.schema.url'='s3a://mdp-demo-better-bucket/meta/avro/VitalSignsMessage.avsc','discover.partitions'='false');  

DROP TABLE IF EXISTS ref_vital_signs_t;

CREATE EXTERNAL TABLE ref_vital_signs_t (ehr_uid STRING
            , operation_type STRING
            , event_name STRING
            , composition_id STRING
            , subject_id STRING
            , systolic DOUBLE
            , systolic_unit STRING
            , diastolic DOUBLE
            , diastolic_unit STRING
            , position STRING
            , position_code STRING
            , cuff_size STRING
            , heart_rate DOUBLE
            , heart_rate_unit STRING
            , respiration_rate DOUBLE
            , respiration_rate_unit STRING
            , weight DOUBLE
            , weight_unit STRING
            , height DOUBLE
            , height_unit STRING
            , system_id STRING
            , comitter STRING
            , time_comitted TIMESTAMP
            , change_type STRING
)
STORED AS parquet
LOCATION 's3a://mdp-demo-better-bucket/refined/vital-signs';


DROP TABLE IF EXISTS ref_vital_signs_temperature_t;

CREATE EXTERNAL TABLE ref_vital_signs_temperature_t (ehr_uid STRING
            , composition_id STRING
            , pos INTEGER
            , temperature DOUBLE
            , temperature_unit STRING
) 
STORED AS parquet
LOCATION 's3a://mdp-demo-better-bucket/refined/vital-signs-temperature';



DROP TABLE IF EXISTS raw_patient_t;

CREATE EXTERNAL TABLE raw_patient_t
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION 's3a://mdp-demo-better-bucket/raw/mdp.patient.avro.state.v1'
TBLPROPERTIES ('avro.schema.url'='s3a://mdp-demo-better-bucket/meta/avro/PatientMessage.avsc','discover.partitions'='false');  

DROP TABLE IF EXISTS ref_patient_t;

CREATE EXTERNAL TABLE ref_patient_t (fullUrl STRING
									, resourceType STRING
                                    , id INTEGER
                                    , mrn_identifier STRING
                                    , active BOOLEAN
                                    , family_name STRING
                                    , given_name STRING
                                    , gender STRING
                                    , birth_date STRING
                                    , street STRING
                                    , city STRING
                                    , postal_code STRING
                                    , country STRING
                                    , photo_content_type STRING
                                    , photo_data STRING
)
STORED AS parquet
LOCATION 's3a://mdp-demo-better-bucket/refined/patient'


