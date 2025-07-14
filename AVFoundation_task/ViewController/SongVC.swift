//
//  ViewController.swift
//  AVFoundation_task
//
//  Created by TirthShah on 29/01/25.
//

import UIKit
import AVFoundation
import AVKit

typealias songname = (String) -> ()
protocol datapassing {
    func datapass(image : String)
}

class SongVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_end_music: UILabel!
    @IBOutlet weak var my_Slider: UISlider!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var backgroundimage: UIImageView!
    @IBOutlet weak var btnplaypause: UIButton!
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var songandvideosemented: UISegmentedControl!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    //MARK: - Variables
    var songname = ""
    var videoID = ""
    var playpause = false
    var repeatsong = false
    var closure: songname!
    var delegate: datapassing!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var my_time = 0

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageHeight.constant = UIScreen.main.bounds.height / 2
        playerLayer?.frame = videoview.bounds
        lblSongName.text = songname
        imageSong.image = UIImage(named: songname)
        backgroundimage.image = UIImage(named: songname)
        btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        // Setup audio
        AudioManager.shared.setupAudioPlayer(with: songname)
        AudioManager.shared.play()
        // Lock screen playback info
        NowPlayingManager.shared.setup(
            songName: songname,
            artwork: UIImage(named: songname),
            duration: AudioManager.shared.duration()
        )
        NowPlayingManager.shared.setupRemoteCommands()
        // Setup slider and duration label
        lbl_end_music.text = formatTime(AudioManager.shared.duration())
        my_Slider.minimumValue = 0
        my_Slider.maximumValue = Float(AudioManager.shared.duration())
        // Timer callback
        AudioManager.shared.timerCallback = { [weak self] currentTime in
            guard let self = self else { return }
            self.my_time = Int(currentTime)
            self.my_Slider.value = Float(currentTime)
            self.lbl_time.text = self.formatTime(currentTime)
            NowPlayingManager.shared.updateElapsedTime(currentTime)
        }
    }

    //MARK: - Helpers
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func playpausetoggel() {
        playpause.toggle()
        if songandvideosemented.selectedSegmentIndex == 0 {
            AudioManager.shared.togglePlayPause()
            let icon = AudioManager.shared.player?.isPlaying == true ? "pause.fill" : "play.fill"
            btnplaypause.setImage(UIImage(systemName: icon), for: .normal)
        } else {
            btnplaypause.setImage(UIImage(systemName: playpause ? "play.fill" : "pause.fill"), for: .normal)
        }
    }

    //MARK: - Actions
    @IBAction func songvideosegment(_ sender: Any) {
        if songandvideosemented.selectedSegmentIndex == 1 {
            imageSong.isHidden = true
            AudioManager.shared.pause()
            btnplaypause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playpause = true
        } else {
            imageSong.isHidden = false
            AudioManager.shared.play()
            btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playpause = false
        }
    }

    @IBAction func my_Slider_Action(_ sender: UISlider) {
        let newTime = TimeInterval(sender.value)
        AudioManager.shared.seek(to: newTime)
        my_time = Int(newTime)
    }

    @IBAction func btnBackward(_ sender: Any) {
        if songandvideosemented.selectedSegmentIndex == 0 {
            let newTime = max(AudioManager.shared.currentTime() - 10, 0)
            AudioManager.shared.seek(to: newTime)
        }
    }

    @IBAction func btnForward(_ sender: Any) {
        if songandvideosemented.selectedSegmentIndex == 0 {
            let newTime = min(AudioManager.shared.currentTime() + 10, AudioManager.shared.duration())
            AudioManager.shared.seek(to: newTime)
        }
    }

    @IBAction func btnPlayPause(_ sender: Any) {
        playpausetoggel()
    }

    @IBAction func btnRepeat(_ sender: Any) {
        repeatsong.toggle()
        AudioManager.shared.isRepeating = repeatsong
        print("Repeat mode: \(repeatsong)")
    }

    @IBAction func btnBack(_ sender: Any) {
        guard let songname = lblSongName.text else { return }
        closure(songname)
        delegate.datapass(image: songname)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnUpNext(_ sender: Any) {
        guard let listVC = storyboard?.instantiateViewController(withIdentifier: "ListSongVC") as? ListSongVC else { return }
        present(listVC, animated: true)
    }
}
