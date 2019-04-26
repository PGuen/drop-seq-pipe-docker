FROM pwlb/rna-seq-pipeline-base:v0.1.1

#Gets miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.27-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

#Gets the DropSeqPipe v0.4 from github
RUN git clone https://github.com/Hoohm/dropSeqPipe.git && \
    cd dropSeqPipe && \
    git checkout -b temp 48b0050c3e3627ff50f46e2951d05185f47e3fbe

#Creates environment
COPY environment.yaml .
RUN conda env create -v --name dropSeqPipe --file environment.yaml
RUN pip3 install pandas
RUN pip3 install ftputil

COPY ./binaries/gtfToGenePred /usr/bin/gtfToGenePred

#Defines environment variables
ENV TARGETS "all"
ENV SAMPLENAMES ""

#Copies needed files and directories into container
COPY config/config.yaml /config/
COPY scripts /scripts

RUN echo "" >> /dropSeqPipe/Snakefile

ENTRYPOINT ["/bin/bash"]

#Executes run-all.sh
CMD ["/scripts/run-all.sh"]