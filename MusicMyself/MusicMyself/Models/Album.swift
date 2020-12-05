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
}
