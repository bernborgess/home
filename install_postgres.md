# Installing PostgreSQL on OpenSuse Leap 15.6

## Install PostgreSQL and tools
- Open a terminal as root (`sudo su`)
- Install db and dependencies
```bash
zypper in postgresql postgresql-server postgresql-contrib unixODBC postgresql-plperl postgresql-plpython postgresql-pltcl
```
- Start and enable the postgresql service
```bash
systemctl enable postgresql && systemctl start postgresql
```
- Define the database password
```bash
passwd postgres
```
- Create and give permissions to db directory
```bash
mkdir /postgres
chown -R postgres /postgres
```
- Change user to `posgres` and define the database password (Change the `PASSWORD` variable)
```bash
su postgres
PASSWORD=changeme
psql -c "alter user postgres with password '$PASSWORD'" -d template1
```
- Create directory for tablespace data and index
```bash
mkdir -p /postgres/pgdata/totvsapp/{data,index}
```
- Create new database user for `totvsapp` (Change to another `PASSWORD`)
```bash
PASSWORD=changeme
psql -c "create user totvsapp with login nosuperuser inherit createdb nocreaterole noreplication connection limit -1 password '$PASSWORD'"
```
- Create tablespaces for data and index
```bash
psql -c "create tablespace totvsapp_data owner totvsapp location '/postgres/pgdata/totvsapp/data'"
psql -c "create tablespace totvsapp_index owner totvsapp location '/postgres/pgdata/totvsapp/index'"
```
- Create the `totvapp` database
```bash
psql -c "create database totvsapp with owner totvsapp template = template0 encoding = 'WIN1252' lc_collate = 'C' lc_ctype = 'C' tablespace = totvsapp_data connection limit -1"
```
- Find and alter the `/var/lib/pgsql/data/pg_hba.conf` file as root from
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            ident
host    replication     all             ::1/128                 ident


```









//-- Localizar e alterar arquivo com a forma de autenticacao do banco
find / -name "pg_hba.conf"
nano /var/lib/pgsql/data/pg_hba.conf

//-- Reiniciar o servico do banco
systemctl restart postgresql

//-- Localizar o arquivo de configuracoes ODBC e criar uma nova conexao odbc
find / -name "odbc.ini"
nano /etc/unixODBC/odbc.ini

[totvsapp]
Description=PostgreSQL
Driver=PSQL
Trace=Yes
TraceFile=/tmp/psqlodbc_totvsapp.log
Servername=127.0.0.1
Database=totvsapp
UserName=totvsapp
Password=totvsapp
Port=5432
ReadOnly=No
RowVersioning=No
ShowSystemTables=No
ShowOidColumn=No
FakeOidIndex=No
ConnSettings=

nano /etc/unixODBC/odbcinst.ini

//-- Testar a conexao
isql -v totvsapp

//-- instalar snapd para instalar dbeaver
sudo zypper addrepo --refresh https://download.opensuse.org/reposit... snappy
sudo zypper --gpg-auto-import-keys refresh
sudo zypper dup --from snappy
sudo zypper in snapd
sudo systemctl enable --now snapd
sudo systemctl enable --now snapd.apparmor

//-- Instalar o dbeaver
sudo snap install dbeaver-ce
