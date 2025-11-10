# Install TOTVS Protheus on openSUSE

## Automatic install :robot:
> Maybe this works??
- Download the Linux installer [25-10-22-INSTALADOR_PROTHEUS_LINUX_12.1.2510.ZIP](https://suporte.totvs.com/portal/p/10098/download?e=1220267)
- Unzip the installer
```bash
unzip 25-10-22-INSTALADOR_PROTHEUS_LINUX_12.1.2510.ZIP
```
- Execute the installer as root
```
sudo su
chmod +x TOTVS12.sh
./TOTVS12.sh
```
- Interact with the installer now:
  - Press `1` to continue, starting the installation.
  - Press `Enter` 3 times to continue, reading the license.
  - Press `1` to accept the license.
  - **Select target path** type in `/totvs/protheus`, check with `1`.
  - **Informe a configuracao do Pais** press enter for `2 [x] Brasil`, check with `1`.
  - **Porta do servico do Appserver** type in `1000`.
  - **Nome do servico do Appserver** type in `totvsappserver`.
  - **Descricao do servico do Appserver** just press `Enter`.
  - **Porta do servico do Webapp** just leave at `4321` and press `Enter`, check with `1`.
  - **DNS License Server** type in `localhost`.
  - **Porta** type in `5555`, check with `1`.
  - Wait until `[ Console installation done ]` is displayed.
- Check the files in `/totvs/protheus` are correct:
```bash
ls /totvs/protheus
# Should output
# .installationinformation .uninstaller dbaccess protheus protheus_data
```


## Download the required files
- TOTVS License Server [25-08-18-TOTVSLICENSE_3.7.0_LINUX.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1137544)
- DBACCESS [25-02-08-TOTVS_DBACCESS_BUILD_24.1.0.2_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168439)
- APPSERVER [25-03-28-P12_APPSERVER_BUILD-24.3.0.5_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168421)
- RPO [24-10-10-REPOSITORIO_DE_OBJETOS_BRASIL_12_1_2410_TTTM120.RPO](https://suporte.totvs.com/portal/p/10098/download?e=1167442)
- WEBAPP [25-08-06-P12_SMARTCLIENT_WEBAPP_10.1.3_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168456)
- MENUS [25-10-06-BRA-MENUS_12_1_2510.ZIP](https://suporte.totvs.com/portal/p/10098/download?e=1217203)
<!-- NOT NEEDED UNTIL FURTHER NOTICE (integration web spreadsheets that escape the brower
- WEBAGENT [25-08-04-P12_SMARTCLIENT_WEB-AGENT_1.0.22_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168423)
-->
## Installing TOTVS License Server
- Decompress the totvslicense archive
```bash
mkdir ~/Downloads/license-files
tar -xf 25-08-18-TOTVSLICENSE_3.7.0_LINUX.TAR.GZ -C ~/Downloads/license-files
cd ~/Downloads/license-files
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
- Now configure the licenses by accessing the [localhost:8020](http://localhost:8020/)

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
> Don't have `postgres` installed? Check this [tutorial](./install_postgres.md)
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

declare -x LD_LIBRARY_PATH="/totvs/protheus;$LD_LIBRARY_PATH"

ulimit -n 32768
ulimit -s 1024
ulimit -m 6144000
ulimit -v 6144000

/totvs/protheus/appsrvlinux
```
- Insert the RPO
```bash
mkdir -p /totvs/protheus/apo
cp 24-10-10-REPOSITORIO_DE_OBJETOS_BRASIL_12_1_2410_TTTM120.RPO /totvs/protheus/apo/tttm120.rpo
```
- Create these folders
```bash
mkdir -p /totvs/protheus/bin/{appbroker,appsec01,appsec02,dbaccess,licenseserver,log}
mkdir -p /totvs/protheus/rpo
mkdir -p /totvs/protheus_data/{system,systemload}
```
- Insert the menu files into system folder
```
unzip 25-10-06-BRA-MENUS_12_1_2510.ZIP -d /totvs/protheus_data/system
```
- Edit the file `/totvs/protheus/appserver.ini`:
```ini
[totvsapp]
SourcePath=/totvs/protheus/apo
RpoCustom=/totvs/protheus/apo/custom.rpo
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
app_environment=totvsapp

[dbaccess]
port=7890
server=localhost
database=postgres
alias=totvsapp

[Drivers]
Active=TCP
MultiProtocolPortSecure=0
MultiProtocolPort=1

[TCP]
TYPE=TCPIP
Port=1000

[Service]
Name=totvsappserver
DisplayName=totvs | appserver 12

[LICENSECLIENT]
server=localhost
port=5555

[WEBAPP]
port=8089
```

<!-- No need for WebAgent for this simple install
## WebAgent Setup (?)
> TODO: What is this for?
- Extract the WebAgent file and install the `.rpm` package
```bash
tar -xzf 25-08-04-P12_SMARTCLIENT_WEB-AGENT_1.0.22_LINUX_X64.TAR.GZ 
sudo zypper in ./web-agent-1.0.22-linux-x64-release.rpm 
# Problema: 1: nada fornece 'libXtst' necessário para o web-agent-1.0.22-1.0.22.0.x86_64 instalado
```
-->

## Smart Client WebApp Setup
- Extract the Smart Client `webapp.so` file in the correct location:
```bash
tar -xf 25-08-06-P12_SMARTCLIENT_WEBAPP_10.1.3_LINUX_X64.TAR.GZ -C /totvs/protheus
```
- Configure the client in `/totvs/protheus/smartclient.ini`: (?)
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
- Test execution with
```bash
chmod +x /totvs/protheus/app.sh
/totvs/protheus/app.sh
```
- Access the [web app at localhost:8089/webapp](http://localhost:8089/webapp/)
- Click the cog icon :gear: and:
  - "Programa Inicial" > "Incluir" > `SIGACFG`
  - "Programa Inicial" > "Incluir" > `SIGAMDI`
  - "Programa Inicial" > "Incluir" > `MPSDU`
  - "Ambiente no servidor" > "Incluir" > `totvsapp`
- Go back and choose `SIGACFG`.
- "Criar uma empresa TESTE".
- .. ?


## TODO: Create services

- Create the file `/usr/lib/systemd/system/totvsdb.service` as root:
```ini
[Unit]
Description=totvs dbaccess
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/totvs/dbaccess/app.sh

[Install]
WantedBy=multi-user.target
```
- Enable the dbaccess service
```bash
systemctl enable totvsdb.service
```
- Create the file `/usr/lib/systemd/system/totvsappserver.service` as root:
```ini
[Unit]
Description=totvs appserver - porta 1000
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/totvs/protheus/app.sh

[Install]
WantedBy=multi-user.target
```
- Enable the appserver service
```bash
systemctl enable totvsappserver.service
```
- Check they worked:
```bash
systemctl start totvsdb
systemctl status totvsdb
# Check if active (running)

systemctl start totvsappserver
systemctl status totvsappserver
```
