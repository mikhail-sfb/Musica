# Musica 

**Group**: 253595  
**Project Theme**: Music Player **Musica**

---

## 🎯 Project Overview

**Musica** is a powerful music player, enhanced with **Metal** support, that allows users to upload, manage, and listen to their music. With rich features like playlists, localization, themes, and role-based access, it’s an ideal tool for music lovers. Admins have extended privileges to manage songs and monitor user submissions.

---

## Functional Requirements

1. **🎵 Music Management**: Users can upload and manage their own locally installed music (**registered users only**).
2. **📜 Playlists**: Users can create and organize their music into playlists.
3. **🌍 Customization**: Users can customize the app’s locale, theme, and visual shaders.
4. **📤 Song Submission**: Users can submit songs for admin approval (**registered users only**).
5. **❤️ Liking Songs**: Users can like accepted songs (**registered users only**).
6. **🔧 Admin Privileges**: Admins can manage songs and perform all user actions with additional privileges.

---

## 🛠️ Database Entities

### 1. **👤 User/Admin**

- **Fields**:
  - `profile_image`: TEXT
  - `name`: VARCHAR(100) NOT NULL
  - `email`: VARCHAR(100) NOT NULL UNIQUE
  - `role`: ENUM('user', 'admin', 'unauthorized') NOT NULL
  - `settings_id`: INT, Foreign Key to `Settings`
  - `password`: VARCHAR(255) NOT NULL
- **Relationships**: Admins inherit all user properties and can manage `Tracks` and `Playlists`, linked to `Settings`.

---

### 2. **🎤 Artist**

- **Fields**:
  - `artist_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `image`: TEXT
  - `total_listenings`: INT DEFAULT 0
- **Relationships**: Many-to-many with `Tracks`.

---

### 3. **🎧 Playlist**

- **Fields**:
  - `playlist_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `image`: TEXT
- **Relationships**: Many-to-many with `Tracks`, belongs to `User`.

---

### 4. **🎶 Track**

- **Fields**:
  - `track_id`: INT PRIMARY KEY
  - `title`: VARCHAR(100) NOT NULL
  - `artist`: INT, Foreign Key to `Artist`
  - `file_path`: TEXT NOT NULL
  - `image`: TEXT
  - `image_color_set`: JSON
  - `length`: INT
  - `hard_points`: JSON
  - `shadered`: BOOLEAN
  - `genre`: VARCHAR(50)
  - `sended_by`: INT, Foreign Key to `User`
  - `status`: ENUM('pending', 'approved', 'rejected')
- **Relationships**: Many-to-many with `Artists` and `Playlists`.

---

### 5. **📝 Journal (Action Log)**

#### 5.1 **Action**

- **Fields**:
  - `action_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `description`: TEXT
- **Relationships**: Defines the action type performed by the user.

#### 5.2 **JournalLog**

- **Fields**:
  - `journal_id`: INT PRIMARY KEY
  - `user_id`: INT, Foreign Key to `User`
  - `action_id`: INT, Foreign Key to `Action`
  - `details`: TEXT
  - `timestamp`: DATETIME NOT NULL
- **Relationships**: Tracks specific user actions.

---

### 6. **📀 Album**

- **Fields**:
  - `album_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `image`: TEXT
  - `release_date`: DATE
- **Relationships**: Contains many `Tracks`.

---

### 7. **🕒 UserTrackHistory**

- **Fields**:
  - `history_id`: INT PRIMARY KEY
  - `user_id`: INT, Foreign Key to `User`
  - `track_id`: INT, Foreign Key to `Track`
  - `listened_at`: DATETIME NOT NULL
- **Relationships**: Tracks user listening history.

---

### 8. **❤️ Like**

- **Fields**:
  - `like_id`: INT PRIMARY KEY
  - `user_id`: INT, Foreign Key to `User`
  - `track_id`: INT, Foreign Key to `Track`
  - `timestamp`: DATETIME NOT NULL
- **Relationships**: Users can like multiple `Tracks`.

### 9. **⚙️ Settings**

- **Fields**:
  - `settings_id`: INT PRIMARY KEY
  - `locale`: VARCHAR(10) NOT NULL
  - `theme`: VARCHAR(50) NOT NULL
- **Relationships**: Linked to `User` for locale and theme management.

## 📚 Tools Used

<p align="left">
  <img src="https://developer.apple.com/assets/elements/icons/swift/swift-96x96_2x.png" alt="Swift Logo" width="100" height="100" style="padding-bottom: 20px;"/>
  <img src="https://developer.apple.com/assets/elements/icons/metal/metal-96x96_2x.png" alt="Metal Logo" width="100" height="100" style="padding: 20px;"/>
  <img src="https://miro.medium.com/v2/resize:fit:600/format:webp/1*nm4j_6GfwWpqhuSPlbO-sg.png" alt="Core Data Logo" width="100" height="100" style="padding: 20px;"/>
</p>



## ⚙️ Project Setup

### 🧰 Prerequisites

- **Xcode** and **Swift** installed.
- **Core Data** configured for database persistence.
- **Metal API** for GPU-based rendering of animations and effects.

---

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

3. Set up your database (Core Data) and configure Metal.

4. Run the project:
    ```bash
    swift run
    ```

---

### ✅ Running Tests

To run tests:
```bash
swift test
