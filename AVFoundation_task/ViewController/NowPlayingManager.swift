//
//  NowPlayingManager.swift
//  AVFoundation_task
//
//  Created by Tirth Shah on 14/07/25.
//

import MediaPlayer
import UIKit

class NowPlayingManager {
    static let shared = NowPlayingManager()

    func setup(songName: String, artwork: UIImage?, duration: TimeInterval) {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: songName,
            MPMediaItemPropertyArtist: "Unknown Artist",
            MPNowPlayingInfoPropertyPlaybackRate: 1.0,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: 0
        ]

        if let artwork = artwork {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size) { _ in artwork }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    func updateElapsedTime(_ time: TimeInterval) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
    }

    func updatePlaybackFinished() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = AudioManager.shared.currentTime()
    }

    func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { _ in
            AudioManager.shared.play()
            self.setPlaybackRate(1.0)
            return .success
        }

        commandCenter.pauseCommand.addTarget { _ in
            AudioManager.shared.pause()
            self.setPlaybackRate(0.0)
            return .success
        }

        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true

        // Optional: Forward/Backward (10 sec)
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [10]
        commandCenter.skipBackwardCommand.preferredIntervals = [10]

        commandCenter.skipForwardCommand.addTarget { _ in
            let newTime = AudioManager.shared.currentTime() + 10
            AudioManager.shared.seek(to: newTime)
            self.updateElapsedTime(newTime)
            return .success
        }

        commandCenter.skipBackwardCommand.addTarget { _ in
            let newTime = max(AudioManager.shared.currentTime() - 10, 0)
            AudioManager.shared.seek(to: newTime)
            self.updateElapsedTime(newTime)
            return .success
        }
    }

    private func setPlaybackRate(_ rate: Float) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = rate
    }
}
