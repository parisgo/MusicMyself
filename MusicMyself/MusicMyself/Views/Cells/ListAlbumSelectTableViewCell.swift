//
//  ListAlbumSelectTableViewCell.swift
//  MusicMyself
//
//  Created by XYU on 08/12/2020.
//

import UIKit

class ListAlbumSelectTableViewCell: UITableViewCell {
    var fichier: Fichier!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.labTitle.text = fichier?.title
        
        self.imgView.contentMode = UIView.ContentMode.scaleAspectFit
        
        let imagePath = Helper.checkImage(id: fichier.id!)
        if(imagePath == nil) {
            self.imgView.image = UIImage(named: "bg_heart.png")
        }
        else {
            self.imgView.image = UIImage.init(contentsOfFile: imagePath!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
