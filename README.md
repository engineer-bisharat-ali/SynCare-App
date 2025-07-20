# 🩺 SynCare – AI-Powered Health Management App
<div align="center">
  <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/Banner.png" alt="SynCare Banner" style="width100%;">
</div>

---

## 📘 Introduction

In today’s fast-evolving digital landscape, individuals and families often struggle to manage their health data efficiently. Medical records are frequently scattered across various hospitals, stored in paper-based formats, or lost due to lack of proper digital storage. This not only creates inconvenience but also leads to repeated diagnostic tests, delayed treatment, and increased healthcare costs.

SynCare is developed to solve these challenges by providing a modern, centralized, and intelligent mobile platform. It empowers users to securely store and organize their personal medical records, track symptoms, and receive early health risk predictions through AI-powered analysis.

Additionally, the app integrates real-time geolocation services, allowing users to discover nearby hospitals or clinics instantly in case of emergency or routine visits. With a seamless user interface, local + cloud storage synchronization, and smart analytics, SynCare ensures that managing health becomes simple, proactive, and always accessible — right from the palm of your hand.

---

## ❗ The Problem

Most health apps today suffer from one or more of the following limitations:

- ❌ Lack of centralized access to personal medical records  
- ❌ No AI or predictive intelligence for early diagnosis  
- ❌ Poor or no integration with location-based hospital services  
- ❌ Difficult or manual data backup across devices  
- ❌ Limited support for local + cloud storage in one place

---

## ✅ The Solution: SynCare

**SynCare** solves these problems by combining:

- 🧠 **AI-driven Disease Prediction**
- 🗂️ **Local + Cloud Medical Record Management**
- 🌍 **Nearby Hospital Discovery using Live Location**
- 📤 **Seamless Backup and Restore**
- 🔐 **Secure Login with Firebase Auth**

---

## 🚀 Core Features

- 🔐 User Authentication: Email/Password + Google Sign-In (via Firebase)
- 📁 Centralized Medical Records: Upload and view PDFs, images, or reports using Hive DB + Supabase
- 🧠 AI Symptom Checker: Disease predictions using Flask backend powered by ML
- 🌍 Nearby Hospitals on Map: Location-based hospital search using OpenStreetMap + Overpass API
- 🧾 Document Preview & Search: Swipe-to-delete, search filter, and previews
- 🔄 Cloud Sync & Backup: Supabase cloud integration

---

## 🧰 Tech Stack 
<div align="center"> <kbd> <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/Flutter%20Icon.png" height="60" /> </kbd> <kbd> <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/Firebase%20RTDB.png" height="60" /> </kbd> <kbd> <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/Supabase%20Icon.png" height="60" /> </kbd> <kbd> <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/Python%20Icon.png" height="60" /> </kbd> <kbd> <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/Flask.png" height="60" /> </kbd> <kbd> <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/hive.png" height="60" /> </div> <div align="center"> <h4> Flutter  &nbsp;|&nbsp; Firebase  &nbsp;|&nbsp; Supabase  &nbsp;|&nbsp; Python  &nbsp;|&nbsp; Flask  &nbsp;|&nbsp; Hive </h4> </div>
---

## 📷 App Screenshots

| Login | Home | Record Screen |  Disease Prediction | Symptoms Tracker | Map |
|-----------|-----------|-----------|-----------|-----------|-----------|
| <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/1.png" width="200"/> | <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/homescreen.png" width="200"/> | <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/record.png" width="200"/> | <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/prediction.png" width="200"/> |<img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/symptoms.png" width="200"/> | <img src="https://raw.githubusercontent.com/engineer-bisharat-ali/Assets/refs/heads/main/maps_screen.png" width="200"/> |

---

### 🚀 Getting Started

```bash
git clone https://github.com/engineer-bisharat-ali/SynCare-App.git
cd SynCare-App
flutter pub get
flutter run
```


## 📁 Folder Structure

```
SynCare-App/
├── lib/
│   ├── constants/
|   ├── models/
│   ├── pages/
│   ├── providers/
│   └── services/
|   ├── Widgets/
|   |── main.dart


```

---

## 📌 Roadmap

- [x] Hive + Supabase sync
- [x] AI Disease prediction model
- [x] Map integration with Overpass API
- [ ] Multi-language support *(coming soon)*

---

## 👤 Author

**Bisharat Ali**  
Flutter Developer | Machine Learning | FYP 2025  
📧 bisharatali5618@gmail.com  
🔗 [GitHub](https://github.com/engineer-bisharat-ali)  
🔗 [LinkedIn](https://www.linkedin.com/in/bisharat-ali)

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
