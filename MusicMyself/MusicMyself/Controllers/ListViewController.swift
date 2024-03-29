//
//  ListViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit
import AVKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playView: PlayerView!
    
    var albums: [Album]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Playlist"

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName:"ListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cellList")
        
        //LockScreen media control registre
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        albums = Album().getList()
        collectionView.reloadData()
        
        MyPlayer.instance.fichiers = Fichier().getListByAlbum(aId: 1);
        MyPlayer.instance.currentAlbumId = 1
    }
    
    @IBAction func addClick(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ListAlbumViewController") {
            let tmp = controller as! ListAlbumViewController
            tmp.callback = {
                self.albums = Album().getList()
                self.collectionView.reloadData()
            }
            self.navigationController?.pushViewController(tmp, animated: true)
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEvent.EventType.remoteControl{
            switch event!.subtype{
            case UIEventSubtype.remoteControlPlay:
                playView.startOrStop()
            case UIEventSubtype.remoteControlPause:
                playView.startOrStop()
            case UIEventSubtype.remoteControlNextTrack:
                playView.next()
            case UIEventSubtype.remoteControlPreviousTrack:
                playView.previous()
            default:
                print("remoteControlReceived")
            }
        }
    }
}

extension ListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellList", for: indexPath) as! ListCollectionViewCell
        cell.album = albums[indexPath.row]
        cell.listTitle.text = cell.album.title
        
        return cell
    }
}

extension ListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") {
            let tmp = controller as! ListDetailViewController
            tmp.album = albums[indexPath.row]
                
            //present(controller, animated: true, completion: nil)
            self.navigationController?.pushViewController(tmp, animated: true)
        }
    }
}

extension ListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }
}

extension ListViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        playView.playerDidFinish()
    }
}
