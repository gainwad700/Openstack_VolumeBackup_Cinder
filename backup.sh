#!/bin/bash
. /root/.scripts/admin-openrc.sh
disks_to_backup=$(openstack volume list --long --all-projects | grep 'backup' | awk '{print $2}')
time=$(date +'%d-%m-%H:%M:%S')
for disk in $disks_to_backup; do
        project_id=$(openstack volume show $disk -f value -c os-vol-tenant-attr:tenant_id)
        openstack --os-project-id $project_id volume backup create --name $time$disk $disk --force
        echo $disk
done

#Delete backups older than 5 days
# Calculate the date 5 days ago in UTC timezone
five_days_ago=$(date -u -d '5 days ago' '+%s')

current_time=$(date +%s)

# Get the list of all volume backups older than 5 days and store their IDs in an array
all_backups=$(openstack volume backup list --all-projects -f value -c ID)
for backup in $all_backups; do
        backup_creation_time=$(date -d "$(openstack volume backup show "$backup" -f value -c created_at)" +%s)
        # Compare the backup age with the threshold
        if [ $five_days_ago -gt $backup_creation_time ]; then
                echo "Backup is older than 5 days."
                # Add your actions here, such as deleting the old backup or initiating a new backup.
                openstack volume backup delete $backup
        else
                echo "Backup is not older than 5 days."
                # Add your actions here if needed.
        fi

done