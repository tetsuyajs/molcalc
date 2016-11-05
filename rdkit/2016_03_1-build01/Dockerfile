FROM centos:7

MAINTAINER yamamoto@itmol.com

ENV LANG=en_US.UTF-8


# --------------------------------------
# RDKitインストール開始

ENV RDBASE /usr/local/RDKit_2016_03_1
ENV LD_LIBRARY_PATH /lib:$RDBASE/lib
ENV PYTHONPATH $RDBASE
ADD RDKit_2016_03_1.tgz /usr/local/
ADD INCHI-1-API.ZIP /tmp

RUN set -x \
    && yum install -y gcc-c++ boost-devel make cmake epel-release unzip tar \
    && yum install -y python-devel python-pillow python-pip \
    && yum clean all \
    && pip install pip --upgrade --no-cache-dir \
    && pip install --no-cache-dir numpy scipy \
    && mv /usr/local/rdkit-Release_2016_03_1 /usr/local/RDKit_2016_03_1 \
    && mkdir $RDBASE/External/INCHI-API/src \
    && unzip /tmp/INCHI-1-API.ZIP -d /tmp \
    && cp /tmp/INCHI-1-API/INCHI_API/inchi_dll/* $RDBASE/External/INCHI-API/src \
    && rm -rf /tmp/INCHI-1-API* \
    && mkdir $RDBASE/build \
    && cd $RDBASE/build \
    && cmake -DRDK_BUILD_INCHI_SUPPORT=ON -DBOOST_ROOT=/usr/lib64 -D PYTHON_EXECUTABLE=/usr/bin/python .. \
    && make \
    && make install \
    && rm -rf $RDBASE/Code $RDBASE/build \
    && yum remove -y gcc-c++ boost-devel epel-release python-devel

# RDKitインストール終了
# --------------------------------------

# docker build -t tetsuyajs/rdkit:0.1 -f rdkit-dockerfile .
# docker run -it --name rdkit1 --volumes-from rdkit1-data1 tetsuyajs/rdkit:0.1 bash
