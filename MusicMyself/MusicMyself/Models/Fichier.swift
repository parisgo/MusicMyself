//
//  Fichier.swift
//  MusicMyself
//
//  Created by XYU on 04/12/2020.
//

import Foundation

class Fichier: NSObject
{
    var id: Int!
    var title: String!
    var name: String!
    var author: String!
    
    override init() {
    }
    
    init(id:Int, title:String, name:String) {
        self.id = id
        self.title = title
        self.name = name
    }
    
    func getList() -> [Fichier]! {
        let sql = "select * from Fichier"
        
        return getListFromSql(sql: sql)
    }
    
    func getListByAlbum(aId: Int) -> [Fichier]! {
        let sql = "select Fichier.fid, fname,ftitle from Fichier inner join AlbumFichier on Fichier.FID = AlbumFichier.FID where AlbumFichier.AId = \(aId)"
        
        return getListFromSql(sql: sql)
    }
    
    func getListFromSql(sql: String) -> [Fichier]! {
        var result = [Fichier]()
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                var tmp : Fichier
                let results = try db.executeQuery(sql, values: nil)
                while results.next() {
                    tmp = Fichier()
                    tmp.id = Int(results.int(forColumn: "FID"))
                    tmp.title = results.string(forColumn: "FTitle") ?? ""
                    tmp.name = results.string(forColumn: "FName") ?? ""
                    
                    result.append(tmp)
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return result
    }
}
