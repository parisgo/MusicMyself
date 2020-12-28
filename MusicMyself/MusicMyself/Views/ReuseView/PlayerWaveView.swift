//
//  PlayerWaveView.swift
//  MusicMyself
//
//  Created by XYU on 15/12/2020.
//

import Foundation
import UIKit
import AVFoundation

class PlayerWaveView: UIView {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var countUpLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!  
    
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var rateEffect = AVAudioUnitTimePitch()
    var audioFormat: AVAudioFormat?
    
    var updater: CADisplayLink?
    var needsFileScheduled = true
    
    var currentPosition: AVAudioFramePosition = 0
    var seekFrame: AVAudioFramePosition = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    var audioSampleRate: Float = 0
    var audioLengthSeconds: Float = 0
    
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
    
    ///init ---------
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView() {
        super.layoutSubviews()
        
        setupAudio()
        
        updater = CADisplayLink(target: self, selector: #selector(updateUI))
        updater?.add(to: .current, forMode: .common)
        //updater?.isPaused = true
    }
    
    override func layoutSubviews() {
        scheduleAudioFile()
        player.play()
    }
    
    func setupAudio() {
      let currentFile = MyPlayer.instance.fichiers[MyPlayer.instance.currentFileIndex]
      let filePath = Helper.checkFile(name: currentFile.name)
      guard filePath != nil else {
          return;
      }
        
      audioFileURL = URL(fileURLWithPath: filePath!)

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
    
    @objc func updateUI() {
      currentPosition = currentFrame + seekFrame
      currentPosition = max(currentPosition, 0)
      currentPosition = min(currentPosition, audioLengthSamples)
        
        print("currentPosition: \(currentPosition)")

      //progressBar.progress = Float(currentPosition) / Float(audioLengthSamples)
      //let time = Float(currentPosition) / audioSampleRate
      //countUpLabel.text = formatted(time: time)
      //countDownLabel.text = formatted(time: audioLengthSeconds - time)

      if currentPosition >= audioLengthSamples {
        player.stop()
        updater?.isPaused = true
        //playPauseButton.isSelected = false
        disconnectVolumeTap()
      }
    }
    
    func disconnectVolumeTap() {
      engine.mainMixerNode.removeTap(onBus: 0)
      //volumeMeterHeight.constant = 0
    }
    
    func scheduleAudioFile() {
      guard let audioFile = audioFile else { return }

      seekFrame = 0
      player.scheduleFile(audioFile, at: nil) { [weak self] in
        self?.needsFileScheduled = true
      }
    }
    
    func formatted(time: Float) -> String {
      var secs = Int(ceil(time))
      var hours = 0
      var mins = 0

      if secs > TimeConstant.secsPerHour {
        hours = secs / TimeConstant.secsPerHour
        secs -= hours * TimeConstant.secsPerHour
      }

      if secs > TimeConstant.secsPerMin {
        mins = secs / TimeConstant.secsPerMin
        secs -= mins * TimeConstant.secsPerMin
      }

      var formattedString = ""
      if hours > 0 {
        formattedString = "\(String(format: "%02d", hours)):"
      }
      formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
      return formattedString
    }
}
