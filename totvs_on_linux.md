# Install TOTVS Protheus on openSUSE

## Download the required files
- totvslicense
- dbaccess
- protheus appserver
- webagent

## General Setup
- Create and give access to the `totvs` directory
```sh
mkdir /totvs
chmod -R 777 /totvs
```

## Installing TOTVS License Server
- Decompress the totvslicense archive
- Run the `./install` file as `root`
- Accept all terms
- Pick the target path `/totvs/totvslicense`
- Use the default ports and accept the binaries
- Create a initialize script with `vim /totvs/totvslicense/app.sh` and enter:
```bash
#!/bin/bash

declare -x LD_LIBRARY_PATH="/totvs/totvslicense/bin/appserver;"$LD_LIBRARY_PATH

/totvs/totvslicense/bin/appserver/appsrvlinux
```


## Installing Protheus AppServer
- Decompress the appserver archive
- Run the `./TOTVS12.sh` file as `root`
- Accept all terms
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

<!-- TODO: Check the actual way to download dbaccess -->
## Installing DB Access
- Move the folder from the protheus installation with 
```
mv /totvs/protheus/dbaccess /totvs/dbaccess
```
- Create a initialize script with `vim /totvs/dbaccess/app.sh` and enter:
```bash
#!/bin/bash

/totvs/dbaccess/dbaccess64
```

## Test Execution
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