FROM continuumio/miniconda3
RUN conda create -n env python=3.6
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH
RUN conda install pip
RUN pip install jupyter numpy matplotlib rise biopython
COPY . .
WORKDIR src/

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "notebook", "/src/Adapter_Finder.ipynb", "/src/SRR020192.fastq","--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root","--NotebookApp.token='cafevenetia'"]
