//
//  WifiViewController.swift
//  MusicMyself
//
//  Created by XYU on 02/12/2020.
//

import UIKit

class WifiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addBackground()
    }

    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "bg_heart.png")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
    }
}
