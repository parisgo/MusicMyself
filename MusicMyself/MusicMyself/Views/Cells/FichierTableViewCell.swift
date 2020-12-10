//
//  FichierTableViewCell.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class FichierTableViewCell: UITableViewCell {
    @IBOutlet weak var fichierImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    
    var fichier: Fichier!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fichierImage.layer.cornerRadius = 6
        fichierImage.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.title.text = fichier?.title
        
        self.fichierImage.contentMode = UIView.ContentMode.scaleAspectFit
        
        let imagePath = Helper.checkImage(id: fichier.id!)
        if(imagePath == nil) {
            self.fichierImage.image = UIImage(named: "bg_heart.png")
        }
        else {
            self.fichierImage.image = UIImage.init(contentsOfFile: imagePath!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
