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
        
        MyPlayer.instance.currentAlbumId = album.id!
        self.listTitle.text = album?.title
        self.listImage.image = Helper.getImage(id: (album?.fIdFirst)!)
    }
}
