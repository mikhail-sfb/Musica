# Musica
GPU based audio representation music service

## 📊 Database Structure

## 1. Database Schema

### 1.1 👤 Users Table
- `id`: `UUID` PRIMARY KEY
- `name`: `TEXT` NOT NULL
- `email`: `TEXT` UNIQUE NOT NULL
- `profile_image_url`: `TEXT`
- `password`: `TEXT` NOT NULL
- `role_id`: `INT` REFERENCES `Roles(id)` NOT NULL
- `settings_id`: `UUID` REFERENCES `Settings(id)` UNIQUE NOT NULL

**Relationships:**
- **Many-to-One**: Users are linked to a single role via `role_id`.
- **One-to-One**: Each user is linked to a unique settings configuration via `settings_id`.
- **One-to-Many**: A user can upload multiple tracks, manage multiple playlists, create multiple journal logs, have multiple entries in the listening history, and like multiple tracks.

### 1.2 ⚙️ Settings Table
- `id`: `UUID` PRIMARY KEY
- `current_locale`: `TEXT` CHECK (current_locale IN ('en_US', 'pl_PL', 'es_ES')) DEFAULT 'en_US'
- `shading_mode`: `BOOLEAN` DEFAULT FALSE

**Relationships:**
- **One-to-One**: Each settings entry is uniquely linked to a user.

### 1.3 🛠️ Roles Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `role_name`: `ENUM('admin', 'user')` NOT NULL DEFAULT 'user'

**Relationships:**
- **One-to-Many**: Multiple users can be assigned the same role.

### 1.4 🎤 Artists Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `name`: `TEXT` NOT NULL
- `image`: `TEXT`
- `total_listenings`: `INT` DEFAULT 0

**Relationships:**
- **Many-to-Many**: Linked to tracks via `Artist_Tracks`.

### 1.5 🎧 Playlists Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `name`: `TEXT` NOT NULL
- `image`: `TEXT`
- `user_id`: `UUID` REFERENCES `Users(id)`

**Relationships:**
- **Many-to-One**: Managed by a user.
- **Many-to-Many**: Can include multiple tracks and be pinned by multiple users.

### 1.6 🎶 Tracks Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `title`: `TEXT` NOT NULL
- `file_path`: `TEXT` NOT NULL
- `image`: `TEXT`
- `image_color_set`: `JSON`
- `length`: `INT` NOT NULL
- `uploaded_by`: `UUID` REFERENCES `Users(id)` NOT NULL
- `status`: `ENUM('pending', 'approved', 'rejected')` NOT NULL
- `source`: `ENUM('local', 'remote')` DEFAULT 'local'

**Relationships:**
- **Many-to-One**: Uploaded by a user.
- **Many-to-Many**: Can belong to multiple genres, be included in multiple playlists, and be liked by multiple users.

### 1.7 📀 Albums Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `name`: `TEXT` NOT NULL
- `image`: `TEXT`
- `release_date`: `DATE`

**Relationships:**
- **Many-to-Many**: Albums are connected to tracks and artists through `AlbumTracks` and `AlbumArtists`.

### 1.8 🎚️ Genres Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `name`: `TEXT` NOT NULL UNIQUE

**Relationships:**
- **Many-to-Many**: Linked to tracks via `Track_Genres`.

### 1.9 📝 Journal Logs Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `user_id`: `UUID` REFERENCES `Users(id)`
- `action_id`: `INT` REFERENCES `Actions(id)`
- `details`: `TEXT`
- `created_at`: `TIMESTAMP` DEFAULT CURRENT_TIMESTAMP

**Relationships:**
- **Many-to-One**: Linked to a user and an action.

### 1.10 🛠️ Actions Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `name`: `TEXT` NOT NULL
- `description`: `TEXT`

**Relationships:**
- **One-to-Many**: Can be referenced by multiple journal logs.

### 1.11 🕒 User Track History Table
- `id`: `INT` PRIMARY KEY AUTO_INCREMENT
- `user_id`: `UUID` REFERENCES `Users(id)`
- `track_id`: `INT` REFERENCES `Tracks(id)`
- `listened_at`: `TIMESTAMP` DEFAULT CURRENT_TIMESTAMP

**Relationships:**
- **Many-to-One**: Tracks the listening history for a user and a specific track.

### 1.12 ❤️ User Likes Table
- `user_id`: `UUID` REFERENCES `Users(id)`
- `track_id`: `INT` REFERENCES `Tracks(id)`
- `liked_at`: `TIMESTAMP` DEFAULT CURRENT_TIMESTAMP
- `PRIMARY KEY (`user_id`, `track_id`)`

**Relationships:**
- **Many-to-Many**: Tracks can be liked by multiple users and users can like multiple tracks.

## 2. Entity Relations

### 2.1 🎨 Track Genres (Join Table)
- `track_id`: `INT` REFERENCES `Tracks(id)`
- `genre_id`: `INT` REFERENCES `Genres(id)`
- `PRIMARY KEY (`track_id`, `genre_id`)`

**Purpose:**  
Links tracks to genres in a many-to-many relationship.

### 2.2 🎤 Artist Tracks (Join Table)
- `artist_id`: `INT` REFERENCES `Artists(id)`
- `track_id`: `INT` REFERENCES `Tracks(id)`
- `PRIMARY KEY (`artist_id`, `track_id`)`

**Purpose:**  
Links artists to tracks in a many-to-many relationship.

### 2.3 🎧 Playlist Tracks (Join Table)
- `playlist_id`: `INT` REFERENCES `Playlists(id)`
- `track_id`: `INT` REFERENCES `Tracks(id)`
- `PRIMARY KEY (`playlist_id`, `track_id`)`

**Purpose:**  
Links playlists to tracks in a many-to-many relationship.

### 2.4 📌 Pinned Playlists (Join Table)
- `user_id`: `UUID` REFERENCES `Users(id)`
- `playlist_id`: `INT` REFERENCES `Playlists(id)`
- `PRIMARY KEY (`user_id`, `playlist_id`)`

**Purpose:**  
Links users to playlists they have pinned in a many-to-many relationship.

### 2.5 🎼 AArtist's Albums (Join Table)
- `album_id`: `INT` REFERENCES `Albums(id)`
- `artist_id`: `INT` REFERENCES `Artists(id)`
- `PRIMARY KEY (`album_id`, `artist_id`)`

**Purpose:**
Links artists with albums
