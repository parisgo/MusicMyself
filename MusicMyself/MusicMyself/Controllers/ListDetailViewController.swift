//
//  ListDetailViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class ListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listTitle: UILabel!
    
    var album: Album!
    var fichiers: [Fichier]!
    
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
        if let tmp = album {
            listTitle.text = tmp.title
//            fichierAuthor.text = tmp.author
//
//            let imagePath = Helper.checkImage(id: fichier.id!)
//            if(imagePath == nil) {
//                self.fichierImg.image = UIImage(named: "bg_heart.png")
//            }
//            else {
//                self.fichierImg.image = UIImage.init(contentsOfFile: imagePath!)
//            }
            
            fichiers = Fichier().getListByAlbum(aId: tmp.id);
            tableView.reloadData()
        }
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        //currentInex = indexPath.row        
    }
}
