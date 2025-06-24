//
//  ListSongVC.swift
//  AVFoundation_task
//
//  Created by Tirth Shah on 24/06/25.
//

import UIKit

class ListSongVC: UIViewController {

    
    @IBOutlet weak var tableSongList: UITableView!
    
    var songList : [String] = [
        "Ishq Hai",
        "Sajna"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableSongList.delegate = self
        self.tableSongList.dataSource = self
        
        self.tableSongList.register(UINib(nibName: "ListSongTVC", bundle: nil), forCellReuseIdentifier: "ListSongTVC")
    }
    
}

extension ListSongVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListSongTVC") as? ListSongTVC else {
            return UITableViewCell()
        }
        cell.lblSongName.text = songList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let  SongVC = self.storyboard?.instantiateViewController(withIdentifier: "SongVC") as? SongVC else{return}
        SongVC.songname = self.songList[indexPath.row]
        self.navigationController?.isNavigationBarHidden = true
        SongVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(SongVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
