FROM python:3.11.1-slim-buster

#RUN apt-get update && apt-get install -y build-essential apt-utils nodejs npm

# Upgrade pip
RUN pip3 install --upgrade pip setuptools wheel

# Basic packages
RUN pip3 install --no-cache-dir \ 
    pandas numpy scipy tables \
    matplotlib seaborn dash jupyter-dash bokeh streamlit>=1.10 \
    jupyterlab>=3.0.0 jupyterlab_widgets>=1.0.0 ipywidgets>=7.6.2 nbclassic>=0.2.5 \
    scikit-learn spacy \
    pymongo


# Extra packages and cleaning
RUN pip3 install --no-cache-dir \ 
    st_btn_select sdmx1\ 
    && rm -rf /var/lib/apt/lists/*;

WORKDIR /projects

RUN \ 
    jupyter server --generate-config && \
    echo "c.ServerApp.allow_origin = '*'">>~/.jupyter/jupyter_server_config.py  && \
    echo "c.ServerApp.token = ''">>~/.jupyter/jupyter_server_config.py  && \
    echo "c.ServerApp.ip = '0.0.0.0'">>~/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False">>~/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.root_dir = '/projects'">>~/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.allow_root=True">>~/.jupyter/jupyter_server_config.py


#docker build -t python:3.11.1 -f /mnt/c/Users/denma/OneDrive/Projects/Docker/Python/3.11.1/Dockerfile .
#docker run --name jupyter -dp 8888:8888 -v /mnt/c/Users/denma/OneDrive/Projects:/projects -d --restart unless-stopped python:3.11.1 jupyter server 
#docker run --name streamlit -dp 8889:8889 -v /mnt/c/Users/denma/OneDrive/Projects:/projects python:3.11.1 streamlit run /projects/Streamlit/Multiapp/app.py --server.port 8889