# molcalc





## コンテナ構築テスト

### 1
`docker run --name testvol -v /C:/mnt/dshare:/mnt busybox:buildroot-2014.02`

### 2
`docker build -t tetsuyajs/postgresql:0.1 -f postgresql-dockerfile .`

### 3
`docker run -it --name pgsql1 -p 5434:5432 --volumes-from testvol tetsuyajs/postgresql:0.1 bash`

### x
`docker ps -a`
`docker exec -it pgsql1 bash`
`docker rm pgsql1`

