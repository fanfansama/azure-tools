#Backup:
#docker exec -t -u postgres your-db-container pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
#
#Restore:
#cat your_dump.sql | docker exec -i your-db-container psql -Upostgres


source ./setEnv.sh


export CONNSTR=
export HOSTNAME=192.168.0.31
export DBNAME=nemmodb
export PORT=5432
export NAME=admin

docker run --rm \
    --add-host="localhost:HOSTNAME" \
    -v $TMP_DUMP:/tmp \
    postgres pg_dumpall \
    --file=/tmp/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql \
  #  --dbname=$CONNSTR  \
    --host=$HOSTNAME \
    --database=$DBNAME \
    --port=$PORT \
    --username=$NAME \
    --password







exit 0



Usage:
  pg_dumpall [OPTION]...

General options:
  -f, --file=FILENAME          output file name
  -v, --verbose                verbose mode
  -V, --version                output version information, then exit
  --lock-wait-timeout=TIMEOUT  fail after waiting TIMEOUT for a table lock
  -?, --help                   show this help, then exit

Options controlling the output content:
  -a, --data-only              dump only the data, not the schema
  -c, --clean                  clean (drop) databases before recreating
  -E, --encoding=ENCODING      dump the data in encoding ENCODING
  -g, --globals-only           dump only global objects, no databases
  -O, --no-owner               skip restoration of object ownership
  -r, --roles-only             dump only roles, no databases or tablespaces
  -s, --schema-only            dump only the schema, no data
  -S, --superuser=NAME         superuser user name to use in the dump
  -t, --tablespaces-only       dump only tablespaces, no databases or roles
  -x, --no-privileges          do not dump privileges (grant/revoke)
  --binary-upgrade             for use by upgrade utilities only
  --column-inserts             dump data as INSERT commands with column names
  --disable-dollar-quoting     disable dollar quoting, use SQL standard quoting
  --disable-triggers           disable triggers during data-only restore
  --exclude-database=PATTERN   exclude databases whose name matches PATTERN
  --extra-float-digits=NUM     override default setting for extra_float_digits
  --if-exists                  use IF EXISTS when dropping objects
  --inserts                    dump data as INSERT commands, rather than COPY
  --load-via-partition-root    load partitions via the root table
  --no-comments                do not dump comments
  --no-publications            do not dump publications
  --no-role-passwords          do not dump passwords for roles
  --no-security-labels         do not dump security label assignments
  --no-subscriptions           do not dump subscriptions
  --no-sync                    do not wait for changes to be written safely to disk
  --no-tablespaces             do not dump tablespace assignments
  --no-unlogged-table-data     do not dump unlogged table data
  --on-conflict-do-nothing     add ON CONFLICT DO NOTHING to INSERT commands
  --quote-all-identifiers      quote all identifiers, even if not key words
  --rows-per-insert=NROWS      number of rows per INSERT; implies --inserts
  --use-set-session-authorization
                               use SET SESSION AUTHORIZATION commands instead of
                               ALTER OWNER commands to set ownership

Connection options:
  -d, --dbname=CONNSTR     connect using connection string
  -h, --host=HOSTNAME      database server host or socket directory
  -l, --database=DBNAME    alternative default database
  -p, --port=PORT          database server port number
  -U, --username=NAME      connect as specified database user
  -w, --no-password        never prompt for password
  -W, --password           force password prompt (should happen automatically)
  --role=ROLENAME          do SET ROLE before dump

If -f/--file is not used, then the SQL script will be written to the standard
output.

Report bugs to <pgsql-bugs@lists.postgresql.org>.
