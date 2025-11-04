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
- Change user to `postgres` and define the database password (Change the `PASSWORD` variable)
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
```apacheconf
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
to, changing `md5` in these 3 places:
```apacheconf
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            ident
host    replication     all             ::1/128                 ident
```
- Restart the database service
```bash
systemctl restart postgresql
```

## Configure ODBC Connection
- Check the name of the ODBC driver that was created in `/etc/unixODBC/odbcinst.ini`, for example:
```ini
[PSQL]
Description=PostgreSQL
Driver64=/usr/lib64/psqlodbcw.so
UsageCount=1
```
  here the name we want is `PSQL`.
- Edit the file `/etc/unixODBC/odbc.ini` to contain (change the `Driver` and `Password`)
```ini
[totvsapp]
Description=PostgreSQL
Driver=PSQL
Trace=Yes
TraceFile=/tmp/psqlodbc_totvsapp.log
Servername=127.0.0.1
Database=totvsapp
UserName=totvsapp
Password=changeme
Port=5432
ReadOnly=No
RowVersioning=No
ShowSystemTables=No
ShowOidColumn=No
FakeOidIndex=No
ConnSettings=
```
- Test the connection (should appear "Connected!")
```bash
isql -v totvsapp
```

## DBeaver tool for database visualization
- Install [flatpak](https://flathub.org/en/setup/openSUSE) from the command line with zypper
```
sudo zypper install flatpak
```
- Add the Flathub repository
```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
- Reboot the system to use Flathub.
- Install `dbeaver` from [Flathub](https://flathub.org/en/apps/io.dbeaver.DBeaverCommunity):
```
flatpak install flathub io.dbeaver.DBeaverCommunity
```
- Run it from command line, or from the start menu, on the "Development" section
```
flatpak run io.dbeaver.DBeaverCommunity
```
- When the app launches, create a new PostgreSQL connection
- Under `Authentication` add the database `Password`
- Tick `Show all databases`
- Click on `Test Connection ...` and download the drivers.
- Check that the `totvsapp` database is created on the interface
<img width="353" height="335" alt="dbeaver-totvsapp" src="https://github.com/user-attachments/assets/b3b5fbc9-ea90-4991-8b82-233326ed8c69" />
