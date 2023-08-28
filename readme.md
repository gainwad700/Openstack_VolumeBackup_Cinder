# Openstack Volume Backup
This script backups all the volumes that have the property backup enabled.
You can set this property manually on the volumes via Horizon.

It deletes all the backups that are older than 1 day.


# Installation
git clone https://github.com/gainwad700/Openstack_VolumeBackup_Cinder
sh backup.sh