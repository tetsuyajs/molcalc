FROM tetsuyajs/rdkit:2016_03_1-build01

ENV LANG en_US.UTF-8


RUN yum install -y git vim-enhanced python-psycopg2 \
    && mkdir -p etc/.vim/dein/repos/github.com/Shougo/dein.vim \
    && git clone https://github.com/Shougo/dein.vim /etc/.vim/dein/repos/github.com/Shougo/dein.vim \
    && pip install django==1.10.3 \
    && useradd work_user
ADD vimrc /etc/vimrc

#RUN /bin/bash -c 'vim -c ":silent! call dein#install() | :q"'
# vimのコマンドラインで`:call dein#install()`を実行

# docker run -it --name devel-data1 busybox:buildroot-2014.02 sh
# docker run -it --name devel-term1 --volumes-from devel-data1 --link pgsql-serv1:postgres -p 8001:8000 tetsuyajs/terminal:rdkit_vi_build01 bash
