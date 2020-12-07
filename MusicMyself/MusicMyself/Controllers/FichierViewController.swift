//
//  FichierViewController.swift
//  MusicMyself
//
//  Created by XYU on 04/12/2020.
//

import UIKit

class FichierViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fichiers: [Fichier]!
    var currentInex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All files"

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:"FichierTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fichiers = Fichier().getList()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fichiers != nil) ? fichiers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FichierTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentInex = indexPath.row
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "FichierDetailViewController") {
            let tmp = controller as! FichierDetailViewController
            tmp.fichier = fichiers[currentInex]
            
            tmp.callback = {
                self.fichiers = Fichier().getList()
                self.tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(tmp, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "go2FichierDetail" {
                let tmp = segue.destination as! FichierDetailViewController
                tmp.fichier = fichiers[currentInex]
                
                tmp.callback = {
                    self.fichiers = Fichier().getList()
                    self.tableView.reloadData()
                }                
            }
        }
    }
}
