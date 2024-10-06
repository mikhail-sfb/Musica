# Musica

##  Group: 253505  
##  Student: Malashkevich Mikhail Ivanovich  
##  Project Theme: Music Player

---
<img src="https://github.com/user-attachments/assets/c1a202b3-6b06-4ed0-81fb-27221033b5f4" alt="logo" width="400" height="400" />

## 🎯 Project Overview

**Musica** is a powerful and feature-rich music player enhanced with **Metal** support, designed for music lovers who want full control over their listening experience. With **Musica**, users can upload, manage, and listen to their music while creating playlists, customizing themes, and enjoying role-based access privileges. Admins have additional authority to manage songs and monitor user submissions, ensuring a seamless experience for all users.

---

## ⚙️ Features Overview

### User Features

- **Music Management**: Upload and manage your local music collection (**registered users only**).
- **Playlists**: Create and organize playlists with ease.
- **Customization**: Personalize your app's theme, locale, and visual shaders.
- **Song Submission**: Submit songs for admin approval (**registered users only**).
- **Liking Songs**: Like your favorite approved songs to save them for later.
  
### Admin Features

- **Admin Privileges**: Manage songs, playlists, and perform all user actions, including monitoring and approving submitted songs.

---

## 🛠️ Technical Architecture

### 1. UI Structure

#### **📱 Bottom Navigation Bar**

- **Explore**: Explore streaming part of the app.
- **Library**: Access user playlists and manage music collections.

#### **🔝 App Bar**

- **Explore**: Shows a circular avatar for profile access (simple profile screen to change name/picture).
- **Library**: Same structure as Explore but with an additional search button and add button for creating playlists.

### 2. Screens Breakdown

#### **🎵 Explore Screen**

- **Search**: Browse through songs approved by the admin, user can like the song (!🚨 Here user can download the song or stream it 🚨!).
- **Popular Songs**: Display grid with most popular songs.
- **Genre Categories**: Display music playlists in grid categories (e.g., Most Popular, Genres).

#### **📂 Library Screen**

- **View Modes**: Switch between grid and list views for browsing.
- **Playlists**: Display playlists similar to Spotify.
- **Create Playlist**: A button at the bottom for creating new playlists.

#### **📝 Playlist Management**

- **Playlist Options**: Create, edit, delete playlists. Toggle shuffle mode.
- **Download Tracks**: Insert a link to download songs from the internet.

#### **🎧 Track Details**

- **Track Settings**: Track details similar to Spotify (note: artist may be missing (!🚨 Here user can upload his songs 🚨!)).
- **Track Screen**: Displays track information without sharing options or device info.
- **Notifications**: Notify user on 3 states ENUM('pending', 'approved', 'rejected').

### 3. Settings Breakdown

#### **👤 Account**

- Email confirmation.
- Subscription plan details.

#### **🎨 Customization**

- **Locale**: Change app language in settings (no separate screen needed).
- **Shader Mode**: Enable/disable visual shaders.

#### **🔧 General**

- Privacy policies, app version, rate app, and log out options.
- **Send Feature Request**: A simple modal from the bottom of the screen.

---

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


## 🌐 Diagram
<img width="736" alt="Screenshot 2024-10-06 at 23 43 47" src="https://github.com/user-attachments/assets/2e1c54e8-2410-421c-8758-e115b8ac6da4">

## 📚 Tools & Technologies

<p align="left">
  <img src="https://developer.apple.com/assets/elements/icons/swift/swift-96x96_2x.png" alt="Swift Logo" width="50"/>
  <img src="https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png" alt="Metal Logo" width="50"/>
  <img src="https://avatars.githubusercontent.com/u/7575099?s=200&v=4" alt="Realm Logo" width="50"/>
 <img src= "https://raw.githubusercontent.com/github/explore/f4ec5347a36e06540a69376753a7c37a8cb5a136/topics/supabase/supabase.png" width="50"/>
</p>

- **Swift**: Language for building the app.
- **Metal**: For GPU-based animations and effects.
- **Realm**: Local data base.
- **Supabase**: Remote relation data base with raw sql.

---

## 🧰 Project Setup

### Prerequisites

- **Xcode** installed.
- **Swift** configured.
- **Core Data** for database persistence.
- **Metal API** for advanced rendering.

### 📥 Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/musica.git
    cd musica
    ```

2. Install dependencies:
    ```bash
    swift package resolve
    ```

3. Set up the database (Core Data) and configure Metal.

4. Run the project:
    ```bash
    swift run
    ```

---

## ✅ Running Tests

To execute unit tests:

```bash
swift test
