# 🎵 AVFoundation_task

AVFoundation_task is a simple iOS music player application built using **UIKit** and **AVFoundation**. It demonstrates how to play audio locally from bundled `.mp3` files, switch between song and video mode (YouTube optional), update playback progress via a slider, and show now-playing information with background audio support.

---

## 📱 Features

- 🔊 Play local `.mp3` songs from the app bundle
- ⏯️ Play/Pause/Forward/Backward controls
- 🎚 Slider for current time and duration
- 🔁 Repeat song toggle
- 🎨 Dynamic UI with song artwork and background
- 🔒 Lock screen / Notification Center playback info using `MPNowPlayingInfoCenter`
- 🔄 Remote command support (Play/Pause)
- ⏱ Timer-based UI updates for playback position
- 🌓 Background audio playback (enabled via `Info.plist`)

---

## 🔧 Technologies Used

- `UIKit`
- `AVFoundation`
- `MediaPlayer`
- `AVAudioPlayer`
- `MPNowPlayingInfoCenter`
- `AVAudioSession`

---

## 🏗️ Screen Shot


<img width="300" height="484" alt="Screenshot 2025-07-14 at 11 42 03 AM" src="https://github.com/user-attachments/assets/c5a28a7b-c760-4c3c-b72d-3c55ed819851" />
<img width="300" height="484" alt="Screenshot 2025-07-14 at 11 40 39 AM" src="https://github.com/user-attachments/assets/41359864-ebff-41a0-9532-d765ca2d80ba" />
<img width="300" height="484" alt="IMG_3803" src="https://github.com/user-attachments/assets/6e9e530a-4de9-4577-91b6-6efffd3e9996" />


## ✅ Requirements

- iOS 13.0+
- Xcode 14+
- Swift 5+
- Physical Device or Simulator (background audio won't work fully on simulator)


---

## 📋 Info.plist Configuration

To support background playback, ensure the following key is added:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```
---

## 🚀 How To Create The Project

1. **Clone the Repository**
    ```bash
    git clone https://github.com/Tirth615/AVFoundation_task.git
    ```
2. **Open in Xcode**
    - Navigate to the cloned folder.
    - Double-click the `.xcodeproj` file to open the project in Xcode.
3. **Build & Run**
    - Select your desired simulator or device.
    - Click the Run (`▶️`) button in Xcode.

---

## 🙋‍♂️ Author

- [Tirth615](https://github.com/Tirth615)
