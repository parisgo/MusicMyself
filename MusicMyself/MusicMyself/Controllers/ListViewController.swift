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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        albums = Album().getList()
        collectionView.reloadData()
        
        if(MyPlayer.instance.audioPlayer == nil) {
            MyPlayer.instance.fichiers = Fichier().getListByAlbum(aId: 1);
        }
        else {
            MyPlayer.instance.audioPlayer.delegate = self
        }
        
        playView.setCurrentInfo()
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

extension ListViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
            playView.playerDidFinish()
        }
    }
}
