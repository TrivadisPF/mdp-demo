# Transformationen mit Apache Spark in Apache Zeppelin

Auf dieser Seite sind die Code-Snippets zu finden, die in Apache Zeppelin zu verwenden sind. 

### von Raw zu Prepared

```sql
%sql
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
FROM raw_vital_signs
```

### Table auf Rohdaten

```
%sql
CREATE DATABASE IF NOT EXISTS mdp_demo_test_db;

USE mdp_demo_test_db;
```

```
%sql
DROP TABLE IF EXISTS raw_guidotest_vital_signs_t;

CREATE EXTERNAL TABLE raw_guiotest_vital_signs_t
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION 's3a://<bucketName>/<path>'
TBLPROPERTIES ('avro.schema.url'='s3a://mdp-demo-better-bucket/meta/avro/VitalSignsMessage.avsc','discover.partitions'='false');  
```

### von Prepared zu Refined


```sql
%sql
SELECT vs.ehr_uid
, vs.composition_id
, vs.temperature_unit
, pos
, temperature
FROM prep_vital_signs AS vs
LATERAL VIEW posexplode(vs.temperatures) AS pos, temperature
```


```sql
%pyspark
refinedVitalSignsDf = spark.sql("""
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
""")
```

### Erstellen der Hive Tables

```sql
CREATE DATABASE mdp_demo_test_db;

USE mdp_demo_test_db;

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
```