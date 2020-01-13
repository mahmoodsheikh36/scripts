CREATE TABLE IF NOT EXISTS songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    artist TEXT NOT NULL,
    album TEXT NOT NULL,
    date_of_entry DATETIME DEFAULT CURRENT_TIMESTAMP,
    audio_file_path TEXT NOT NULL,
    image_file_path TEXT,
    lyrics TEXT,
    duration int
);
