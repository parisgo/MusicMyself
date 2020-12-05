//
//  FichierDB.m
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

#import "FichierDB.h"
#import "FMDB.h"
#import "FichierVO.h"

@implementation FichierDB

FMDatabase *db;

+(void)initDb {
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"musicMyselfDB.sqlite"];
    db = [FMDatabase databaseWithPath:dbPath];
}

+(void)add:(NSString*)name {
    NSString *nameNoExt = [name stringByDeletingPathExtension];
    
    [self initDb];
    
    if([db open]) {
        [db executeUpdate:@"insert into Fichier(FName, FTitle) values(?, ?)",name, nameNoExt];
        [db close];
    }
    else {
        NSLog(@"fail to open database");
    }
}

+(void)delete:(NSString*)name {
    [self initDb];
    
    if([db open]) {
        [db executeUpdate:@"delete from Fichier where FName = ?", name];
        [db close];
    }
    else {
        NSLog(@"fail to open database");
    }
}

@end
