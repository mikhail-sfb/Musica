# Musica

**Group**: 253595  
**Project Theme**: Music Player **Musica**

## Project Overview

Musica is a music player, with Metal support, that allows users to upload and listen to their own music, organize tracks into playlists, customize the app's locale and theme, and interact with other features depending on the user's role.

## Functional Requirements

1. Users can manage their own music installed locally [registered only].
2. Users can create and organize playlists.
3. Users can change the application's locale, theme, shaders, and others.
4. Users can submit songs for admin review [registered only].
5. Users can like accepted songs [registered only].
6. Admins have all the capabilities of registered users, with the additional privilege of managing songs.

## Database Entities

### 1. **User/Admin**
- Fields:
  - `profile_image`: TEXT
  - `name`: VARCHAR(100) NOT NULL
  - `email`: VARCHAR(100) NOT NULL UNIQUE
  - `role`: ENUM('user', 'admin', 'unauthorized') NOT NULL
  - `settings_id`: INT, Foreign Key to `Settings`
  - `password`: VARCHAR(255) NOT NULL
- Relationships: Admins inherit all properties of Users, manage `Tracks` and `Playlists`, linked to `Settings`.

### 2. **Artist**
- Fields:
  - `artist_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `image`: TEXT
  - `total_listenings`: INT DEFAULT 0
- Relationships: Many-to-many with `Tracks`.

### 3. **Playlist**
- Fields:
  - `playlist_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `image`: TEXT
- Relationships: Many-to-many with `Tracks`, belongs to `User`.

### 4. **Track**
- Fields:
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
- Relationships: Many-to-many with `Artists` and `Playlists`.

### 5. **Journal (Action Log)**

#### 5.1 **Action**
- Fields:
  - `action_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `description`: TEXT
- Relationships: Defines the type of action performed by the user. This table is linked to the `JournalLog` table.

#### 5.2 **JournalLog**
- Fields:
  - `journal_id`: INT PRIMARY KEY
  - `user_id`: INT, Foreign Key to `User`
  - `action_id`: INT, Foreign Key to `Action`
  - `details`: TEXT
  - `timestamp`: DATETIME NOT NULL
- Relationships: Tracks the specific actions performed by the user.

### 6. **Album**
- Fields:
  - `album_id`: INT PRIMARY KEY
  - `name`: VARCHAR(100) NOT NULL
  - `image`: TEXT
  - `release_date`: DATE
- Relationships: Contains many `Tracks`.

### 7. **UserTrackHistory**
- Fields:
  - `history_id`: INT PRIMARY KEY
  - `user_id`: INT, Foreign Key to `User`
  - `track_id`: INT, Foreign Key to `Track`
  - `listened_at`: DATETIME NOT NULL
- Relationships: Tracks user listening history, connected to `User` and `Track`.

### 8. **Like**
- Fields:
  - `like_id`: INT PRIMARY KEY
  - `user_id`: INT, Foreign Key to `User`
  - `track_id`: INT, Foreign Key to `Track`
  - `timestamp`: DATETIME NOT NULL
- Relationships: Users can like many `Tracks`, and tracks can be liked by many `Users`.

### 9. **Settings**
- Fields:
  - `settings_id`: INT PRIMARY KEY
  - `locale`: VARCHAR(10) NOT NULL
  - `theme`: VARCHAR(50) NOT NULL
- Relationships: Linked to `User`. Each `User` has one `Settings` entity to manage their locale and theme.

## Project Setup

To run this project locally, follow these steps:

### Prerequisites

- Xcode and Swift installed.
- Core Data configured for database persistence.
- Metal API for GPU-based rendering of animations and effects.

### Installation

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

### Running Tests

To run tests:
```bash
swift test
