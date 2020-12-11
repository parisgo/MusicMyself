//
//  PlayerAnimationView.swift
//  MusicMyself
//
//  Created by XYU on 11/12/2020.
//

import UIKit

class PlayerAnimationView: UIView {
    var numberOfBars = 4
    var barWidth = CGFloat(4)
    var barHeight = CGFloat(18)
    var barSpace = CGFloat(2)
    var barStopHeight = CGFloat(2)
    let barColor = UIColor.lightText
    let timerSpeed = 0.10
    var timer = Timer()
    var barArray: [AnyObject] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView() {
        addAnimationEffect(Xcoord: 17, Ycoord: 20)
        
        Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(timerChange), userInfo: nil, repeats: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func addAnimationEffect (Xcoord: CGFloat, Ycoord: CGFloat) {
        // Create UIView container
        self.frame = CGRect(x: Xcoord, y: Ycoord, width: CGFloat(numberOfBars) * CGFloat(barWidth), height: CGFloat(barHeight))
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        // Create temp object array
        var tempArray: [AnyObject] = []
        
        // Create bar UIImageView
        for i in 0...numberOfBars - 1 {
            let myImage = UIImageView()
            if i == 0 {
                myImage.frame = CGRect(x: 0, y: 0, width: barWidth, height: barStopHeight)
            } else {
                myImage.frame = CGRect(x: (CGFloat(barSpace) * CGFloat(i)) + (CGFloat(barWidth) * CGFloat(i)) , y: 0, width: barWidth, height: barStopHeight)
            }
            myImage.backgroundColor = barColor
            myImage.tag = 50 + i
            self.addSubview(myImage)
            tempArray.append(myImage)
        }
        barArray = tempArray
        
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2) * CGFloat(2.0))
    }

    @objc func timerChange() {
        let tempX = barWidth + barSpace
        var i = 50
        var j = 0
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            for bar in self.barArray  {
                let tempButton = self.viewWithTag(i)
                var rect = bar.frame
                rect?.origin.x = CGFloat(j) * CGFloat(tempX)
                rect?.origin.y = CGFloat(0)
                rect?.size.width = CGFloat(self.barWidth)
                rect?.size.height = CGFloat(arc4random_uniform(UInt32(self.barHeight)))
                tempButton!.frame = rect!
                i = i + 1
                j += 1
            }
        })
    }
}
