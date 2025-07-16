# Install TOTVS Protheus on openSUSE

## Download the required files
- TOTVS License Server [24-12-16-TOTVSLICENSE_3.6.3_1_LINUX.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1137544)
- DBACCESS [25-02-08-TOTVS_DBACCESS_BUILD_24.1.0.2_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168439)
- APPSERVER [25-03-28-P12_APPSERVER_BUILD-24.3.0.5_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168421)
<!-- - SMARTCLIENT HARPIA [25-04-14-P12-SMARTCLIENT_BUILD 20.3.2.12_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1112223) -->

<!-- - RESPOSITORIO [24-08-27_ATUALIZACAO_12.1.33_RH_MI_EXPEDICAO_CONTINUA.ZIP](https://suporte.totvs.com/portal/p/10098/download?e=1043595) -->
<!-- - DICIONARIO DE DADOS [21-10-08-BRA-DICIONARIOS_COMPL_12_1_33.ZIP](https://suporte.totvs.com/portal/p/10098/download?e=1031455) -->
<!-- - MENU - BRASIL [21-10-08-BRA-MENUS_12_1_33.ZIP](https://suporte.totvs.com/portal/p/10098/download?e=1031459) -->
<!-- - HELPS DE CAMPOS/PERGUNTAS DIFERENCIAL - BRASIL [21-10-08-BRA-HELPS_DIF_12_1_33.ZIP](https://suporte.totvs.com/portal/p/10098/download?e=1031458) -->
<!-- - SMARTCLIENT HARPIA (?) [25-05-14-P12_SMARTCLIENT_WEBAPP_9.2.0_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1112226) -->
<!-- - webagent -->

## Installing TOTVS License Server
- Decompress the totvslicense archive
```bash
tar -xf 24-12-16-TOTVSLICENSE_3.6.3_1_LINUX.TAR.GZ
cd 24-12-16-TOTVSLICENSE_3.6.3_1_LINUX
```
- Run the `install` file as `root`
```bash
sudo su
./install
```
- Accept all terms
- Pick the target path `/totvs/totvslicense`
- Use the default ports and accept the binaries
- Check that it works and the service is running with
```bash
systemctl status licenseVirtual.service
```

## Installing DB Access
- Decompress the dbaccess archive pointing to the install folder
```bash
mkdir /totvs/dbaccess
tar -xf 25-02-08-TOTVS_DBACCESS_BUILD_24.1.0.2_LINUX_X64.TAR.GZ -C /totvs/dbaccess
```
- Create a initialize script with `vim /totvs/dbaccess/app.sh` and enter:
```bash
#!/bin/bash

/totvs/dbaccess/multi/dbaccess64
```
- Change the file `/totvs/dbaccess/multi/dbaccess.ini` to contain
```ini
[General]
MAXSTRINGSIZE=500
odbc30=1
clientlibrary=/usr/lib64/libodbc.so
codepage=WIN1252
LicenseServer=localhost
LicensePort=5555
```
- Test the db running (as root)
```bash
chmod +x /totvs/dbaccess/app.sh
/totvs/dbaccess/app.sh
```
- Open `dbmonitor` in another shell (not as root) with
```bash
/totvs/dbaccess/dbmonitor
```
And check that `localhost:7890` works...
- Under "Configurações" > "Postgres", setup the database
  - Ambiente > Novo, enter "totvsapp"
  - Fill in "Usuário" with "Nome" and "Senha"
  - Salvar
- Under "Assistentes" > "Validação de Conexão"
  - Select "Postgres" for "Base de Dados"
  - Type "totvsapp" for the "ambiente"
  - Check that connection is OK


## Installing Protheus AppServer
> :construction: Not ready yet...
- Decompress the appserver archive pointing to the install folder
```bash
mkdir /totvs/protheus
tar -xf 25-03-28-P12_APPSERVER_BUILD-24.3.0.5_LINUX_X64.TAR.GZ -C /totvs/protheus
```
- Create a initialize script with `vim /totvs/protheus/app.sh` and enter:
```bash
#!/bin/bash

declare -x LD_LIBRARY_PATH="/totvs/protheus;"$LD_LIBRARY_PATH

ulimit -n 32768
ulimit -s 1024
ulimit -m 6144000
ulimit -v 6144000

/totvs/protheus/appsrvlinux
```
- Create the folder structure
```bash
mkdir -p /totvs/protheus/bin/{appbroker,appsec01,appsec02,dbaccess,licenseserver,log}
mkdir -p /totvs/protheus/rpo
mkdir -p /totvs/protheus_data/{system,systemload}
```
- Edit the file `/totvs/protheus/appserver.ini`:
```ini
[totvsapp]
SourcePath=/totvs/protheus/
RpoCustom=/totvs/protheus/tlpp.rpo
RootPath=/totvs/protheus_data
StartPath=/system/
x2_path=
RpoDb=top
RpoLanguage=multi
RpoVersion=120
LocalFiles=CTREE
Trace=0
localdbextensions=.dtc
StartSysInDB=1
consolelog=1
topmemomega=50

[general]
consolelog=/totvs/protheus/app-1000.log
maxStringSize=500

[dbaccess]
port=7890
server=localhost
database=postgres
alias=totvsapp

[Drivers]
Active=TCP
MultiProtocolPort=0

[TCP]
TYPE=TCPIP
Port=1000

[Service]
Name=totvsappserver
DisplayName=totvs | appserver 12

[LICENSECLIENT]
server=localhost
port=5555
```
- Test execution with
```bash
chmod +x /totvs/protheus/app.sh
/totvs/protheus/app.sh
```


<!--
## Installing the Smart Client
- Decompress the smartclient archive pointing to the install folder
```bash
mkdir /totvs/smartclient
tar -xf 25-04-14-P12-SMARTCLIENT_BUILD\ 20.3.2.12_LINUX_X64.TAR.GZ -C /totvs/smartclient
```
- Edit the file `/totvs/smartclient/smartclient.ini`
```ini
[config]
lastmainprog=sigamdi,sigacfg,mpsdu
envserver=totvsapp

[drivers]
active=tcp

[tcp]
server=localhost
port=1000
```
- Execute the smartclient (not as root)
```bash
/totvs/smartclient/smartclient
```
- Pick `SIGACFG`
- 

-->
