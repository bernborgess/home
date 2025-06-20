# Install TOTVS Protheus on openSUSE

## Download the required files
- TOTVS License Server [24-12-16-TOTVSLICENSE_3.6.3_1_LINUX.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1137544)
- DBACCESS [25-02-08-TOTVS_DBACCESS_BUILD_24.1.0.2_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168439)
- APPSERVER [25-03-28-P12_APPSERVER_BUILD-24.3.0.5_LINUX_X64.TAR.GZ](https://suporte.totvs.com/portal/p/10098/download?e=1168421)

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
cd 24-12-16-TOTVSLICENSE_3.6.3_1_LINUX.TAR.GZ
```
- Run the `install` file as `root`
```bash
sudo su
./install
```
- Accept all terms
- Pick the target path `/totvs/totvslicense`
- Use the default ports and accept the binaries
- Create a initialize script with `vim /totvs/totvslicense/app.sh` and enter:
```bash
#!/bin/bash

declare -x LD_LIBRARY_PATH="/totvs/totvslicense/bin/appserver;"$LD_LIBRARY_PATH

/totvs/totvslicense/bin/appserver/appsrvlinux
```

## Installing DB Access
- Decompress the dbaccess archive pointing to the install folder
```bash
mkdir /totvs/dbaccess
taz -xf 25-02-08-TOTVS_DBACCESS_BUILD_24.1.0.2_LINUX_X64.TAR.GZ -C /totvs/dbaccess
```
- Create a initialize script with `vim /totvs/dbaccess/app.sh` and enter:
```bash
#!/bin/bash

/totvs/dbaccess/multi/dbaccess64
```

## Installing Protheus AppServer
> :construction: Not ready yet...
- Decompress the dbaccess archive pointing to the install folder
```
mkdir /totvs/protheus
tar -xf 25-03-28-P12_APPSERVER_BUILD-24.3.0.5_LINUX_X64.TAR.GZ -C /totvs/protheus
```
- Pick the target path `/totvs/protheus`
- Use service port `1000` instead of `1234`
- Use service name `totvsappserver` instead of `totvs-appserver12`
- DNS License Server is `localhost` on port `5555`
- Create a initialize script with `vim /totvs/protheus/app.sh` and enter:
```bash
#!/bin/bash

declare -x LD_LIBRARY_PATH="/totvs/protheus/protheus/bin/appserver;"$LD_LIBRARY_PATH

ulimit -n 32768
ulimit -s 1024
ulimit -m 6144000
ulimit -v 6144000

/totvs/protheus/protheus/bin/appserver/appsrvlinux
```

## Test Execution
- Add execution permissions to `/totvs` folder
```bash
chmod -R 777 /totvs
```
- Run as `root` and wait for server booting
```bash
/totvs/totvslicense/app.sh
```
- In _another_ `root` shell run
```bash
/totvs/dbaccess/app.sh
```
- Test the database connection with 
```bash
/totvs/dbaccess/dbmonitor
```