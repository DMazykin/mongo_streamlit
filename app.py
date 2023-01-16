import streamlit as st
import numpy as np
import pandas as pd
import pymongo
from pymongo import MongoClient
from pandas.io.json import json_normalize


st.set_page_config(layout="wide",page_title="MongoDB")


# Randomly fill a dataframe and cache it
@st.cache(allow_output_mutation=True)
def get_dataframe():
    return pd.DataFrame(
        np.random.randn(50, 20),
        columns=('col %d' % i for i in range(20)))

def init_db():
    client = MongoClient('mongodb:27017')
    db = client.contracts['Submission']

    return db



#datapoints = list(db.collection_name.find({})
# df = json_normalize(datapoints)
df = get_dataframe()

# Create row, column, and value inputs
ID = st.sidebar.text_input('ID')
UWYear = st.sidebar.selectbox('UW Year', options = range(2020, 2023))

if ID and UWYear:
    record = {
        "ID": ID,
        "UW Year": UWYear,
        "datasets": [{
            "type": "table",
            "data": df.to_json(orient='records')
        }]
        
    }

button = st.sidebar.button('Create')

if button and record:
    db = init_db()
    result = db.insert_one(record)
    st.info(f'One record was added: {result.inserted_id}', icon="ℹ️")




# All records 
all_records = pd.DataFrame(list(init_db().find()))
st.dataframe(all_records)

show_data = st.button('Show all')
if show_data:
    db = init_db().find()
    st.json(list(db))