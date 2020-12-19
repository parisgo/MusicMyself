//
//  Fichier.swift
//  MusicMyself
//
//  Created by XYU on 04/12/2020.
//

import Foundation
import MobileCoreServices

class Fichier: NSObject, Codable
{
    var id: Int!
    var title: String!
    var name: String!
    var author: String!
    var info: String!
    
    //from table AlbumFichier
    var ordre: Int!
    
    override init() {
    }
    
    init(id:Int, title:String, name:String) {
        self.id = id
        self.title = title
        self.name = name
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Fichier else { return false }
        return self.id == other.id
    }
    
    func get(id: Int) -> Fichier? {
        var fichier: Fichier?

        let sql = "select fid, fname, ftitle, fid as ordre, fAuthor, FInfo from Fichier where FID = \(id)"
        let list = getListFromSql(sql: sql, needInfo: true)        
        if list!.count > 0 {
            fichier = list![0]
        }
        
        return fichier
    }
    
    func getList() -> [Fichier]! {
        let sql = "select fid, fname, ftitle, fid as ordre, fAuthor from Fichier"
        
        return getListFromSql(sql: sql, needInfo: false)
    }
    
    func getListByAlbum(aId: Int) -> [Fichier]! {
        let sql = "select Fichier.fid, fname, ftitle, AlbumFichier.FOrder as ordre, FAuthor from Fichier inner join AlbumFichier on Fichier.FID = AlbumFichier.FID where AlbumFichier.AId = \(aId) order by AlbumFichier.FOrder"
        
        return getListFromSql(sql: sql, needInfo: false)
    }
    
    func getListFromSql(sql: String, needInfo: Bool) -> [Fichier]! {
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
                    tmp.author = results.string(forColumn: "FAuthor") ?? ""
                    tmp.ordre = Int(results.int(forColumn: "ordre"))
                    
                    if needInfo {
                        tmp.info = results.string(forColumn: "FInfo") ?? ""
                    }
                    
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
    
    func updateOrder(aId: Int, fichers: [Fichier]) {
        let db = BDD.instance.database!
        do {
            if db.open() {
                for (index, obj) in fichers.enumerated() {
                    try db.executeUpdate("update AlbumFichier set FOrder = (?) where AID = (?) and FID = (?)", values: [index, aId, obj.id])
                }
                
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func update(fichier: Fichier) {
        let sql = "update Fichier set FTitle = (?), FAuthor = (?), FInfo = (?) where FId = (?)"
        
        let db = BDD.instance.database!
        do {
            if db.open() {
                _ = try db.executeUpdate(sql, values: [fichier.title, fichier.author, fichier.info, fichier.id])
                db.close()
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
}

extension Fichier: NSItemProviderWriting, NSItemProviderReading{
    static var writableTypeIdentifiersForItemProvider: [String]{
        return [(kUTTypeUTF8PlainText) as String]
      }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let jsonEncoder = JSONEncoder()
        let progress = Progress(totalUnitCount: 100)
            do {
              //Here the object is encoded to a JSON data object and sent to the completion handler
              let data = try jsonEncoder.encode(self)
                progress.completedUnitCount = 100
                completionHandler(data, nil)
            } catch {
              completionHandler(nil, error)
            }
        
          return progress
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeUTF8PlainText) as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        do {
          //Here we decode the object back to it's class representation and return it
          let counter = try decoder.decode(Fichier.self, from: data)
            return counter as! Self
        } catch {
            throw error
        }
    }
}
