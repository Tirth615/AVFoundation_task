//
//  AudioManager.swift
//  AVFoundation_task
//
//  Created by Tirth Shah on 14/07/25.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    var isRepeating = false
    var timerCallback: ((TimeInterval) -> Void)?

    private override init() {}

    func setupAudioPlayer(with name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()

            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio Error: \(error)")
        }
    }

    func play() {
        player?.play()
        NowPlayingManager.shared.updateElapsedTime(currentTime())
        startTimer()
    }

    func pause() {
        player?.pause()
    }

    func togglePlayPause() {
        player?.isPlaying == true ? pause() : play()
    }

    func seek(to seconds: TimeInterval) {
        player?.currentTime = seconds
        NowPlayingManager.shared.updateElapsedTime(seconds)
    }

    func currentTime() -> TimeInterval {
        return player?.currentTime ?? 0
    }

    func duration() -> TimeInterval {
        return player?.duration ?? 0
    }

    private var timer: Timer?

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentTime = self.currentTime()
            self.timerCallback?(currentTime)
            NowPlayingManager.shared.updateElapsedTime(currentTime)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isRepeating {
            player.currentTime = 0
            player.play()
        } else {
            stopTimer()
            NowPlayingManager.shared.updatePlaybackFinished()
        }
    }
}
