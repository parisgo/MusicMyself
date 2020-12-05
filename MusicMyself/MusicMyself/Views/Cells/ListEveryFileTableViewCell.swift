//
//  ListEveryFileTableViewCell.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class ListEveryFileTableViewCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    
    var fichier: Fichier!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.labTitle.text = fichier?.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
