//
//  FichierViewController.swift
//  MusicMyself
//
//  Created by XYU on 04/12/2020.
//

import UIKit

class FichierViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fichiers: [Fichier]!
    var currentInex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All files"

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName:"FichierTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fichiers = Fichier().getList()
        tableView.reloadData()
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

extension FichierViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fichiers != nil) ? fichiers.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FichierTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        if(indexPath.row % 2 == 0) {
            cell?.backgroundColor = .none
        }
        else {
            cell?.backgroundColor = .systemGray6
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}
