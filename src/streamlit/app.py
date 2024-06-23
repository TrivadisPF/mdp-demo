import streamlit as st
import os
import pandas as pd
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode, DataReturnMode
from bokeh.models.widgets import Button
from bokeh.models import CustomJS
from streamlit_bokeh3_events import streamlit_bokeh3_events
from io import StringIO
import requests
from PIL import Image
from pathlib import Path

# get the value of the WEBHOOK_URL environment variable
URL = os.getenv('WEBHOOK_URL', 'http://18.184.211.93:28511/csv-upload')

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
        
# The Title of the page
st.title("DPoP: Copy & Paste Uploader")

# Render the get clipboard data button
copy_button = Button(label="Get Clipboard Data")
copy_button.js_on_event("button_click", CustomJS(code="""
    navigator.clipboard.readText().then(text => document.dispatchEvent(new CustomEvent("GET_TEXT", {detail: text})))
    """))

result = streamlit_bokeh3_events(
    copy_button,
    events="GET_TEXT",
    key="get_text",
    refresh_on_update=False,
    override_height=75,
    debounce_time=0)


if result:
    if "GET_TEXT" in result:
        df = pd.read_csv(StringIO(result.get("GET_TEXT")))
#        st.table(df)
 
        # Create GridOptions
        gb = GridOptionsBuilder.from_dataframe(df)
        gb.configure_pagination(paginationPageSize=20)  # Number of rows per paggb.configure_default_column(resizable=True)
        gb.configure_default_column(resizable=True)
        gb.configure_grid_options(domLayout='autoWidth')
        gridOptions = gb.build()
 
        # Display the grid
        grid_response = AgGrid(
            df,
            gridOptions=gridOptions,
            update_mode=GridUpdateMode.NO_UPDATE,
            data_return_mode=DataReturnMode.FILTERED_AND_SORTED,
            fit_columns_on_grid_load=True,
            enable_enterprise_modules=True,
            height=400,
            reload_data=True
        )
        
        # Calculate the total number of rows
        total_rows = len(df)

        # Display the total number of rows
        st.write(f"Total number of rows: {total_rows}")
        
        # create to columns to display the edit fields
        col1, col2, col3 = st.columns(3)
        
        with col1:
            domain_name = st.text_input("Domain name", key="domain_name", help="Specify the domain name of the object on the DPoP" )
        with col2:
            object_name = st.text_input("Object name", key="object_name", help="Specify the object name of the object on the DPoP" )
        #stats = df.describe(include="all")
        #st.table(stats)
        
        with col3:
            # Display the button only if a table name has been entered and df is not empty
            if domain_name and object_name and not df.empty:
            
                if st.button(label="Upload Data to DPoP"):
                    csv_data = df.to_csv(header=True, index=False, lineterminator="\r\n")
                    upload_successful = upload(csv_data, domain_name, object_name)

        if upload_successful:            
            st.markdown(f"After a short while the data will be available as the Starburst table `mdp_demo_{domain_name.lower().replace("-",'_')}_db.raw_{object_name.lower().replace("-",'_')}_t`. You can use [Cloudbeaver](http://18.184.211.93:8978) to query it.")