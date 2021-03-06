#!/bin/bash
#
# **  nextcloudbackupsawss3  **
# **      check connections     **
#
# Utility to make backups of Nextcloud and store them in an S3 bucket
# Check mysql and s3cmd behavior
#
# Álvaro Castellano Vela - https://github.com/a-castellano

source lib/01-default_values_and_commands.sh
source lib/04-logger.sh

function check_databse_connection {

    if [[ -v VERBOSE ]]; then
        write_log "Testing mysql database connection."
    fi

    TEST=$( mysql -u$DATABASE_USER -p$DATABASE_PASSWD --port=$DATABASE_PORT -h $DATABASE_HOST -Bse "use $DATABASE_NAME" 2> $LOCAL_ERROR_FILE > /dev/null )
    if [[ $? -ne 0 ]]; then
        error_msg=$( $CAT $LOCAL_ERROR_FILE )
        report_error $error_msg
        $RM $LOCAL_ERROR_FILE
        exit 1
    fi
    $RM $LOCAL_ERROR_FILE
}

function check_s3_conection {
    write_log "Testing s3cmd bucket connection."
    TEST=$( s3cmd --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET_KEY info s3://$S3_BUCKET 2> $LOCAL_ERROR_FILE > /dev/null )
    if [[ $? -ne 0 ]]; then
        error_msg=$( $CAT $LOCAL_ERROR_FILE )
        report_error $error_msg
        $RM $LOCAL_ERROR_FILE
        exit 1
    fi
    $RM $LOCAL_ERROR_FILE
}
