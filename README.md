# 📰 News App

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Hive](https://img.shields.io/badge/Database-Hive-orange)
![NewsAPI](https://img.shields.io/badge/API-NewsAPI-green)
![Platform](https://img.shields.io/badge/Platform-Android-brightgreen)

> **A modern Flutter News Application for discovering, searching, saving, and sharing the latest news from around the world.**

---

## 📱 About The Project

**News App** is a modern mobile application built with **Flutter & Dart** that provides users with an easy and clean way to discover the latest news.

The application allows users to browse news by category, search for specific topics, read complete articles, save their favorite news, and share articles with others.

The app also supports **Light & Dark Mode** and uses **Hive** to store favorite articles locally on the device.

---

## ✨ Features

* 📰 Browse the latest news
* 🌍 Browse news by category
* 🔎 Search news by keyword
* 📖 View full news details
* 🔖 Add and remove articles from Favorites
* ❤️ View saved favorite articles
* 🔗 Open the original news article
* 📤 Share news articles
* 🌙 Light & Dark Mode
* 🔄 Pull to refresh
* ⚡ Smooth animations
* 💾 Local storage using Hive
* 📱 Modern and responsive UI
* 🎨 Material 3 Design

---

## 🛠️ Technologies

| Technology   | Usage                  |
| ------------ | ---------------------- |
| Flutter      | Mobile App Development |
| Dart         | Programming Language   |
| NewsAPI      | News Data              |
| Hive         | Local Storage          |
| Hive Flutter | Hive Integration       |
| HTTP         | API Requests           |
| Share Plus   | Sharing Articles       |
| URL Launcher | Opening News Links     |

---

## 🏗️ Architecture

The project is organized into separate layers to keep the code clean and maintainable.

```text
news_app/
│
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
│
├── assets/
│   └── ...
│
├── lib/
│   │
│   ├── api_service/
│   │   └── remote_data_source.dart
│   │
│   ├── models/
│   │   └── news_model/
│   │       └── news_model.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── search_screen.dart
│   │   ├── news_details_screen.dart
│   │   ├── favorites_screen.dart
│   │   └── splash_screen.dart
│   │
│   ├── widgets/
│   │   ├── bottom_nav_bar.dart
│   │   ├── news_item.dart
│   │   └── search_button.dart
│   │
│   ├── favorites_box.dart
│   │
│   └── main.dart
│
├── test/
│   └── ...
│
├── pubspec.yaml
├── pubspec.lock
├── README.md
└── analysis_options.yaml
```

---

# 📱 App Preview

## 📱 Screenshots

### 🏠 Home Screen

<img width="540" height="1200" alt="news_home" src="https://github.com/user-attachments/assets/223ef89e-ad04-4757-b425-3c958e7ca273" />

### 🔍 Search Screen

<img width="1080" height="2400" alt="news_search" src="https://github.com/user-attachments/assets/3870bf1c-b9a6-4cd8-be20-8ddcf9336b34" />


### 📰 News Details

<img width="540" height="1200" alt="news_details" src="https://github.com/user-attachments/assets/b042da32-1ab9-4644-877a-cd5bd7219724" />

### 🔖 Favorites

<img width="540" height="1200" alt="favourite_news" src="https://github.com/user-attachments/assets/866d5c00-908b-46f7-b196-2635e44bad26" />

### 🌙 Dark Mode

<img width="540" height="1200" alt="dark_mode" src="https://github.com/user-attachments/assets/6b29b98d-e4c8-415c-9f88-dff8712ea7f5" />

### 🚀 Splash Screen

<img width="540" height="1200" alt="splash_screen" src="https://github.com/user-attachments/assets/065fc2c6-bfac-4edf-b584-c641a27f06d2" />

---

## 🎨 UI & UX

The application focuses on providing a clean and modern user experience.

### Design Highlights

* Material 3 UI
* Modern rounded cards
* Smooth transitions and animations
* Clean category navigation
* Responsive layouts
* Interactive buttons
* Light and Dark themes
* Simple and intuitive navigation

---

# 🔌 API Integration

The application uses **NewsAPI** to retrieve news articles from different categories and search results.

### Available Categories

* 💼 Business
* 🎬 Entertainment
* 🌍 General
* ❤️ Health
* 🔬 Science
* ⚽ Sports
* 💻 Technology

API:

**NewsAPI**

https://newsapi.org/

> ⚠️ For security reasons, use your own API key when running the project.

---

# 💾 Local Storage

The application uses **Hive** for local data storage.

Hive is used to save favorite news articles locally so that users can access their bookmarks even after closing and reopening the application.

### Favorites Flow

```text
User selects article
        ↓
Press Bookmark
        ↓
Article saved to Hive
        ↓
Available in Favorites
        ↓
User can remove it anytime
```

---

# 🔍 Search

The Search feature allows users to search for news using keywords.

Examples:

```text
Mohamed Salah
Technology
Artificial Intelligence
Flutter
Football
Crypto
```

The search system supports both **English and Arabic queries**.

---

# 🌓 Theme Support

The application includes two themes:

### ☀️ Light Mode

A clean and bright interface designed for daytime usage.

### 🌙 Dark Mode

A darker interface designed for comfortable usage in low-light environments.

Users can switch between the two modes directly from the Home Screen.

---

# 🚀 Getting Started

## 1️⃣ Clone the Repository

```bash
git clone https://github.com/Khaledwaleed11/news_app
```

## 2️⃣ Open the Project

```bash
cd news_app
```

## 3️⃣ Install Dependencies

```bash
flutter pub get
```

## 4️⃣ Add Your API Key

Open:

```text
lib/api_service/remote_data_source.dart
```

Add your own NewsAPI key.

## 5️⃣ Run the Application

```bash
flutter run
```

---

# 📦 Main Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  http:
  hive:
  hive_flutter:
  share_plus:
  url_launcher:

```

# 👨‍💻 Developer

## Khaled Waleed

**Flutter Developer**

---

# 🎯 Project Goals

This project was developed to demonstrate practical experience with:

* Flutter Application Development
* REST API Integration
* JSON Data Handling
* Local Database Storage
* State Management
* Navigation
* Search Functionality
* Theme Management
* Responsive UI Design
* Reusable Widgets
* Clean Project Structure

---

# 📄 License

This project was created for **educational and development purposes**.

---

⭐ **If you like this project, feel free to give it a star!**
