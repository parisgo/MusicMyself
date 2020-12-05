//
//  ListViewController.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums: [Album]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName:"ListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cellList")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        albums = Album().getList()
        collectionView.reloadData()
        
        var files = Fichier().getListByAlbum(aId: 1);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellList", for: indexPath) as! ListCollectionViewCell
        cell.album = albums[indexPath.row]
        cell.listTitle.text = cell.album.title
        
        return cell
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 2000.0, height: 2000.0)
    }
     */
}

extension ListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Hi", message: "\(albums[indexPath.row])", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
