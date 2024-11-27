import streamlit as st
import requests
import json
import os

# get the value of the WEBHOOK_URL environment variable
URL = os.getenv('VITAL_SIGNS_WEBHOOK_URL', 'http://3.126.248.207:28510/message')

# status flag
upload_successful = False

# Streamlit app layout
st.set_page_config(layout="wide")

# display the USZ logo
st.markdown(
        '<img src="./app/static/usz-logo.png" width=130>',
        unsafe_allow_html=True,
    )

# Uploads a CSV formatted document to the HTTP url provided by the configuration
def upload(csv_data, domain_name, object_name) -> bool:
        
    # URL of the HTTP endpoint to which you want to send the data
    url = f"{URL}"
    
    # Send the CSV data via an HTTP POST request
    headers = {'Content-Type': 'text/csv', 'X-Domain-Name': domain_name, 'X-Object-Name': object_name}
    response = requests.post(url, data=csv_data, headers=headers)    
    
    # Check the response from the server
    if response.status_code == 200:
        st.write("Data sent successfully!")
        return True
    else:
        st.write(f"Failed to send data. Status code: {response.status_code}")
        st.write("Response content:", response.content)
        return False
        
# Render the get clipboard data button# Title
st.title("Simple Streamlit HTTP Client")

# Form to input JSON properties
with st.form(key="json_form"):
    st.text("Blood Pressure")
    systolic = st.number_input("Systolic", value=0)
    diastolic = st.number_input("Diastolic", value=0)
    position_options = ["Standing", "Stitting", "Reclinging", "Lying", "Lying with tilt to left"]
    position = st.selectbox("Position:", position_options)
    cuff_size_options = ["Adult Tight", "Large Addult", "Adult", "Small Adult", "Paediatric/Child", "Infant", "Neonatal"]
    cuff_size = st.selectbox("Cuff size:", cuff_size_options)
    pulse_rate = st.number_input("Pulse Rate", value=60)
    respiration_rate = st.number_input("Respiration Rate", value=60)
    temperature = st.number_input("Body Temperature", value=37)
    weight = st.number_input("Weight", value=0)
    height = st.number_input("Height", value=0)

    # Submit button
    submit_button = st.form_submit_button(label="Submit")

# Construct and send HTTP request
if submit_button:
    # Construct JSON payload
    try:
        payload_ehr = {
        "domain": "christian_bertmann_accenture_com",
        "ehrUid": "6ce8c47e-a4e8-40e7-b16e-443d6d8c0701",
        "operationType": "create",
        "eventName": "Generic USZ event",
        "compositionId": "0b2a157e-f96b-4916-9e87-bab843054010::christian_bertmann_accenture_com::1",
        "newResults": [
            {
            "subject_id": "80a1a732-8853-40b8-8317-34c260af92cd",
            "systolic": [
                systolic
            ],
            "systolic_unit": "mm[Hg]",
            "diastolic": [
                diastolic
            ],
            "diastolic_unit": "mm[Hg]",
            "bp_position": [
                position
            ],
            "bp_position_code": [
                "at1000"
            ],
            "bp_cuff_size": [
                cuff_size
            ],
            "bp_cuff_size_code": [
                "at0015"
            ],
            "heart_rate": [
                pulse_rate
            ],
            "heart_rate_unit": "/min",
            "respiration_rate": [
                respiration_rate
            ],
            "respiration_rate_unit": "/min",
            "temperature": [
                temperature
            ],
            "temperature_unit": "Cel",
            "spO2": [
                100
            ],
            "weight": [
                weight
            ],
            "weight_unit": "kg",
            "height": [
                height
            ],
            "height_unit": "cm"
            }
        ],
        "auditDetails": {
            "@class": "AUDIT_DETAILS",
            "system_id": "christian_bertmann_accenture_com",
            "committer": {
            "@class": "PARTY_IDENTIFIED",
            "name": "guido.schmutz@accenture.com"
            },
            "time_committed": {
            "@class": "DV_DATE_TIME",
            "value": "2024-05-23T10:58:05.629+02:00"
            },
            "change_type": {
            "@class": "DV_CODED_TEXT",
            "value": "creation",
            "defining_code": {
                "@class": "CODE_PHRASE",
                "terminology_id": {
                "@class": "TERMINOLOGY_ID",
                "value": "openehr"
                },
                "code_string": "249"
            }
            }
        }
        } 


        # Display the payload
        #st.write("Constructed JSON Payload:")
        #st.json(payload_ehr)

        # Send POST request
        response = requests.post(URL, json=payload_ehr)

        # Display response
        st.write("Response from HTTP Service: " + str(response.status_code))
    except requests.RequestException as e:
        st.error(f"Error making HTTP request: {e}")