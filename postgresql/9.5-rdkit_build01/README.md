# PostgreSQL�pDockerfile

## �p�r�E�ړI
- PostgreSQL���g�����f�[�^�x�[�X�T�[�o�[
- RDKit���C���X�g�[������Ă���̂ŁARDKit���g�p���Čv�Z���w�p�̓����֐����\�z�o����
- PostgreSQL���\�[�X(tar)���R���p�C�����ăC���X�g�[�����Ă���̂ŁA����Dockerfile���Q�l�ɉ��ς��ꂽ�\�[�X����C���X�g�[�����\


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
`docker run -it --name pgsql-data1 -v /usr/local/pgsql/data busybox:buildroot-2014.02 sh`
  + �N�����ăA�^�b�`��A`exit`�Ŕ����āA�R���e�i���~������
  + `-it`�̓R���e�i���R�}���h���삷��(�A�^�b�`)���邽�߂̃I�v�V����
  + `--name pgdql-data1`�̓R���e�i�ɖ��O������I�v�V����
  + `busybox:buildroot-2014.02`�̓R���e�i�̒��^�ƂȂ�C���[�W��(�y�у^�O��)
  + `sh`�͎��s����R�}���h�B������w�肵�Ȃ��ƃR���e�i�͂����ɋN���㑦�I������
  + `-it`��`sh`���g��Ȃ��ŋN�����Ȃ��R���e�i���쐬���Ă��ǂ����A�ォ��{�����[���̒��g���m�F���邽�߂ɂ��̂悤�ɂ��Ă���

- PostgreSQL�T�[�o�[�R���e�i�̋N��
`docker run -d -p 5433:5432 --volumes-from pgsql-data1 --name pgsql-serv1 tetsuyajs/postgresql:9.5-rdkit_build01`
  + `-d`�͂��̃R���e�i���f�[�����ł��邱�Ƃ𖾎����Ă��邽�߁A���̃R���e�i�̓o�b�N�O���E���h�ŋN������
  + `-p 5433:5432`�̓|�[�g�t�@���[�f�B���O�̐ݒ�B�������z�X�g�A�E�����R���e�i�̃|�[�g���w��
  + ���̗�ł̓z�X�g�̃|�[�g��5433�ɂ��Ă���̂́A����PostgreSQL���z�X�g�ɃC���X�g�[������Ă����ꍇ�ɑ΂��āB�Ȃ����5432�ł悢
  + `--volumes-from pgsql-data1`�̓{�����[���̃}�E���g��ƂȂ�R���e�i���w��

- �o�b�N�A�b�v���@
`[root ~molcalc] # docker cp pgsql-data1:/usr/local/pgsql/data C:/mnt/pgsql`
  + ���݊m������Ă��炸�֋X��̕��@
  + �E���ɏ����ꂽ�z�X�g��`C:/mnt/pgsql`���`data`�f�B���N�g�����쐬����Ă���APostgreSQL�̃f�[�^�������Ă���
  + �����K��tar������Ȃǂ��ăo�b�N�A�b�v

- ���X�g�A���@
```
[root ~localhost] # docker stop pgsql-serv1
[root ~localhost] # docker start pgsql-data1
[root ~localhost] # docker attach pgsql-data1
/ # rm -rf /usr/local/pgsql/data/*
/ # (Ctrl+P -> Ctrl+Q�Ńf�^�b�`)
[root ~localhost] # docker cp C:/mnt/pgsql/data pgsql-data1:/usr/local/pgsql/
[root ~localhost] # docker stop pgsql-data1
[root ~localhost] # docker start pgsql-serv1
```
  + �T�[�o�[�~�߂āA�f�[�^�{�����[���R���e�i���N�������A�A�^�b�`���ăf�[�^���������A���̌�o�b�N�A�b�v���Ă������f�B���N�g�����R�s�[���āA�f�[�^�{�����[���R���e�i���~���A�T�[�o�[���ċN�������Ă��邾��
  + �T�[�o�[����蒼���Ă���


## ���l

### �f�[�^�{�����[���R���e�i���g�p���闝�R
- �{�����[���Ȃ��̏ꍇ�A�f�[�^�̃o�b�N�A�b�v�������@�������A���G������B�܂��A�T�[�o�[�R���e�i���폜�����ꍇ�Ƀf�[�^�������Ă��܂��B
- �z�X�g�ɒ��ڃ{�����[�����}�E���g�����ꍇ�A�z�X�g�̃V�X�e���̉e�����󂯂�B�Ⴆ�΁A�z�X�g��Windows����Linux�Ƃ̃p�[�~�b�V������I�[�i�[�̐H���Ⴂ��������B
- �f�[�^�{�����[���R���e�i�Ƀ}�E���g�����ꍇ�A�T�[�o�[�R���e�i���폜���Ă��f�[�^�͏����Ȃ��B�f�[�^�{�����[���R���e�i������Linux�ŃV�X�e�������킹�邱�ƂŃp�[�~�b�V������I�[�i�[�̐H���Ⴂ��h����B
- �܂��A�f�[�^�{�����[���R���e�i�𕡐��p�ӂ��A�ǂ̃R���e�i�Ƀ{�����[�����}�E���g���邩�؂�ւ��邱�Ƃŕ����̃f�[�^�x�[�X��؂�ւ�����B
- �����ŗp������@�ł̓f�[�^�{�����[���R���e�i�̃f�[�^��Docker�̊u�����ꂽ�̈�̃{�����[���Ƀ}�E���g���Ă��邾���Ȃ̂ŁA�f�[�^�{�����[���R���e�i��`export`���Ă��f�[�^�̓o�b�N�A�b�v����Ȃ��B�o�b�N�A�b�v������@�͎g�����̃o�b�N�A�b�v���Q�ƁB


## ���P�_

STOP����ƁAExit(137)�ňُ�I�����Ă���̂ŁA����ɑ΂���΍���u����K�v������B
�o�b�N�A�b�v���@�̊m���B

