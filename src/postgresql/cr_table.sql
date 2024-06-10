CREATE SCHEMA synthea_data;

DROP TABLE IF EXISTS synthea_data.pg_patient_t;

CREATE  TABLE synthea_data.pg_patient_t (id character varying(50) NOT NULL
              , birthdate character varying(50) NOT NULL
              , deathdate character varying(50)
              , ssn character varying(50) NOT NULL
              , drivers character varying(50) 
              , passport character varying(50)
              , prefix character varying(50)
              , first character varying(50) 
              , middle character varying(50)
              , last character varying(50) 
              , suffix character varying(50)
              , maiden character varying(50)
              , marital character varying(50)
              , race character varying(50) 
              , ethnicity character varying(50)
              , gender character varying(50)
              , birthplace character varying(100)
              , address character varying(50)
              , city character varying(50)
              , state character varying(50)
              , county character varying(50)
              , fips integer
              , zip integer
              , lat numeric
              , long numeric
              , healthcare_expenses numeric
              , healthcare_coverage numeric
              , income integer
              , CONSTRAINT pg_patient_pk PRIMARY KEY (id)
);

COPY synthea_data.pg_patient_t(id, birthdate, deathdate, ssn, drivers, passport, 
prefix, first, middle, last, suffix, maiden, marital, race, ethnicity, gender, 
birthplace, address, city, state, county, fips, zip, lat, long, healthcare_expenses, healthcare_coverage, income ) 
FROM '/data-transfer/synthea-data/patients.csv' DELIMITER ',' CSV HEADER;

