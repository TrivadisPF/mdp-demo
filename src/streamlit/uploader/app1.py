import streamlit as st
from bokeh.models import CustomJS
from streamlit_bokeh_events import streamlit_bokeh_events
from streamlit.components.v1 import html

# Streamlit app title
st.title("Streamlit Button with Custom JavaScript (Bokeh 3)")

# Create a Streamlit button
if st.button("Click Me"):
    # Define a CustomJS callback
    custom_js_code = """
    <script>
    document.dispatchEvent(new CustomEvent("BUTTON_CLICKED", {detail: "Streamlit button clicked!"}));
    </script>
    """
    # Embed the JavaScript in the Streamlit app
    html(custom_js_code)

# CustomJS code to listen to the BUTTON_CLICKED event and trigger STREAMLIT_BUTTON_CLICKED
custom_js_event = CustomJS(code="""
document.addEventListener("BUTTON_CLICKED", function(event) {
    console.log(event.detail);
    document.dispatchEvent(new CustomEvent("STREAMLIT_BUTTON_CLICKED", {detail: event.detail}));
});
""")

# Use streamlit_bokeh_events to capture the custom JavaScript event
result = streamlit_bokeh_events(
    custom_js_event,
    events="STREAMLIT_BUTTON_CLICKED",
    key="streamlit_button_click",
    debounce_time=0
)

# Display a message in Streamlit when the custom event is triggered
if result and "STREAMLIT_BUTTON_CLICKED" in result:
    st.write(result["STREAMLIT_BUTTON_CLICKED"])
