import UIKit

class BDD: NSObject {
    var database:FMDatabase?
    let dbName = "musicMyselfDB.sqlite"
    var dbPath: String!
    
    static let instance = BDD()
    
    override init(){
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        dbPath = documentsDirectory.appending("/\(dbName)")
        
        database = FMDatabase(path:dbPath)
    }
}
