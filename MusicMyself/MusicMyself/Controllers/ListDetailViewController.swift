//
//  ListDetailViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit
import AVFoundation

class ListDetailViewController: UIViewController {

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listTitle: UILabel!
    
    @IBOutlet weak var playerView: PlayerView!
    
    var album: Album!
    var fichiers: [Fichier]!
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:"ListEveryFileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        //LockScreen Media control registre
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let tmp = album {
            listTitle.text = tmp.title
            fichiers = Fichier().getListByAlbum(aId: tmp.id)
            
            guard fichiers != nil && fichiers.count > 0 else {
                return
            }
            
            tableView.reloadData()
            
            let firstFile = fichiers[0]
            let imagePath = Helper.checkImage(id: firstFile.id)
            if(imagePath == nil) {
                self.listImage.image = UIImage(named: "bg_heart.png")
            }
            else {
                self.listImage.image = UIImage.init(contentsOfFile: imagePath!)
            }
            
            playerView.setCurrentInfo()
        }
        
        if MyPlayer.instance.audioPlayer != nil {
            playerView.showButtonImage(isStart: !MyPlayer.instance.audioPlayer.isPlaying)
        }        
    }

    @IBAction func deleteClick(_ sender: Any) {
        guard album.id != 1 else {
            return
        }
        
        let refreshAlert = UIAlertController(title: "Confirmation", message: "List will be delete", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            Album().delete(id: self.album.id)
            self.callback?()
            
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEvent.EventType.remoteControl{
            switch event!.subtype{
            case UIEventSubtype.remoteControlPlay:
                playerView.startOrStop()
            case UIEventSubtype.remoteControlPause:
                playerView.startOrStop()
            case UIEventSubtype.remoteControlNextTrack:
                playerView.next()
            case UIEventSubtype.remoteControlPreviousTrack:
                playerView.previous()
            default:
                print("remoteControlReceived")
            }
        }
    }
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fichiers != nil) ? fichiers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListEveryFileTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyPlayer.instance.fichiers = fichiers
        
        MyPlayer.instance.currentFileIndex = indexPath.row;
        
        playerView.setCurrentInfo()
        playerView.play()
        
        if(MyPlayer.instance.audioPlayer != nil) {
            MyPlayer.instance.audioPlayer.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if indexPath.row == MyPlayer.instance.currentFileIndex {
                self.playerView.next()
            }
            
            Album().deleteFileFromAlbum(albumId: self.album.id, fileId: self.fichiers[indexPath.row].id)
            self.fichiers.remove(at: indexPath.row)
            tableView.reloadData()
            
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfig
    }    
}

extension ListDetailViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        playerView.playerDidFinish()
    }
}
