//
//  PlayerListViewController.swift
//  MusicMyself
//
//  Created by XYU on 13/12/2020.
//

import UIKit
import AVKit
import MobileCoreServices

class PlayerListViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labAuthor: UILabel!
    @IBOutlet weak var labDetail: UITextView!
    
    @IBOutlet weak var viewDynamicBar: UIView!
    @IBOutlet weak var sliderView: UISlider!
    
    let pauseImageHeight: Float = 60.0
    
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyPlayer.instance.updater = CADisplayLink(target: self, selector: #selector(updateUI))
        MyPlayer.instance.updater?.add(to: .current, forMode: .common)
        
        connectVolumeTap()
        
        sliderView.minimumValue = 0
        sliderView.maximumValue = Float(MyPlayer.instance.audioLengthSamples)
        sliderView.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc func updateUI() {
        //print("curentframe:\(MyPlayer.instance.currentFrame), seekframe:\(MyPlayer.instance.seekFrame)")
        MyPlayer.instance.currentPosition = MyPlayer.instance.currentFrame + MyPlayer.instance.seekFrame
        MyPlayer.instance.currentPosition = max(MyPlayer.instance.currentPosition, 0)
        MyPlayer.instance.currentPosition = min(MyPlayer.instance.currentPosition, MyPlayer.instance.audioLengthSamples)
        
        //progressView.progress = Float(MyPlayer.instance.currentPosition) / Float(MyPlayer.instance.audioLengthSamples)
        sliderView.value = Float(MyPlayer.instance.currentPosition)
    }
    
    @objc func sliderDidEndSliding(_ sender: UISlider) {
        
        MyPlayer.instance.skip(newPosition: sender.value)
        sliderView.value = sender.value
        
        updateUI()
    }
    
    func connectVolumeTap() {
        let format = MyPlayer.instance.engine.mainMixerNode.outputFormat(forBus: 0)
        
        MyPlayer.instance.engine.mainMixerNode.removeTap(onBus: 0)
        MyPlayer.instance.engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, when in
            guard let channelData = buffer.floatChannelData,
                let updater = MyPlayer.instance.updater else {
                return
            }

            let channelDataValue = channelData.pointee
            let channelDataValueArray = stride(from: 0,
                                               to: Int(buffer.frameLength),
                                               by: buffer.stride).map{ channelDataValue[$0] }
            let rms = sqrt(channelDataValueArray.map{ $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
            let avgPower = 20 * log10(rms)
            let meterLevel = self.scaledPower(power: avgPower)

            DispatchQueue.main.async {
                self.viewDynamicBar.frame.size.height = CGFloat(min((meterLevel * self.pauseImageHeight),
                                                                    self.pauseImageHeight))
                
                self.viewDynamicBar.frame.origin.y = 200 - self.viewDynamicBar.frame.size.height
            }
        }
    }
    
    func scaledPower(power: Float) -> Float {
      guard power.isFinite else { return 0.0 }

      if power < MyPlayer.instance.minDb {
        return 0.0
      } else if power >= 1.0 {
        return 1.0
      } else {
        return (abs(MyPlayer.instance.minDb) - abs(power)) / abs(MyPlayer.instance.minDb)
      }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        let fichier = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
        guard fichier != nil else {
            return
        }
        
        if let file = Fichier().get(id: fichier.id) {
            labTitle.text = file.title
            labAuthor.text = file.author
            labDetail.text = file.info
            imgView.image = Helper.getImage(id: file.id)
        }
        
//        let viewPlayer = PlayerWaveView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
//        self.imgView.addSubview(viewPlayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?()
    }
}
