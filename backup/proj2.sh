#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Enter: $0 <src-dir> <backup-destination> <backup-interval> <max-backup-count>"
    exit 1
fi

SRC_PATH=$1
BACKUP_DEST=$2
INTERVAL_TIME=$3
MAX_BACKUP_COUNT=$4

if [ ! -d "$SRC_PATH" ]; then
    echo "Error: The source path '$SRC_PATH' does not exist!"
    exit 1
fi

if [ ! -d "$BACKUP_DEST" ]; then
    echo "Backup destination '$BACKUP_DEST' is absent. Creating it now..."
    mkdir -p "$BACKUP_DEST"
fi
    
    gettime() {
    date +"%Y-%m-%d-%H-%M-%S"
}

execute_initial_backup() { 
    CURRENT_TIME=$(gettime)
    BACKUP_FOLDER="$BACKUP_DEST/$CURRENT_TIME"
    echo "Starting initial backup from '$SRC_PATH' to '$BACKUP_FOLDER'..."
    cp -r "$SRC_PATH" "$BACKUP_FOLDER"
    ls -lR "$SRC_PATH" > "$BACKUP_FOLDER/directory_snapshot.prev"
}

backup_on_change() {
    CURRENT_TIME=$(gettime)
    NEW_BACKUP_FOLDER="$BACKUP_DEST/$CURRENT_TIME"
    LAST_BACKUP_DIR=$(ls -1t "$BACKUP_DEST" | head -n 1)

    mkdir -p $NEW_BACKUP_FOLDER

    ls -lR "$SRC_PATH" > "$NEW_BACKUP_FOLDER/directory_snapshot.current"
    if [ -f "$BACKUP_DEST/$LAST_BACKUP_DIR/directory_snapshot.prev" ]; then
        if ! diff "$BACKUP_DEST/$LAST_BACKUP_DIR/directory_snapshot.prev" "$NEW_BACKUP_FOLDER/directory_snapshot.current"; then
            echo "Changes detected, initiating backup..."
            cp -r "$SRC_PATH" "$NEW_BACKUP_FOLDER"
            cp "$NEW_BACKUP_FOLDER/directory_snapshot.current" "$NEW_BACKUP_FOLDER/directory_snapshot.prev"
        else
            echo "No changes detected , skipping this backup cycle."
            #cp -r "$SRC_PATH" "$NEW_BACKUP_FOLDER"
            #mv "$NEW_BACKUP_FOLDER/directory_snapshot.current" "$NEW_BACKUP_FOLDER/directory_snapshot.prev"
            rm -rf "$NEW_BACKUP_FOLDER"
        fi
    else
        echo "No previous directory-info.last file found. Treating as an initial backup."
        cp -r "$SRC_PATH" "$NEW_BACKUP_FOLDER"
        mv "$NEW_BACKUP_FOLDER/directory_snapshot.current" "$NEW_BACKUP_FOLDER/directory_snapshot.prev"
    fi
}

remove_old_backups() {
    CURRENT_BACKUP_COUNT=$(ls -1 "$BACKUP_DEST" | wc -l)
    if [ "$CURRENT_BACKUP_COUNT" -gt "$MAX_BACKUP_COUNT" ]; then
        OLD_BACKUPS=$(ls -1t "$BACKUP_DEST" | tail -n $(($CURRENT_BACKUP_COUNT - $MAX_BACKUP_COUNT)))
        for OLD_BACKUP in $OLD_BACKUPS; do
            echo "Deleting outdated backup: $OLD_BACKUP"
            rm -rf "$BACKUP_DEST/$OLD_BACKUP"
        done
    fi
}

echo "Initiating backup operation..."
execute_initial_backup

while true; do
    sleep "$INTERVAL_TIME"
    backup_on_change
    remove_old_backups
done

