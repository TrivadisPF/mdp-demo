#!/bin/sh

#echo "copy docker-compose.override.yml"
#cp -rv ./docker-compose.override.yml $DATAPLATFORM_HOME/

echo "copy NiFi JDBC Jars"
cp -rv ./infra/nifi/jdbc-driver/*.jar $DATAPLATFORM_HOME/plugins/nifi/addl-jars/

echo "copy NiFi requirements.txt with the Python modules to install inside NiFi"
cp -rv ./infra/nifi/python/requirements.txt $DATAPLATFORM_HOME/custom-conf/nifi/requirements.txt

echo "downloading addidional NiFi NARs"
wget https://repo1.maven.org/maven2/org/apache/nifi/nifi-hive3-nar/1.25.0/nifi-hive3-nar-1.25.0.nar
wget wget https://repo1.maven.org/maven2/org/apache/nifi/nifi-hive-services-api-nar/1.25.0/nifi-hive-services-api-nar-1.25.0.nar

cp -rv *.nar $DATAPLATFORM_HOME/plugins/nifi/nars/
rm *.nar

mkdir -p $DATAPLATFORM_HOME/data-transfer/landing-area/admission

echo "copy airflow pipelines"
cp -rv ./airflow/*.py $DATAPLATFORM_HOME/scripts/airflow/dags

# at the moment platys is using directly the ../src folder
#echo "deploy streamlit apps"
#mkdir -p $DATAPLATFORM_HOME/scripts/streamlit/apps/csv-uploader
#cp -rm ./streamlit/csv-uploader/*.* $DATAPLATFORM_HOME/scripts/streamlit/apps/csv-uploader

#mkdir -p $DATAPLATFORM_HOME/scripts/streamlit/apps/vital-signs-sim
#cp -rm ./streamlit/vital-signs-sim/*.* $DATAPLATFORM_HOME/scripts/streamlit/apps/vital-signs-sim