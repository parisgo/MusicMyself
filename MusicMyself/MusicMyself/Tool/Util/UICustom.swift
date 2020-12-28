//
//  UICustom.swift
//  MusicMyself
//
//  Created by XYU on 26/12/2020.
//

import Foundation
import UIKit

class ProgressSlider:UISlider {
    let bufferProgress =  UIProgressView(progressViewStyle: .default)

    override init (frame : CGRect) {
        super.init(frame : frame)
    }

    convenience init () {
        self.init(frame:CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.minimumTrackTintColor = UIColor.clear
        self.maximumTrackTintColor = UIColor.clear
        bufferProgress.backgroundColor = UIColor.clear
        bufferProgress.isUserInteractionEnabled = false
        bufferProgress.progress = 0.0
        bufferProgress.progressTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        bufferProgress.trackTintColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(bufferProgress)
    }
}
