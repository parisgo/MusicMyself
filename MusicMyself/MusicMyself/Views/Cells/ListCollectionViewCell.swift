//
//  ListCollectionViewCell.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listTitle: UILabel!
    
    var album: Album!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.listTitle.text = album?.title
        
        /*
        self.fichierImage.contentMode = UIView.ContentMode.scaleAspectFit
        
        let imagePath = Helper.checkImage(id: fichier.id!)
        if(imagePath == nil) {
            self.fichierImage.image = UIImage(named: "bg_heart.png")
        }
        else {
            self.fichierImage.image = UIImage.init(contentsOfFile: imagePath!)
        }
        */
    }
}
