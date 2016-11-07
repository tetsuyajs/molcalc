# PostgreSQL用Dockerfile

## 用途・目的
- PostgreSQLを使ったデータベースサーバー
- RDKitがインストールされているので、RDKitを使用して計算化学用の内部関数を構築出来る
- PostgreSQLもソース(tar)をコンパイルしてインストールしているので、このDockerfileを参考に改変されたソースからインストールも可能


## 必要なもの
- イメージ`tetsuyajs/rdkit:2016_03_1-build01`が作成済みであること。詳しくはrdkitディレクトリにて。
- データボリュームコンテナ`pgsql-data1`が起動済みであること(停止中でも可)。
- Dockerfile, postgresql-entrypoint.sh, postgresql.conf, pg_hba.confの4つのファイル。
- postgresql.confとpg_hba.confのconfファイルは各自設定を変更しても使用。そのまま使っても可。


## 使い方

- PostgreSQLイメージの作成
`docker build -t tetsuyajs/postgresql:9.5-rdkit_build01 postgresql/9.5-rdkit_build01`
  + `-t tetsuyajs/postgresql:9.5-rdkit_build01`は作成したイメージに名前とタグを付ける
  + `postgresql/9.5-rdkit_build01`は作成する時の設計図であるDockerfileの場所(相対パス)

- データボリュームコンテナの起動・停止
`docker run -it --name pgsql-data1 -v /usr/local/pgsql/data busybox:buildroot-2014.02 sh`
  + 起動してアタッチ後、`exit`で抜けて、コンテナを停止させる
  + `-it`はコンテナをコマンド操作する(アタッチ)するためのオプション
  + `--name pgdql-data1`はコンテナに名前をつけるオプション
  + `busybox:buildroot-2014.02`はコンテナの鋳型となるイメージ名(及びタグ名)
  + `sh`は実行するコマンド。これを指定しないとコンテナはすぐに起動後即終了する
  + `-it`と`sh`を使わないで起動しないコンテナを作成しても良いが、後からボリュームの中身を確認するためにこのようにしている

- PostgreSQLサーバーコンテナの起動
`docker run -d -p 5433:5432 --volumes-from pgsql-data1 --name pgsql-serv1 tetsuyajs/postgresql:9.5-rdkit_build01`
  + `-d`はこのコンテナがデーモンであることを明示しているため、このコンテナはバックグラウンドで起動する
  + `-p 5433:5432`はポートファワーディングの設定。左側がホスト、右側がコンテナのポートを指す
  + この例ではホストのポートを5433にしているのは、既にPostgreSQLがホストにインストールされていた場合に対して。なければ5432でよい
  + `--volumes-from pgsql-data1`はボリュームのマウント先となるコンテナを指定

- バックアップ方法
`[root ~molcalc] # docker cp pgsql-data1:/usr/local/pgsql/data C:/mnt/pgsql`
  + 現在確立されておらず便宜上の方法
  + 右側に書かれたホストの`C:/mnt/pgsql`上に`data`ディレクトリが作成されており、PostgreSQLのデータが入っている
  + これを適時tar化するなどしてバックアップ

- リストア方法
```
[root ~localhost] # docker stop pgsql-serv1
[root ~localhost] # docker start pgsql-data1
[root ~localhost] # docker attach pgsql-data1
/ # rm -rf /usr/local/pgsql/data/*
/ # (Ctrl+P -> Ctrl+Qでデタッチ)
[root ~localhost] # docker cp C:/mnt/pgsql/data pgsql-data1:/usr/local/pgsql/
[root ~localhost] # docker stop pgsql-data1
[root ~localhost] # docker start pgsql-serv1
```
  + サーバー止めて、データボリュームコンテナを起動させ、アタッチしてデータを消去し、その後バックアップしてあったディレクトリをコピーして、データボリュームコンテナを停止し、サーバーを再起動させているだけ
  + サーバーを作り直しても可


## 備考

### データボリュームコンテナを使用する理由
- ボリュームなしの場合、データのバックアップを取る方法が限られ、複雑化する。また、サーバーコンテナを削除した場合にデータも失われてしまう。
- ホストに直接ボリュームをマウントした場合、ホストのシステムの影響を受ける。例えば、ホストがWindowsだとLinuxとのパーミッションやオーナーの食い違いが生じる。
- データボリュームコンテナにマウントした場合、サーバーコンテナを削除してもデータは消えない。データボリュームコンテナも同じLinuxでシステムを合わせることでパーミッションやオーナーの食い違いを防げる。
- また、データボリュームコンテナを複数用意し、どのコンテナにボリュームをマウントするか切り替えることで複数のデータベースを切り替えうる。
- ここで用いる方法ではデータボリュームコンテナのデータもDockerの隔離された領域のボリュームにマウントしているだけなので、データボリュームコンテナを`export`してもデータはバックアップされない。バックアップする方法は使い方のバックアップを参照。


## 改善点

STOPすると、Exit(137)で異常終了しているので、これに対する対策を講じる必要がある。
バックアップ方法の確立。

