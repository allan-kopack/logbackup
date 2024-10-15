#!/bin/bash

output_dir=$(pwd)
logfile=""
verb=false

#HELP
usage() {
    echo -e "______________________________\n"
    echo "Usage: $0 -l LOGFILE [options]"
    echo "Options:"
    echo "  -h      Display help message"
    echo "  -o      Specify output directory for the backup package: current directory default"
    echo "  -v      Enable verbose output"
    echo -e "______________________________\n"
    exit 1
}

#ARGS
while getopts "ho:l:v" OPTION; do
    case $OPTION in
        h)
            usage
            ;;
        o)
            output_dir="$OPTARG"
            ;;
        l)
            logfile="$OPTARG"
            ;;
        v)
            verb=true
            ;;
        ?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

#MAKE SURE LOGFILE IS PROVIDED
if [ -z "$logfile" ]; then
    echo "Error: Log file is required."
    usage
fi

#MAKE SURE LOGFILE EXISTS
if [ ! -f "$logfile" ]; then
    echo "Error: $logfile not found."
    usage
    exit 1
fi

verbose() {
    if [ "$verb" = true ]; then
        echo "[INFO] $1"
    fi
}

#REGEX CHECK FOR ANY ERRORS IN LOGFILE 
verbose "Checking for errors, failures, or critical events..."
errors=$(grep -E "error|fail|critical" "$logfile")

#PRINT ERRORS IF FOUND
if [ -n "$errors" ]; then
    echo -e "!!!!ERRORS FOUND IN THE LOG FILE!!!!\n"
    echo -e "______________________________\n"
    echo "$errors"
    echo -e "______________________________\n"
else
    echo "No errors found"
fi

#CAPTURE TIMESTAMP AND CREATE ARCHIVE FILENAME
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
backup_file="$output_dir/$(basename "$logfile" .log)_backup_$timestamp.tar.gz"

#TAR THE LOGFILE SNAPSHOT
verbose "Creating backup tar file..."
tar -czf "$backup_file" "$logfile"

#VERIFY IF TAR WAS SUCCESSFUL
if [ -f "$backup_file" ]; then
    echo "Backup successful! File created at: $timestamp"
else
    echo "Error: Backup failed!!!!!"
    exit 1
fi