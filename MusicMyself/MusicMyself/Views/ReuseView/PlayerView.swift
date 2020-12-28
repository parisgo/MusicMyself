//
//  PlayerView.swift
//  MusicMyself
//
//  Created by XYU on 06/12/2020.
//

import UIKit
import AVKit
import MediaPlayer

class MyPlayer {
    static let instance = MyPlayer()
    
    var currentFileIndex = 0
    var fichiers: [Fichier] = []
    var currentAlbumId = 0
    var isLoop: Bool = false
    var isRepeat: Bool = false
    
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var rateEffect = AVAudioUnitTimePitch()
    var audioFormat: AVAudioFormat?
    
    var updater: CADisplayLink?
    
    var currentPosition: AVAudioFramePosition = 0
    var seekFrame: AVAudioFramePosition = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    var audioSampleRate: Float = 0
    var audioLengthSeconds: Float = 0
    
    let minDb: Float = -80.0
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    var currentFrame: AVAudioFramePosition {
      guard let lastRenderTime = player.lastRenderTime,
        let playerTime = player.playerTime(forNodeTime: lastRenderTime) else {
          return 0
      }

      return playerTime.sampleTime
    }
    
    enum TimeConstant {
      static let secsPerMin = 60
      static let secsPerHour = TimeConstant.secsPerMin * 60
    }
    
    var audioFile: AVAudioFile? {
      didSet {
        if let audioFile = audioFile {
          audioLengthSamples = audioFile.length
          audioFormat = audioFile.processingFormat
          audioSampleRate = Float(audioFormat?.sampleRate ?? 44100)
          audioLengthSeconds = Float(audioLengthSamples) / audioSampleRate
        }
      }
    }
    
    var audioFileURL: URL? {
      didSet {
        if let audioFileURL = audioFileURL {
          audioFile = try? AVAudioFile(forReading: audioFileURL)
        }
      }
    }
    
    private init() {
        engine.attach(player)
        engine.attach(rateEffect)
        engine.connect(player, to: rateEffect, format: audioFormat)
        engine.connect(rateEffect, to: engine.mainMixerNode, format: audioFormat)

        engine.prepare()
        
        do {
            try engine.start()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func skip(newPosition: Float) {
        guard let audioFile = audioFile,
          let updater = updater else {
          return
        }
        
        //seekFrame = AVAudioFramePosition(5000)
        currentPosition = AVAudioFramePosition(newPosition)
        
        player.stop()
        
        if currentPosition < audioLengthSamples {
            player.scheduleSegment(audioFile, startingFrame: currentPosition, frameCount: AVAudioFrameCount(audioLengthSamples - AVAudioFramePosition(newPosition)), at: nil) { [weak self] in
                  }

            if !updater.isPaused {
                player.play()
            }
        }
    }
}

class PlayerView: UIView, UIActionSheetDelegate {
    @IBOutlet weak var btnStartStop: UIButton!    
    @IBOutlet weak var labFileTitle: UILabel!
    @IBOutlet weak var labFileAuthor: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    
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
        
        imgFile.layer.cornerRadius = 6
        imgFile.layer.masksToBounds = true
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "PlayerView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tapCell = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        self.addGestureRecognizer(tapCell)
        self.isUserInteractionEnabled = true
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        setCurrentInfo()
        showButtonImage()
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "PlayerListViewController") as? PlayerListViewController {
            controller.callback = {
                guard self.parentViewController != nil else {
                    return
                }
                
                let view = self.parentViewController as? ListDetailViewController
                if view != nil {
                }
            }
            
            self.parentViewController?.present(controller, animated: true)
            //self.parentViewController?.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func btnMore(_ sender: Any) {
        guard MyPlayer.instance.fichiers.count > 0 else {
            return
        }
        
        let actionSheet = UIAlertController(title: "Action", message: "You want", preferredStyle: .actionSheet)
        
        let actPrevious = UIAlertAction(title: "Previous", style: .default) { (action) in
            self.previous()
        }
        let actNext = UIAlertAction(title: "Next", style: .default) { (action) in
            self.next()
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
        self.startOrStop()
    }
    
    func play(){        
        guard MyPlayer.instance.fichiers.count > 0 else {
            showButtonImage()
            return
        }
        
        let currentFile = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
        let filePath = Helper.checkFile(name: currentFile.name)
        guard filePath != nil else {
            return;
        }
        
        setCurrentInfo()
        showButtonImage()
        
        startAudio()
        setPlayDameon()
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist : currentFile.author,  MPMediaItemPropertyTitle : currentFile.title]
    }
    
    func startAudio() {
        let currentFile = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
        let filePath = Helper.checkFile(name: currentFile.name)
        guard filePath != nil else {
          return;
        }
        
        MyPlayer.instance.audioFileURL = URL(fileURLWithPath: filePath!)

        scheduleAudioFile()
        MyPlayer.instance.player.play()
    }
    
    func scheduleAudioFile() {
        guard let audioFile = MyPlayer.instance.audioFile else { return }

        MyPlayer.instance.player.scheduleFile(audioFile, at: nil, completionCallbackType: .dataPlayedBack, completionHandler: {_ in
            print("*** audio length: \(MyPlayer.instance.audioLengthSamples)  current: \(MyPlayer.instance.currentFrame)")
            if Float(MyPlayer.instance.currentFrame) >= Float(MyPlayer.instance.audioLengthSamples) * 0.9 {
                self.playerDidFinish()
            }
        })
    }
    
    func setCurrentInfo() {
        guard MyPlayer.instance.fichiers.count > 0 else {
            return
        }
        
        DispatchQueue.main.async {
            let cur = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
            self.labFileTitle.text = cur.title
            self.labFileAuthor.text = cur.author
            self.imgFile.image = Helper.getImage(id: cur.id)
        }
    }
    
    func showButtonImage() {
        DispatchQueue.main.async {
            let play = UIImage(named: "player_start.png")
            let stop = UIImage(named: "player_stop.png")
            
            if MyPlayer.instance.isPlaying {
                self.btnStartStop.setImage(stop, for: .normal)
            }
            else {
                self.btnStartStop.setImage(play, for: .normal)
            }
            
            //refresh dynamic bar
            guard self.parentViewController != nil else {
                return
            }
                
            if let detailView = self.parentViewController as? ListDetailViewController {
                detailView.tableView.reloadData()
            }
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
        
        if MyPlayer.instance.isLoop == false && MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count-1 {
            showButtonImage()
            return;
        }
        
        if(MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count - 1) {
            MyPlayer.instance.currentFileIndex = 0;
        }
        else {
            MyPlayer.instance.currentFileIndex+=1
        }
        
        play()
    }
    
    func startOrStop() {
        if(MyPlayer.instance.isPlaying) {
            MyPlayer.instance.player.stop()
            showButtonImage()
        }
        else {
            play()
        }
    }
    
    func previous() {
        if MyPlayer.instance.currentFileIndex == 0 {
            MyPlayer.instance.currentFileIndex = MyPlayer.instance.fichiers.count - 1
        }
        else {
            MyPlayer.instance.currentFileIndex -= 1
        }
        
        self.play()
    }
    
    func next() {
        if MyPlayer.instance.currentFileIndex == MyPlayer.instance.fichiers.count - 1 {
            MyPlayer.instance.currentFileIndex = 0
        }
        else {
            MyPlayer.instance.currentFileIndex += 1
        }
        
        self.play()
    }
}
