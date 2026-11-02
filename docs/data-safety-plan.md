# Data safety: write, backup, archive, restore

Goal: no single point of failure, every backup verified, and nothing deleted
from the phone unless a verified copy exists elsewhere.

| Step | What | Status |
|------|------|--------|
| M1 | Backup file carries row counts and a SHA-256 checksum; it is read back and checked after writing; a restore is rolled back unless every table has the backup's row count; a tampered or cut-short file is refused | done |
| M1b | Instant sync: the database counts every change (triggers, schema v20); the Principal's app checks every second and sends at once, retries after 30 s when offline, and the count survives the app being closed | done |
| M2 | Automatic daily local backup (kept, rotated) and a "Data safety" screen: last verified backup, any failure in red, reminder after 24 h | next |
| M3 | Upload the verified backup to cloud storage (versioned, never overwritten), check it after upload | |
| M4 | Restore by year from the cloud, with preview and an automatic safety copy first | |
| M5 | Year-end archive (one file per year), delete from the phone only after the archive is verified in the cloud; read archives on demand | |
| M6 | Lighter cloud sync (attendance one document per class per day), Storage rules, optional encryption | |
| M7 | Audit log of every backup, restore, archive and delete; disaster drill on a real device | |

Decisions still open: encryption now or later; archive automatic or by button;
deleting archived years from the phone required or optional.
