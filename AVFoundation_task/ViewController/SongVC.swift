//
//  ViewController.swift
//  AVFoundation_task
//
//  Created by TirthShah on 29/01/25.
//

import UIKit
import AVFoundation
import AVKit
import YoutubePlayerView

typealias songname = (String) -> ()
protocol datapassing {
    func datapass(image : String)
}

class SongVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_end_music: UILabel!
    @IBOutlet weak var my_Slider: UISlider!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var backgroundimage: UIImageView!
    @IBOutlet weak var btnplaypause: UIButton!
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var songandvideosemented: UISegmentedControl!
    @IBOutlet weak var youtubevideo: YoutubePlayerView!
    
    //MARK: - Variable
    var audio_player = AVAudioPlayer()
    var songname = ""
    var videoID = ""
    var playpause = false
    var repeatsong = false
    var closure:songname!
    var delegate : datapassing!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "dd"
        playerLayer?.frame = videoview.bounds
        youtubevideo.delegate = self
        lblSongName.text = songname
        imageSong.image = UIImage(named: songname)
        backgroundimage.image = UIImage(named: songname)
        btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        do {

            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: songname, ofType: "mp3")!)
            audio_player = try AVAudioPlayer.init(contentsOf: url)
            self.audio_player.delegate = self
            audio_player.prepareToPlay()
            audio_player.play()
            let end = Float(Double(Int(audio_player.duration)))
            my_Slider.minimumValue = 0
            my_Slider.maximumValue = end
            let music_min = Int(audio_player.duration) / 60 //Convert To Min
            let music_sec = Int(audio_player.duration) % 60 //Convert To Sec
            
            lbl_end_music.text = String(format: "%02d:%02d", music_min, music_sec)
            var mytimer = Timer()
            mytimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(myfunc) , userInfo: nil, repeats: true)
            
        }catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    //MARK: - Function
    var my_time = 0
    @objc func myfunc(){
        if audio_player.isPlaying == true {
            let song_end = Int(audio_player.duration)
            my_time += 1
            if my_time <= song_end {
                let music_min = my_time / 60
                let music_sec = my_time % 60
                let lbl_song = String(format: "%02d:%02d", music_min, music_sec)
                my_Slider.value = Float(my_time)
                lbl_time.text = "\(lbl_song)"
            }else{
                lbl_time.text = "00:00"
            }
        }else{
            let music_min = my_time / 60
            let music_sec = my_time % 60
            let lbl_song = String(format: "%02d:%02d", music_min, music_sec)
            lbl_time.text = "\(lbl_song)"
        }
    }
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    func playpausetoggel() {
        playpause.toggle()
        if songandvideosemented.selectedSegmentIndex == 0 {
            if playpause {
                audio_player.pause()
                btnplaypause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                audio_player.play()
                btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        } else {
            if playpause {
                player?.pause()
                youtubevideo.pause()
                btnplaypause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                player?.play()
                youtubevideo.play()
                btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
        }
    }
    
    func pauseIfPlaying() {
        if audio_player.isPlaying {
            audio_player.pause()
        }
    }
    
    //MARK: - Action
    
    @IBAction func songvideosegment(_ sender: Any) {
        if songandvideosemented.selectedSegmentIndex == 1 {
            imageSong.isHidden = true
            audio_player.pause()
            youtubevideo.isHidden = false
            youtubevideo.loadWithVideoId(videoID)
            youtubevideo.play()
        } else {
            imageSong.isHidden = false
            youtubevideo.isHidden = true
            player?.pause()
            playerLayer?.removeFromSuperlayer()
            audio_player.play()
            btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playpause = false
        }
    }
    
    
    @IBAction func my_Slider_Action(_ sender: Any) {
        let resume_time = TimeInterval(my_Slider.value)
        audio_player.currentTime = max(audio_player.currentTime , resume_time)
        my_time = Int(resume_time)
    }
    
    @IBAction func btnShuffle(_ sender: Any) {
    }
    
    @IBAction func btnBackward(_ sender: Any) {
        if songandvideosemented.selectedSegmentIndex == 0 {
            let newTime = max(audio_player.currentTime - 10.0, 0.0)
            audio_player.currentTime = newTime
            my_time = Int(newTime)
        } else {
            guard let currentTime = player?.currentTime() else { return }
            let seconds = CMTimeGetSeconds(currentTime) - 10
            let time = CMTime(seconds: max(seconds, 0), preferredTimescale: 600)
            player?.seek(to: time)
        }
    }
    
    @IBAction func btnForward(_ sender: Any) {
        if songandvideosemented.selectedSegmentIndex == 0 {
            let newTime = min(audio_player.currentTime + 10.0, audio_player.duration)
            audio_player.currentTime = newTime
            my_time = Int(newTime)
        } else {
            guard let duration = player?.currentItem?.duration,
                  let currentTime = player?.currentTime() else { return }
            let maxDuration = CMTimeGetSeconds(duration)
            let seconds = CMTimeGetSeconds(currentTime) + 10
            youtubevideo.playVideo(at: my_time + 10)
            let time = CMTime(seconds: min(seconds, maxDuration), preferredTimescale: 600)
            player?.seek(to: time)
        }
    }
    @IBAction func btnPlayPause(_ sender: Any) {
        playpausetoggel()
        
    }
    
    @IBAction func btnRepeat(_ sender: Any) {
        repeatsong.toggle()
        print(repeatsong)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        guard let songname = lblSongName.text else {return}
        closure(songname)
        delegate.datapass(image: songname)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpNext(_ sender: Any) {
        guard let  ListSongVC = self.storyboard?.instantiateViewController(withIdentifier: "ListSongVC") as? ListSongVC else{return}
        self.present(ListSongVC, animated: true)
    }
}

extension SongVC : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if repeatsong {
            player.currentTime = 0
            lbl_time.text = "00:00"
            my_Slider.value = 0
            my_time = 0
            player.play()
        } else {
            print("complete")
            lbl_time.text = "00:00"
            my_Slider.value = 0
            my_time = 0
            btnplaypause.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
}


extension SongVC: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.play()
    }

    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        if "\(state)" == "playing" {
            print("<<<<<<<<<<<<<<<<,")
            btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else {
            print("?>????????????????")
            btnplaypause.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print( "Changed to quality: \(quality)")
    }

    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }

    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Time \(time)")
        my_time = Int(time)
    }
}
