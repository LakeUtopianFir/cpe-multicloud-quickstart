export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"

apk add --update postgresql-client

echo Check gvp database
psql -h ${gvp_pg_db_server} -tc "SELECT 1 FROM pg_database WHERE datname = '${gvp_cm_pg_db_name}'"| grep -q 1 || \
    psql -h ${gvp_pg_db_server} -c "CREATE DATABASE \"${gvp_cm_pg_db_name}\""

echo Check $gvp_cm_pg_db_user user
psql -h ${gvp_pg_db_server} -tc "SELECT 1 FROM pg_user WHERE usename = '$gvp_cm_pg_db_user'"| grep -q 1
if [ $? -ne 0 ]; then
    psql -h ${gvp_pg_db_server} -c "CREATE USER $gvp_cm_pg_db_user WITH SUPERUSER LOGIN CONNECTION LIMIT -1 PASSWORD '$gvp_cm_pg_db_password'"
fi
psql -h ${gvp_pg_db_server} -c "GRANT all privileges on database \"${gvp_cm_pg_db_name}\" to $gvp_cm_pg_db_user"