# JMdict Dictionary Data

This directory contains scripts and configuration for importing the
[JMdict](https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project)
Japanese-English dictionary into an on-device SQLite database.

## Attribution

JMdict is the property of the
[Electronic Dictionary Research and Development Group (EDRDG)](https://www.edrdg.org/)
and is used in conformance with the Group's
[licence](https://www.edrdg.org/edrdg/licence.html).

**This attribution must be displayed in the app's Settings/About screen.**

## Setup

1. Download the latest JMdict XML:
   ```bash
   ./scripts/download-jmdict.sh
   ```

2. Import into SQLite:
   ```bash
   swift scripts/import-jmdict.swift
   ```

The resulting `jmdict.sqlite` database goes into the app bundle as a read-only
asset. It is excluded from git via `.gitignore` (too large to commit).

## Database Schema

```sql
CREATE TABLE entries (
    id INTEGER PRIMARY KEY,
    headword TEXT NOT NULL
);

CREATE TABLE readings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL REFERENCES entries(id),
    reading TEXT NOT NULL
);

CREATE TABLE senses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL REFERENCES entries(id),
    pos TEXT  -- part of speech
);

CREATE TABLE glosses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sense_id INTEGER NOT NULL REFERENCES senses(id),
    gloss TEXT NOT NULL,
    lang TEXT DEFAULT 'eng'
);

CREATE INDEX idx_entries_headword ON entries(headword);
CREATE INDEX idx_readings_reading ON readings(reading);
CREATE INDEX idx_readings_entry ON readings(entry_id);
CREATE INDEX idx_senses_entry ON senses(entry_id);
CREATE INDEX idx_glosses_sense ON glosses(sense_id);
```

## Size

The full JMdict database is approximately 50–60 MB uncompressed. With SQLite
WAL mode disabled (read-only) and page-level compression, expect ~40 MB on disk.
