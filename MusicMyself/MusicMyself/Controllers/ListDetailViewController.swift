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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:"ListEveryFileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let tmp = album {
            listTitle.text = tmp.title
            fichiers = Fichier().getListByAlbum(aId: tmp.id);
            
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
        
        playerView.showButtonImage(isStart: true)
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    }
}
