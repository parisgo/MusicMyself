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
    var title: String?
    var author: String?
    var fIdFirst: Int!
    
    override init() {
    }
    
    init(id:Int, title:String) {
        self.id = id
        self.title = title
    }
    
    init(title:String) {
        self.title = title
    }
    
    func getList() -> [Album]! {
        var result = [Album]()
        let sql = """
            select Album.AID, Album.ATitle, Album.Author, ifnull(FileMin.FId,0) as FIdFirst
            from Album
            left join (select AID, min(FID) as FId from AlbumFichier group by AID) As FileMin
            on Album.AId = FileMin.AID
        """
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                var tmp : Album
                let results = try db.executeQuery(sql, values: nil)
                while results.next() {
                    tmp = Album()
                    tmp.id = Int(results.int(forColumn: "AID"))
                    tmp.title = results.string(forColumn: "ATitle") ?? ""
                    tmp.author = results.string(forColumn: "Author") ?? ""
                    tmp.fIdFirst = Int(results.int(forColumn: "FIdFirst"))
                    
                    result.append(tmp)
                }
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func add(album: Album, fileIds: [Int]) {
        let sqlAlbum = "insert into Album(ATitle, Author) values(?, ?)"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                var albumId = 0
                if let aId = album.id {
                    albumId = aId
                }
                else {
                    _ = try db.executeUpdate(sqlAlbum, values: [album.title!, album.author])
                    albumId = Int(db.lastInsertRowId)
                }
                
                guard albumId != 0 else {
                    return
                }
                for i in fileIds {
                    try db.executeUpdate("insert into AlbumFichier(AID, FID) values(?,?)", values: [albumId, i])
                }
                
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func delete(id: Int) {
        let sqlDelAlbumFile = "delete from AlbumFichier where AID = (?)"
        let sqlDelAlbm = "delete from Album where AID = (?)"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                _ = try db.executeUpdate(sqlDelAlbumFile, values: [id])
                _ = try db.executeUpdate(sqlDelAlbm, values: [id])
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteFileFromAlbum(albumId: Int, fileId: Int) {
        let sql = "delete from AlbumFichier where AID = (?) and FID = (?)"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                _ = try db.executeUpdate(sql, values: [albumId, fileId])
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func isExist(title: String) -> Bool {
        var ret = false;
        let sql = "select * from Album where ATitle = (?)"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                let results = try db.executeQuery(sql, values: [title])
                if results.next() {
                    ret = true
                }
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return ret
    }
}
