//
//  ListSongVC.swift
//  AVFoundation_task
//
//  Created by Tirth Shah on 24/06/25.
//

import UIKit

class ListSongVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableSongList: UITableView!
    @IBOutlet weak var lblSong: UILabel!
    @IBOutlet weak var imagesong: UIImageView!
    @IBOutlet weak var viewsong: UIView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    //MARK: Variable
    let song :[SongStruct] = [
        SongStruct(title: "Ishq Hai", imagename: "Ishq Hai"),
        SongStruct(title: "Sajna", imagename: "Sajna"),
        SongStruct(title: "5sec", imagename: "5sec")
    ]
    var songVC: SongVC?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSongList.delegate = self
        self.tableSongList.dataSource = self
        self.tableSongList.register(UINib(nibName: "ListSongTVC", bundle: nil), forCellReuseIdentifier: "ListSongTVC")
    }
    
    //MARK: - Button Action
    @IBAction func btnPlayPause(_ sender: Any) {
        songVC?.playpausetoggel()
        if ((songVC?.playpause) != nil) && ((songVC?.playpause)!) {
            btnPlayPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            btnPlayPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
}

//MARK: - Extension For Table View delegate And Datasource
extension ListSongVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListSongTVC") as? ListSongTVC else {
            return UITableViewCell()
        }
        let songs = song[indexPath.row]
        cell.lblSongName.text = songs.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let  SongVC = self.storyboard?.instantiateViewController(withIdentifier: "SongVC") as? SongVC else{return}
        songVC?.pauseIfPlaying()
        self.songVC = SongVC
        let songs = song[indexPath.row]
        SongVC.songname = songs.imagename
        SongVC.closure = { text in
            self.lblSong.text = text
        }
        SongVC.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        SongVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(SongVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }   
}

//MARK: - Extension for passing data
extension ListSongVC : datapassing {
    func datapass(image : String) {
        imagesong.image = UIImage(named: image)
    }
}
