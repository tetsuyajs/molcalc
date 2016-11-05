# PostgreSQL�pDockerfile

## �p�r�E�ړI


## �K�v�Ȃ���
- �C���[�W`tetsuyajs/rdkit:2016_03_1-build01`���쐬�ς݂ł��邱�ƁB�ڂ�����rdkit�f�B���N�g���ɂāB
- �f�[�^�{�����[���R���e�i`pgsql-data1`���N���ς݂ł��邱��(��~���ł���)�B
- Dockerfile, postgresql-entrypoint.sh, postgresql.conf, pg_hba.conf��4�̃t�@�C���B
- postgresql.conf��pg_hba.conf��conf�t�@�C���͊e���ݒ��ύX���Ă��g�p�B���̂܂܎g���Ă��B

## �g����

- PostgreSQL�C���[�W�̍쐬
`docker build -t tetsuyajs/postgresql:9.5-rdkit_build01 postgresql/9.5-rdkit_build01`
  + `-t tetsuyajs/postgresql:9.5-rdkit_build01`�͍쐬�����C���[�W�ɖ��O�ƃ^�O��t����
  + `postgresql/9.5-rdkit_build01`�͍쐬���鎞�̐݌v�}�ł���Dockerfile�̏ꏊ(���΃p�X)

- �f�[�^�{�����[���R���e�i�̋N���E��~
`docker run -it --name pgsql-data1 busybox:buildroot-2014.02 sh`
  + �N�����ăA�^�b�`��A`exit`�Ŕ����āA�R���e�i���~������
  + `-it`�̓R���e�i���R�}���h���삷��(�A�^�b�`)���邽�߂̃I�v�V����
  + `--name pgdql-data1`�̓R���e�i�ɖ��O������I�v�V����
  + `busybox:buildroot-2014.02`�̓R���e�i�̒��^�ƂȂ�C���[�W��(�y�у^�O��)
  + `sh`�͎��s����R�}���h�B������w�肵�Ȃ��ƃR���e�i�͂����ɋN���㑦�I������
  + `-it`��`sh`���g��Ȃ��ŋN�����Ȃ��R���e�i���쐬���Ă��ǂ����A�ォ��{�����[���̒��g���m�F���邽�߂ɂ��̂悤�ɂ��Ă���

- PostgreSQL�T�[�o�[�R���e�i�̋N��
` docker run -d -p 5433:5432 --volumes-from pgsql-data1 --name pgsql-serv1 tetsuyajs/postgresql:9.5-rdkit_build01`
  + `-d`�͂��̃R���e�i���f�[�����ł��邱�Ƃ𖾎����Ă��邽�߁A���̃R���e�i�̓o�b�N�O���E���h�ŋN������
  + `-p 5433:5432`�̓|�[�g�t�@���[�f�B���O�̐ݒ�B�������z�X�g�A�E�����R���e�i�̃|�[�g���w��
  + ���̗�ł̓z�X�g�̃|�[�g��5433�ɂ��Ă���̂́A����PostgreSQL���z�X�g�ɃC���X�g�[������Ă����ꍇ�ɑ΂��āB�Ȃ����5432�ł悢
  + `--volumes-from pgsql-data1`�̓{�����[���̃}�E���g��ƂȂ�R���e�i���w��

## ���P�_

STOP����ƁAExit(137)�ňُ�I�����Ă���̂ŁA����ɑ΂���΍���u����K�v������B


