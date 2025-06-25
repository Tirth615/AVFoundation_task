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
    
    //MARK: - IBOutlet
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_end_music: UILabel!
    @IBOutlet weak var my_Slider: UISlider!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var btnplaypause: UIButton!
    @IBOutlet weak var videoview: UIView!
    
    
    @IBOutlet weak var songandvideosemented: UISegmentedControl!
    
    //MARK: - Variable
    var audio_player = AVAudioPlayer()
    var songname = ""
    var playpause = false
    var repeatsong = false
    var closure:songname!
    var delegate : datapassing!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "dd"
        playerLayer?.frame = videoview.bounds
        
        lblSongName.text = songname
        imageSong.image = UIImage(named: songname)
        btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        do {
            //Path Music File
            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: songname, ofType: "mp3")!)
            
            audio_player = try AVAudioPlayer.init(contentsOf: url)
            self.audio_player.delegate = self
            audio_player.prepareToPlay()
            audio_player.play()
            
            //Pass The Slider Value
            let end = Float(Double(Int(audio_player.duration)))
            my_Slider.minimumValue = 0
            my_Slider.maximumValue = end
            
            let music_min = Int(audio_player.duration) / 60 //Convert To Min
            let music_sec = Int(audio_player.duration) % 60 //Convert To Sec
            
            lbl_end_music.text = String(format: "%02d:%02d", music_min, music_sec)
            
            //Every 1 Sec To Call The Function
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
    
    func video() {
        // Clean up previous layer if needed
        playerLayer?.removeFromSuperlayer()
        player = nil
        
        // Load video from bundle
        guard let path = Bundle.main.path(forResource: "5sec", ofType: "mp4") else {
            print("Video not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        // Create player and layer
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoview.bounds
        playerLayer?.videoGravity = .resizeAspect
        
        if let layer = playerLayer {
            videoview.layer.addSublayer(layer)
        }
        
        player?.play()
        playpause = false
        btnplaypause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
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
                btnplaypause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                player?.play()
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
            video()
        } else {
            imageSong.isHidden = false
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
