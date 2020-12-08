//
//  ListAlbumTableViewCell.swift
//  MusicMyself
//
//  Created by XYU on 08/12/2020.
//

import UIKit

class ListAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    
    var fichier: Fichier!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteClick(_ sender: Any) {
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
