//
//  ListDetailViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit
import AVFoundation

class ListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var btnStartStop: UIButton!
    
    @IBOutlet weak var labFileTitle: UILabel!
    @IBOutlet weak var labFileAuthor: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    
    var album: Album!
    var fichiers: [Fichier]!
    
    var audioPlayer:AVAudioPlayer! = nil
    var currentFileIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:"ListEveryFileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        labFileTitle.text = "No file"
        labFileAuthor.text = ""
        
        if let tmp = album {
            listTitle.text = tmp.title
            fichiers = Fichier().getListByAlbum(aId: tmp.id);
            
            guard fichiers != nil && fichiers.count > 0 else {
                return
            }
            
            tableView.reloadData()
            
            let firstFile = fichiers[0]
            let imagePath = Helper.checkImage(id: firstFile.id)
            if(imagePath == nil) {
                self.listImage.image = UIImage(named: "bg_heart.png")
            }
            else {
                self.listImage.image = UIImage.init(contentsOfFile: imagePath!)
            }
            
            //set info File
            labFileTitle.text = firstFile.title
            labFileAuthor.text = firstFile.author
            setFileImage(id: firstFile.id)
        }
        
        showButtonImage(isStart: true)
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnStartOrStop(_ sender: Any) {
        if(audioPlayer != nil && audioPlayer.isPlaying) {
            audioPlayer.stop()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fichiers != nil) ? fichiers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListEveryFileTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentFileIndex = indexPath.row;
        play()
    }
    
    func play(){
        setPlayDameon();
        
        let currentFile = fichiers[currentFileIndex]
        let filePath = Helper.checkFile(name: currentFile.name)
        guard filePath != nil else {
            return;
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath!))
        audioPlayer.delegate = self;
        audioPlayer.play()
        
        labFileTitle.text = currentFile.title
        labFileAuthor.text = currentFile.author
        setFileImage(id: currentFile.id)
        
        showButtonImage(isStart: false)
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

extension ListDetailViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        if(currentFileIndex == fichiers.count - 1) {
            currentFileIndex = 0;
        }
        else {
            currentFileIndex+=1
        }
        
        play()
    }
}
