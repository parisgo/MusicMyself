//
//  PlayerListViewController.swift
//  MusicMyself
//
//  Created by XYU on 13/12/2020.
//

import UIKit
import MobileCoreServices

class PlayerListViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labAuthor: UILabel!
    @IBOutlet weak var labDetail: UITextView!    
    
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        var fichier = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
        guard fichier != nil else {
            return
        }
        
        if let file = Fichier().get(id: fichier.id) {
            labTitle.text = file.title
            labAuthor.text = file.author
            labDetail.text = file.info
        }
        
        imgView.image = Helper.getImage(id: MyPlayer.instance.currentFileIndex)
        
//        let viewPlayer = PlayerWaveView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
//        self.imgView.addSubview(viewPlayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?()
    }
}
