### Musica

##  Group: 253505  
##  Project Theme: Music Player

---
<img src="https://github.com/user-attachments/assets/c1a202b3-6b06-4ed0-81fb-27221033b5f4" alt="logo" width="500" height="500" />

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

- **Home**: Explore music, playlists, and more.
- **Explore**: Similar to Home with a focus on music discovery.
- **Library**: Access user playlists and manage music collections.

#### **🔝 App Bar**

- **Explore**: Shows a circular avatar for profile access (simple profile screen to change name/picture).
- **Library**: Same structure as Explore but with an additional search button and add button for creating playlists.

### 2. Screens Breakdown

#### **🎵 Explore Screen**

- **Search**: Browse through songs approved by the admin.
- **Playlists**: Display playlists similar to Spotify.
- **Create Playlist**: A button at the bottom for creating new playlists.

#### **📂 Library Screen**

- **View Modes**: Switch between grid and list views for browsing.
- **Popular Songs**: Display grid with most popular songs.
- **Genre Categories**: Display music categories in tiles (e.g., Most Popular, Genres).

#### **📝 Playlist Management**

- **Playlist Options**: Create, edit, delete playlists. Toggle shuffle mode.
- **Download Tracks**: Insert a link to download songs from the internet.

#### **🎧 Track Details**

- **Track Settings**: Track details similar to Spotify (note: artist may be missing).
- **Track Screen**: Displays track information without sharing options or device info.

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

### 1. **👤 User/Admin Table**

- `id`: UUID PRIMARY KEY
- `name`: VARCHAR(255)
- `email`: VARCHAR(255) UNIQUE
- `profile_image_url`: TEXT
- `password`: VARCHAR(255)
- **Relationships**: Admins can manage `Tracks` and `Playlists`.

### 2. **⚙️ Settings Table**

- `id`: UUID PRIMARY KEY
- `user_id`: UUID REFERENCES `Users(id)` ON DELETE CASCADE
- `current_locale`: ENUM ['en_US', 'pl_PL', 'es_ES'] DEFAULT 'en_US'
- `shading_mode`: BOOLEAN DEFAULT FALSE
- **Relationships**: One-to-one relationship with `Users`.

### 3. **🎤 Artist Table**

- `artist_id`: INT PRIMARY KEY
- `name`: VARCHAR(100)
- `image`: TEXT
- `total_listenings`: INT DEFAULT 0
- **Relationships**: Many-to-many relationship with `Tracks`.

### 4. **🎧 Playlist Table**

- `playlist_id`: INT PRIMARY KEY
- `name`: VARCHAR(100)
- `image`: TEXT
- **Relationships**: Many-to-many relationship with `Tracks` and belongs to `Users`.

### 5. **🎶 Track Table**

- `track_id`: INT PRIMARY KEY
- `title`: VARCHAR(100)
- `artist`: INT, REFERENCES `Artist`
- `file_path`: TEXT
- `image`: TEXT
- `image_color_set`: JSON
- `length`: INT
- `hard_points`: JSON
- `shadered`: BOOLEAN
- `genre`: VARCHAR(50)
- `sended_by`: INT REFERENCES `User`
- `status`: ENUM('pending', 'approved', 'rejected')
- **Relationships**: Many-to-many with `Artists` and `Playlists`.

### 6. **📝 Journal & Action Log**

#### **Action Table**

- `action_id`: INT PRIMARY KEY
- `name`: VARCHAR(100)
- `description`: TEXT

#### **Journal Log Table**

- `journal_id`: INT PRIMARY KEY
- `user_id`: INT REFERENCES `User`
- `action_id`: INT REFERENCES `Action`
- `details`: TEXT
- `timestamp`: DATETIME

### 7. **📀 Album Table**

- `album_id`: INT PRIMARY KEY
- `name`: VARCHAR(100)
- `image`: TEXT
- `release_date`: DATE
- **Relationships**: Contains many `Tracks`.

### 8. **🕒 UserTrackHistory Table**

- `history_id`: INT PRIMARY KEY
- `user_id`: INT REFERENCES `User`
- `track_id`: INT REFERENCES `Track`
- `listened_at`: DATETIME
- **Relationships**: Tracks user listening history.

### 9. **❤️ Like Table**

- `like_id`: INT PRIMARY KEY
- `user_id`: INT REFERENCES `User`
- `track_id`: INT REFERENCES `Track`
- `timestamp`: DATETIME
- **Relationships**: Tracks liked songs by users.

---

## 📚 Tools & Technologies

<p align="left">
  <img src="https://developer.apple.com/assets/elements/icons/swift/swift-96x96_2x.png" alt="Swift Logo" width="50"/>
  <img src="https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png" alt="Metal Logo" width="50"/>
  <img src="https://miro.medium.com/v2/resize:fit:600/format:webp/1*nm4j_6GfwWpqhuSPlbO-sg.png" alt="Core Data Logo" width="50"/>
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
