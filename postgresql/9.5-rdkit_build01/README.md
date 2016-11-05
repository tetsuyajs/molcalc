# PostgreSQL用Dockerfile

## 用途・目的


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
`docker run -it --name pgsql-data1 busybox:buildroot-2014.02 sh`
  + 起動してアタッチ後、`exit`で抜けて、コンテナを停止させる
  + `-it`はコンテナをコマンド操作する(アタッチ)するためのオプション
  + `--name pgdql-data1`はコンテナに名前をつけるオプション
  + `busybox:buildroot-2014.02`はコンテナの鋳型となるイメージ名(及びタグ名)
  + `sh`は実行するコマンド。これを指定しないとコンテナはすぐに起動後即終了する
  + `-it`と`sh`を使わないで起動しないコンテナを作成しても良いが、後からボリュームの中身を確認するためにこのようにしている

- PostgreSQLサーバーコンテナの起動
` docker run -d -p 5433:5432 --volumes-from pgsql-data1 --name pgsql-serv1 tetsuyajs/postgresql:9.5-rdkit_build01`
  + `-d`はこのコンテナがデーモンであることを明示しているため、このコンテナはバックグラウンドで起動する
  + `-p 5433:5432`はポートファワーディングの設定。左側がホスト、右側がコンテナのポートを指す
  + この例ではホストのポートを5433にしているのは、既にPostgreSQLがホストにインストールされていた場合に対して。なければ5432でよい
  + `--volumes-from pgsql-data1`はボリュームのマウント先となるコンテナを指定

## 改善点

STOPすると、Exit(137)で異常終了しているので、これに対する対策を講じる必要がある。


