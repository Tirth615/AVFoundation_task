//
//  ViewController.swift
//  AVFoundation_task
//
//  Created by TirthShah on 29/01/25.
//

import UIKit
import AVFoundation

class SongVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var my_Stepper: UIStepper!
    @IBOutlet weak var lbl_end_music: UILabel!
    @IBOutlet weak var my_Slider: UISlider!
    @IBOutlet weak var lblSongName: UILabel!
    
    //MARK: - Variable
    var audio_player = AVAudioPlayer() //OBJ Of AVAudioPlayer
    var songname = ""
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "dd"
        lblSongName.text = songname
        do {
            //Path Music File
            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: songname, ofType: "mp3")!)
            
            audio_player = try AVAudioPlayer.init(contentsOf: url)
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
    
    //MARK: - Action
    
    @IBAction func my_Slider_Action(_ sender: Any) {
        
        let resume_time = TimeInterval(my_Slider.value)
        audio_player.currentTime = max(audio_player.currentTime , resume_time)
        
        my_time = Int(resume_time)
    }
    
    @IBAction func btnShuffle(_ sender: Any) {
    }
    
    @IBAction func btnBackward(_ sender: Any) {
        audio_player.currentTime = max(audio_player.currentTime - 10.0 , 0.0)
        my_time -= 10
    }
    
    @IBAction func btnForward(_ sender: Any) {
        audio_player.currentTime = max(audio_player.currentTime + 10.0 , 0.0)
        my_time += 10
    }
    @IBAction func btnPlayPause(_ sender: Any) {
//        audio_player.play()
        audio_player.pause()
    }
    
    @IBAction func btnRepeat(_ sender: Any) {
    }
    
    @IBAction func btn_backward(_ sender: Any) {
        audio_player.currentTime = max(audio_player.currentTime + 10.0 , 0.0)
        my_time += 10
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
