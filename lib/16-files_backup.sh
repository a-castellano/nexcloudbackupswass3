#!/bin/bash
#
# **  nextcloud_backups_aws_s3  **
# **       files backup         **
#
# Utility to make backups of Nextcloud and store them in an S3 bucket
# Make files backup using s3cmd
#
# Álvaro Castellano Vela - https://github.com/a-castellano

# Logger
source lib/01-default_values_and_commands.sh
source lib/02-usage.sh
source lib/04-logger.sh


function backup_files_by_user {

    NEXTCLOUD_DATA_DIR="$NEXTCLOUD_PATH/data"
    write_log "Uploading data to S3 bucket."
    if [[ $EXCLUDE_DATABASE = false ]]; then
        write_log "Uploading database backup."
        $S3CMD --access_key="$S3_ACCESS_KEY" --secret_key="$S3_SECRET_KEY" --storage-class=REDUCED_REDUNDANCY sync --delete-removed --recursive --preserve $DATABASE_BACKUP_PATH s3://$S3_BUCKET
    fi

    write_log "Uploading users data folders."
    for user in $USERS_TO_BACKUP
    do
        write_log "Uploading $user's data."
        $S3CMD --access_key="$S3_ACCESS_KEY" --secret_key="$S3_SECRET_KEY" --storage-class=REDUCED_REDUNDANCY sync --delete-removed --recursive --preserve $NEXTCLOUD_DATA_DIR/$user s3://$S3_BUCKET
    done
    write_log "Uploading proccess finished."
}
