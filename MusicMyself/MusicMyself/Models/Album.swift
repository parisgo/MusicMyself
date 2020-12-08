//
//  Album.swift
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

import Foundation

class Album: NSObject
{
    var id: Int!
    var title: String!
    
    override init() {
    }
    
    init(id:Int, title:String) {
        self.id = id
        self.title = title
    }
    
    func getList() -> [Album]! {
        var result = [Album]()
        let sql = "select * from Album"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                var tmp : Album
                let results = try db.executeQuery(sql, values: nil)
                while results.next() {
                    tmp = Album()
                    tmp.id = Int(results.int(forColumn: "AID"))
                    tmp.title = results.string(forColumn: "ATitle") ?? ""
                    
                    result.append(tmp)
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func add(album: Album, fileIds: [Int])  {
        let sqlAlbum = "insert into Album(ATitle) value(\(album.title!))"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                _ = try db.executeUpdate(sqlAlbum, values: nil)
                let albumId = db.lastInsertRowId
                
                guard albumId != 0 else {
                    return
                }
                for i in fileIds {
                    try db.executeUpdate("insert into AlbumFichier(AID, FID) values(?,?)", values: [albumId, i])
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
