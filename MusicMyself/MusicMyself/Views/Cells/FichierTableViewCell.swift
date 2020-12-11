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
    
    var viewPlayerAnimation: UIView!
    
    var fichier: Fichier!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fichierImage.layer.cornerRadius = 6
        fichierImage.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.title.text = fichier?.title
        self.author.text = fichier?.author
        
        self.fichierImage.contentMode = UIView.ContentMode.scaleAspectFit
        self.fichierImage.image = Helper.getImage(id: fichier.id!)
        
        showAnimation(display: false)
        
        guard MyPlayer.instance.audioPlayer != nil && MyPlayer.instance.audioPlayer.isPlaying && MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex].id == fichier.id! else {
            return
        }
        
        showAnimation(display: true)
    }
    
    func showAnimation(display: Bool) {
        if display {
            viewPlayerAnimation = PlayerAnimationView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
            viewPlayerAnimation.tag = 88
            self.fichierImage.addSubview(viewPlayerAnimation)
        }
        else {
            if let viewWithTag = self.viewWithTag(88) {
                viewWithTag.removeFromSuperview()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
