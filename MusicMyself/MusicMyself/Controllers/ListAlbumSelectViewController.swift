//
//  ListAlbumSelectViewController.swift
//  MusicMyself
//
//  Created by XYU on 08/12/2020.
//

import UIKit

class ListAlbumSelectViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var fichiers: [Fichier]!
    var fichierSelect: Set<Fichier> = []
    
    var callback : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    
        let nib = UINib(nibName:"ListAlbumSelectTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        fichiers = Fichier().getList()
        guard fichiers != nil && fichiers.count > 0 else {
            return
        }
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        callback?()
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ListAlbumSelectViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fichiers != nil) ? fichiers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListAlbumSelectTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        if let swithChange = cell?.contentView.viewWithTag(2) as? UISwitch {
            swithChange.addTarget(self, action: #selector(switchFile(_ :)), for: .touchUpInside)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func switchFile(_ sender: UISwitch) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        let currentFile = fichiers[indexPath!.row]
        
        if sender.isOn {
            fichierSelect.insert(currentFile)
        }
        else {
            if let indexDelete = fichierSelect.firstIndex(of: currentFile) {
                fichierSelect.remove(at: indexDelete)
            }
        }
    }
}
