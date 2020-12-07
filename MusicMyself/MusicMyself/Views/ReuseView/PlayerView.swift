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
    var isLoop: Bool = false
    var isRepeat: Bool = false
    
    private init() {}
}

class PlayerView: UIView, UIActionSheetDelegate, AVAudioPlayerDelegate {
    
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
    
    @IBAction func btnMore(_ sender: Any) {
        guard MyPlayer.instance.fichiers != nil && MyPlayer.instance.fichiers.count > 0 else {
            return
        }
        
        let actionSheet = UIAlertController(title: "Action", message: "You want", preferredStyle: .actionSheet)
        
        let actPrevious = UIAlertAction(title: "Previous", style: .default) { (action) in
            if MyPlayer.instance.currentFileIndex == 0 {
                MyPlayer.instance.currentFileIndex = MyPlayer.instance.fichiers.count - 1
            }
            else {
                MyPlayer.instance.currentFileIndex -= 1
            }
            
            self.play()
        }
        let actNext = UIAlertAction(title: "Next", style: .default) { (action) in
            if MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count - 1 {
                MyPlayer.instance.currentFileIndex = 0
            }
            else {
                MyPlayer.instance.currentFileIndex += 1
            }
            
            self.play()
        }
        
        let repeatTitle = MyPlayer.instance.isRepeat ? "No repeat" : "Repeat"
        let actRepeat = UIAlertAction(title: repeatTitle, style: .default) { (action) in
            MyPlayer.instance.isRepeat = !MyPlayer.instance.isRepeat
        }
        
        let loopTitle = MyPlayer.instance.isLoop ? "No loop" : "Loop"
        let actLoop = UIAlertAction(title: loopTitle, style: .default) { (action) in
            MyPlayer.instance.isLoop = !MyPlayer.instance.isLoop
        }
        
        let actClose = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        actionSheet.addAction(actPrevious)
        actionSheet.addAction(actNext)
        actionSheet.addAction(actRepeat)
        actionSheet.addAction(actLoop)
        actionSheet.addAction(actClose)
        
        self.parentViewController?.present(actionSheet, animated: true, completion: nil)
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
        
        print("play index: \(MyPlayer.instance.currentFileIndex)")
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
    
    func playerDidFinish() {
        if MyPlayer.instance.isRepeat {
            play()
            return
        }
        
        if(MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count - 1) {
            MyPlayer.instance.currentFileIndex = 0;
        }
        else {
            MyPlayer.instance.currentFileIndex+=1
        }
        
        if (!MyPlayer.instance.isLoop) && MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count - 1 {
            return;
        }
        
        play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        self.playerDidFinish()
    }
}
