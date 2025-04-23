
# 🗂️ Auto Backup Script

This Bash script automates the backup of a directory at regular intervals. It checks for changes in the source directory and only creates a new backup if changes are detected. It also maintains a limited number of backups, removing the oldest ones beyond a specified count.

---

## 📁 Features

- Initial full backup of the specified source directory
- Periodic backups based on time interval
- Change detection to avoid redundant backups
- Snapshot comparisons using `ls -lR`
- Retention policy: deletes older backups when the maximum limit is reached

---

## ⚙️ Usage

```bash
./backup.sh <src-dir> <backup-destination> <backup-interval> <max-backup-count>
```

### Arguments:
- `<src-dir>`: The source directory to back up
- `<backup-destination>`: Directory where backups will be stored
- `<backup-interval>`: Time interval (in seconds) between backup checks
- `<max-backup-count>`: Maximum number of backups to keep

---

## 📝 Example

```bash
./backup.sh /home/user/documents /mnt/backups 300 5
```

- Backs up `/home/user/documents`
- Saves backups in `/mnt/backups`
- Checks for changes every 300 seconds (5 minutes)
- Keeps only the latest 5 backups

---

## 🧠 Notes

- Each backup is stored in a timestamped folder.
- Change detection is based on `ls -lR` output, which checks file metadata like names, permissions, and modification times.
- If the destination directory doesn’t exist, it will be created automatically.
- No changes = no backup = cleaner and more efficient storage use.

---

## 🛠️ Requirements

- Unix/Linux-based system
- Bash shell
- Basic core utilities (`cp`, `diff`, `ls`, `mkdir`, etc.)

---

## 📜 License

This project is open-source .

---

