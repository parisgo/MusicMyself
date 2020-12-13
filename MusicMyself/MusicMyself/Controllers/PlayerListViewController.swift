//
//  PlayerListViewController.swift
//  MusicMyself
//
//  Created by XYU on 13/12/2020.
//

import UIKit
import MobileCoreServices

class PlayerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var callback : (() -> Void)?
    
    var fichiers: [Fichier] = []
    var albumId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName:"FichierTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.reloadTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?()
    }
    
    func reloadTableView() {
        albumId = MyPlayer.instance.currentAlbumId
        fichiers = Fichier().getListByAlbum(aId: albumId)
        MyPlayer.instance.fichiers = fichiers
        
        guard fichiers.count > 0 else {
            return
        }
        
        tableView.reloadData()
    }
}

extension PlayerListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fichiers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FichierTableViewCell
        cell?.fichier = fichiers[indexPath.row]
        
        if(indexPath.row % 2 == 0) {
            cell?.backgroundColor = .systemGray6
        }
        else {
            cell?.backgroundColor = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        MyPlayer.instance.fichiers = fichiers
        MyPlayer.instance.currentFileIndex = indexPath!.row
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
//            if indexPath.row == MyPlayer.instance.currentFileIndex {
//                self.playerView.next()
//            }
//
//            Album().deleteFileFromAlbum(albumId: self.album.id, fileId: self.fichiers[indexPath.row].id)
            self.fichiers.remove(at: indexPath.row)
            
            tableView.reloadData()
            
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfig
    }
}

extension PlayerListViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let counter = fichiers[indexPath.row]
        let itemProvider = NSItemProvider(object: counter)
        let dragItem = UIDragItem(itemProvider: itemProvider)

        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = fichiers.remove(at: sourceIndexPath.row)
        fichiers.insert(mover, at: destinationIndexPath.row)
        
        Fichier().updateOrder(aId: albumId, fichers: fichiers)
        
        self.reloadTableView()
    }
    
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//
//        print("did update")
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("drop")
        
//        let insertionIndex: IndexPath
//        if let indexPath = coordinator.destinationIndexPath {
//          insertionIndex = indexPath
//        } else {
//          let section = tableView.numberOfSections - 1
//            let row = tableView.numberOfRows(inSection: section)
//            insertionIndex = IndexPath(row: row, section: section)
//        }
//
//        for item in coordinator.items {
//        guard let sourceIndexPathRow = item.sourceIndexPath?.row else { continue }
//        item.dragItem.itemProvider.loadObject(ofClass: Fichier.self) { (object, error) in
//              DispatchQueue.main.async {
//                if let counter = object as? Fichier {
//                  self.fichiers.remove(at: sourceIndexPathRow)
//                    self.fichiers.insert(counter, at: insertionIndex.row)
//                    tableView.reloadData()
//                } else {
//                  return
//                }
//              }
//            }
//        }
    }
}
