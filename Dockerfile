FROM centos:7

MAINTAINER yamamoto@itmol.com




# --------------------------------------
# RDKitインストール開始

# ベースとなるパッケージのインストール
RUN set -x \
    &&  yum install -y gcc-c++ boost-devel make cmake epel-release unzip tar

RUN yum install -y python-devel python-pillow python-pip \
    && pip install pip --upgrade \
    && pip install numpy scipy

ENV RDBASE /usr/local/RDKit_2016_03_1
ENV LD_LIBRARY_PATH /lib:$RDBASE/lib
ENV PYTHONPATH $RDBASE

ADD ./softwares/RDKit_2016_03_1.tgz /usr/local/

RUN mv /usr/local/rdkit-Release_2016_03_1 /usr/local/RDKit_2016_03_1

# INCHIのインクルード
# ここの記述がなくても自動でダウンロードしてインストールしてくれるので、
# 著作関係がまずければここから、

ADD ./softwares/INCHI-1-API.ZIP /tmp

RUN mkdir $RDBASE/External/INCHI-API/src \
    && unzip /tmp/INCHI-1-API.ZIP -d /tmp \
    && cp /tmp/INCHI-1-API/INCHI_API/inchi_dll/* $RDBASE/External/INCHI-API/src \
    && rm -rf /tmp/INCHI-1-API*

# ここまではなくても良いと思われる。

RUN mkdir $RDBASE/build \
    && cd $RDBASE/build \
    && cmake -DRDK_BUILD_INCHI_SUPPORT=ON -DBOOST_ROOT=/usr/lib64 -D PYTHON_EXECUTABLE=/usr/bin/python .. \
    && make \
    && make install

# RDKitインストール終了
# --------------------------------------

# --------------------------------------
# PostgreSQLインストール開始

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_HOME /usr/local/pgsql
ENV PGLIB $POSTGRES_HOME/lib
ENV PGDATA $POSTGRES_HOME/data
ENV PATH $PATH:$POSTGRES_HOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PGLIB

RUN yum install -y bison flex readline-devel zlib-devel gettext \
    && mkdir /usr/local/pgsql \
    && useradd $POSTGRES_USER \
    && chown $POSTGRES_USER:$POSTGRES_USER /usr/local/pgsql

USER $POSTGRES_USER

ADD ./softwares/postgresql-9.5.4.tar.gz /tmp

RUN cd /tmp/postgresql-9.5.4 \
    && ./configure --prefix=/usr/local/pgsql --enable-nls --disable-thread-safety \
        --with-python CC='gcc' CFLAGS='-O3' CXX='gcc' CXXFLAGS='-O3' \
    && gmake \
    && gmake install \
    && mkdir /usr/local/pgsql/data

RUN $POSTGRES_HOME/bin/initdb -D $PGDATA -E UTF8 -W -U postgres --no-locale

RUN pg_ctl start \
    && sleep 5s

USER root

# PostgreSQLインストール終了

# PyMolインストール予定

# AutoDockインストール予定
