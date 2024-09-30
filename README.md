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

### 1. **Entities**

#### 1.1 **👤 Users Table**

- `id`: `UUID` PRIMARY KEY
- `name`: `TEXT` NOT NULL
- `email`: `TEXT` UNIQUE NOT NULL
- `profile_image_url`: `TEXT`
- `password`: `TEXT` NOT NULL
- `role_id`: `INT` REFERENCES `Roles(id)` NOT NULL
- `settings_id`: `UUID` UNIQUE REFERENCES `Settings(id)` NOT NULL

---

#### 1.2 **⚙️ Settings Table**

- `id`: `UUID` PRIMARY KEY
- `current_locale`: `TEXT` CHECK (current_locale IN ('en_US', 'pl_PL', 'es_ES')) DEFAULT 'en_US'
- `shading_mode`: `BOOLEAN` DEFAULT FALSE

---

#### 1.3 **🛠️ Roles Table**

- `id`: `SERIAL` PRIMARY KEY
- `role_name`: ENUM('admin', 'user') NOT NULL DEFAULT 'user'

---

#### 1.4 **🎤 Artists Table**

- `id`: `SERIAL` PRIMARY KEY
- `name`: `TEXT` NOT NULL
- `image`: `TEXT`
- `total_listenings`: `INT` DEFAULT 0

---

#### 1.5 **🎧 Playlists Table**

- `id`: `SERIAL` PRIMARY KEY
- `name`: `TEXT` NOT NULL
- `image`: `TEXT`
- `user_id`: `UUID` REFERENCES `Users(id)` ON DELETE CASCADE

---

#### 1.6 **🎶 Tracks Table**

- `id`: `SERIAL` PRIMARY KEY
- `title`: `TEXT` NOT NULL
- `file_path`: `TEXT` NOT NULL
- `image`: `TEXT`
- `image_color_set`: `JSON`
- `length`: `INT` NOT NULL
- `hard_points`: `JSON`
- `is_shadered`: `BOOLEAN`
- `uploaded_by`: `UUID` REFERENCES `Users(id)` NOT NULL
- `status`: ENUM('pending', 'approved', 'rejected') NOT NULL
- `source`: ENUM('local', 'remote') DEFAULT 'local'
- `stream_url`: `TEXT`

---

#### 1.7 **📀 Albums Table**

- `id`: `SERIAL` PRIMARY KEY
- `name`: `TEXT` NOT NULL
- `image`: `TEXT`
- `release_date`: `TIMESTAMP WITH TIME ZONE`

---

#### 1.8 **🎚️ Genres Table**

- `id`: `SERIAL` PRIMARY KEY
- `name`: `TEXT` NOT NULL UNIQUE

---

#### 1.9 **📝 Journal Logs Table**

- `id`: `SERIAL` PRIMARY KEY
- `user_id`: `UUID` REFERENCES `Users(id)` ON DELETE CASCADE
- `action_id`: `INT` REFERENCES `Actions(id)` ON DELETE CASCADE
- `details`: `TEXT`
- `created_at`: `TIMESTAMP WITH TIME ZONE DEFAULT NOW()`

---

#### 1.10 **🛠️ Actions Table**

- `id`: `SERIAL` PRIMARY KEY
- `name`: `TEXT` NOT NULL
- `description`: `TEXT`

---

#### 1.11 **🕒 User_Track_History Table**

- `id`: `SERIAL` PRIMARY KEY
- `user_id`: `UUID` REFERENCES `Users(id)` ON DELETE CASCADE
- `track_id`: `INT` REFERENCES `Tracks(id)` ON DELETE CASCADE
- `listened_at`: `TIMESTAMP WITH TIME ZONE DEFAULT NOW()`

---

#### 1.12 **❤️ User_Likes Table**

- `user_id`: `UUID` REFERENCES `Users(id)` ON DELETE CASCADE
- `track_id`: `INT` REFERENCES `Tracks(id)` ON DELETE CASCADE
- `created_at`: `TIMESTAMP WITH TIME ZONE DEFAULT NOW()`
- `PRIMARY KEY (user_id, track_id)`

---

#### 1.13 **📌 Pinned_Playlists Table**

- `user_id`: `UUID` REFERENCES `Users(id)` ON DELETE CASCADE
- `playlist_id`: `INT` REFERENCES `Playlists(id)` ON DELETE CASCADE
- `pinned_at`: `TIMESTAMP WITH TIME ZONE DEFAULT NOW()`
- `PRIMARY KEY (user_id, playlist_id)`

---

### 2. **Entities for Relations**

These tables handle the many-to-many relationships between various entities in the system. They are essential for efficiently linking records across the main entities.

---

#### 2.1 **🎨 Track_Genres (Join Table)**

- `track_id`: `INT` REFERENCES `Tracks(id)` ON DELETE CASCADE
- `genre_id`: `INT` REFERENCES `Genres(id)` ON DELETE CASCADE
- `PRIMARY KEY (track_id, genre_id)`

**Purpose**:  
This join table links the `Tracks` and `Genres` tables in a many-to-many relationship. A track can belong to multiple genres, and a genre can have multiple tracks. This structure enables flexible categorization of tracks by genre.

---

#### 2.2 **🎤 Artist_Tracks (Join Table)**

- `artist_id`: `INT` REFERENCES `Artists(id)` ON DELETE CASCADE
- `track_id`: `INT` REFERENCES `Tracks(id)` ON DELETE CASCADE
- `PRIMARY KEY (artist_id, track_id)`

**Purpose**:  
This join table connects the `Artists` and `Tracks` tables in a many-to-many relationship. An artist can have multiple tracks, and a track can have multiple contributing artists. This structure supports collaborations and shared authorship on tracks.

---

#### 2.3 **🎧 Playlist_Tracks (Join Table)**

- `playlist_id`: `INT` REFERENCES `Playlists(id)` ON DELETE CASCADE
- `track_id`: `INT` REFERENCES `Tracks(id)` ON DELETE CASCADE
- `PRIMARY KEY (playlist_id, track_id)`

**Purpose**:  
This join table links the `Playlists` and `Tracks` tables in a many-to-many relationship. A playlist can include multiple tracks, and a track can belong to multiple playlists. This allows users to create custom playlists without duplicating track data.

---

### Summary

The **Entities** section contains the core tables that store key data such as users, tracks, playlists, artists, and genres. The **Entities for Relations** section contains the join tables that handle many-to-many relationships, linking the main entities together. These relationships are necessary to model flexible and dynamic interactions, such as users liking tracks, tracks belonging to multiple genres, and playlists containing various tracks.


## 📚 Tools & Technologies

<p align="left">
  <img src="https://developer.apple.com/assets/elements/icons/swift/swift-96x96_2x.png" alt="Swift Logo" width="50"/>
  <img src="https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png" alt="Metal Logo" width="50"/>
  <img src="https://miro.medium.com/v2/resize:fit:600/format:webp/1*nm4j_6GfwWpqhuSPlbO-sg.png" alt="Core Data Logo" width="50"/>
 <img src= "https://raw.githubusercontent.com/github/explore/f4ec5347a36e06540a69376753a7c37a8cb5a136/topics/supabase/supabase.png" width="50"/>
</p>

- **Swift**: Language for building the app.
- **Metal**: For GPU-based animations and effects.
- **Core Data**: Database for music, playlists, and user data management.

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
