# logbackup

The log backup script allows you to create a backup of a specified log file into a compressed archive.

Before packaging the script will also scan for any errors, failures, or critical log entries and display them to the user. 

## Features

- [x] Log Monitoring: Showing the administrator any potential areas of concern found in the selected log file.
- [x] Easy Backup: One step process of creating compressed archives for long term storage.
- [x] Automation: Easily integrate this script into a schedule cron for automated backups

## Usage

```md
./log_backup.sh -l LOGFILE [options]
```
`-h`: Displays the following help message

`-l LOGFILE`: Specify the log file to back up

`-o DIRECTORY`: Specify the output directory of the archive - current directory default

`-v`: Enable verbose output

## Example 

```md
./log_backup.sh -l /var/log/syslog
```
This will create an archive of the syslog file in the curent working directory and output any errors.
```md
./log_backup.sh -l /var/log/auth.log -o /home/admin/backups -v
```
This will create an archive of the auth.log file in /home/admin/backups, provide verbose output, and display any errors found.
