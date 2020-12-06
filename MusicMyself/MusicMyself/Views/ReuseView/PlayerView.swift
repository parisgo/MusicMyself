//
//  PlayerView.swift
//  MusicMyself
//
//  Created by XYU on 06/12/2020.
//

import UIKit
import AVKit

class MyPlayer {
    static let instance = MyPlayer()
    
    var audioPlayer:AVAudioPlayer! = nil
    var currentFileIndex = 0
    var fichiers: [Fichier]!
    
    private init() {}
}

class PlayerView: UIView {
    
    @IBOutlet weak var btnStartStop: UIButton!    
    @IBOutlet weak var labFileTitle: UILabel!
    @IBOutlet weak var labFileAuthor: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    
    var album: Album!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "PlayerView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func btnStartOrStop(_ sender: Any) {
        if(MyPlayer.instance.audioPlayer != nil && MyPlayer.instance.audioPlayer.isPlaying) {
            MyPlayer.instance.audioPlayer.stop()
            showButtonImage(isStart: true)
        }
        else {
            play()
            showButtonImage(isStart: false)
        }
    }
    
    func showButtonImage(isStart: Bool) {
        let play = UIImage(named: "player_start.png")
        let stop = UIImage(named: "player_stop.png")
        
        if(isStart) {
            btnStartStop.setImage(play, for: .normal)
        }
        else {
            btnStartStop.setImage(stop, for: .normal)
        }
    }
    
    func play(){
        setPlayDameon();
        
        guard MyPlayer.instance.fichiers != nil && MyPlayer.instance.fichiers.count > 0 else {
            showButtonImage(isStart: true)
            return
        }
        
        let currentFile = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
        let filePath = Helper.checkFile(name: currentFile.name)
        guard filePath != nil else {
            return;
        }
        
        MyPlayer.instance.audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath!))
        MyPlayer.instance.audioPlayer.delegate = self;
        MyPlayer.instance.audioPlayer.play()
        
        labFileTitle.text = currentFile.title
        labFileAuthor.text = currentFile.author
        setFileImage(id: currentFile.id)
        
        showButtonImage(isStart: false)
    }
    
    func setCurrentInfo() {
        guard MyPlayer.instance.fichiers != nil && MyPlayer.instance.fichiers.count > 0 else {
            return
        }
        
        let cur = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
        labFileTitle.text = cur.title
        labFileAuthor.text = cur.author
        setFileImage(id: cur.id)
        
        guard MyPlayer.instance.audioPlayer != nil else {
            return
        }
        showButtonImage(isStart: !MyPlayer.instance.audioPlayer.isPlaying)
    }
    
    func setFileImage(id: Int) {
        let imagePath = Helper.checkImage(id: id)
        if(imagePath == nil) {
            self.imgFile.image = UIImage(named: "bg_heart.png")
        }
        else {
            self.imgFile.image = UIImage.init(contentsOfFile: imagePath!)
        }
    }
    
    func setPlayDameon() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch _ { }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ { }
    }
}

extension PlayerView: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if(MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count - 1) {
            MyPlayer.instance.currentFileIndex = 0;
        }
        else {
            MyPlayer.instance.currentFileIndex+=1
        }

        play()
    }
}
