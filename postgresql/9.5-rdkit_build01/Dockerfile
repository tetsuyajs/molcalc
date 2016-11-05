FROM tetsuyajs/rdkit:2016_03_1-build01

MAINTAINER yamamoto@itmol.com


# --------------------------------------
# PostgreSQLインストール開始

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_HOME /usr/local/pgsql
ENV PGLIB $POSTGRES_HOME/lib
ENV PGDATA $POSTGRES_HOME/data
ENV PATH $PATH:$POSTGRES_HOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PGLIB
ADD postgresql-9.5.4.tar.gz /tmp

RUN yum install -y bison flex readline-devel zlib-devel gettext make python-devel \
    && yum clean all \
    && mkdir $POSTGRES_HOME \
    && useradd $POSTGRES_USER \
    && cd /tmp/postgresql-9.5.4 \
    && ./configure --prefix=$POSTGRES_HOME --enable-nls --disable-thread-safety \
        --with-python CC='gcc' CFLAGS='-O3' CXX='gcc' CXXFLAGS='-O3' \
    && gmake \
    && gmake install \
    && mkdir $PGDATA \
    && chown -R $POSTGRES_USER:$POSTGRES_USER $POSTGRES_HOME \
    && rm -rf /tmp/postgresql-9.5.4

ADD postgresql-entrypoint.sh /
ADD postgresql.conf /tmp
ADD pg_hba.conf /tmp

RUN chown $POSTGRES_USER:$POSTGRES_USER /tmp/postgresql.conf \
    && chown $POSTGRES_USER:$POSTGRES_USER /tmp/pg_hba.conf \
    && chown $POSTGRES_USER:$POSTGRES_USER /postgresql-entrypoint.sh

EXPOSE 5432

ENTRYPOINT ["/postgresql-entrypoint.sh"]

# PostgreSQLインストール終了
# --------------------------------------


# 必要なファイル
# Dockerfile
# postgresql-9.5.4.tar.gz
# postgresql.conf
# pg_hba.conf

# イメージを構築する
# `docker build -t tetsuyajs/postgresql:9.5-rdkit_build01 .`

# データボリュームコンテナを起動・停止
# `docker run -it --name pgsql-data1 -v /usr/local/pgsql busyboxy:buildroot-2014.02 /bin/bash`
# (起動したら、exitで停止しながら抜ける)

# コンテナをフォアグラウンドで起動
# `docker run -it --name pgsql-serv1 -p 5432:5432 --volumes-from testvol tetsuyajs/postgresql:9.5-rdkit_build01 /bin/bash`
# (何も出来ないのでCtrl+P Ctrl+Qで抜けること)
# (Ctrl+Cをするとコンテナも終了しつつ抜ける)

# コンテナをバックグラウンドで起動
# `docker run -d --name pgsql-serv1 -p 5432:5432 --volumes-from pgsql-data1 tetsuyajs/postgresql:9.5-rdkit_build01`

# コンテナにbashシェルで接続
# `docker exec -it pgsql-serv1 /bin/bash`
# (docker attachで入るとフォアグラウンドで起動しているサーバープロセスの中で止まる)

# コンテナを終了させる
# `docker stop pgsql-serv1`

# コンテナを削除する
# `docker rm pgsql-serv1`

# イメージを削除する
# `docker rmi tetsuyajs/postgresql:9.5-rdkit_build01`
