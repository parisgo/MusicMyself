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
        
        NSInteger idNew = [self getId: name];
        if(idNew != 0) {
            [db executeUpdate:@"insert into AlbumFichier(AID, FID) values(1, ?)", [NSNumber numberWithInt:idNew]];
        }
        
        [db close];
    }
    else {
        NSLog(@"fail to open database");
    }
}

+(void)delete:(NSString*)name {
    [self initDb];
    
    if([db open]) {
        NSInteger idNew = [self getId: name];
        if(idNew != 0) {
            [db executeUpdate:@"delete from AlbumFichier where FID = ?", [NSNumber numberWithInt:idNew]];
        }
        
        [db executeUpdate:@"delete from Fichier where FName = ?", name];
        [db close];
    }
    else {
        NSLog(@"fail to open database");
    }
}

+(NSInteger)getId:(NSString*)name {
    NSInteger retId = 0;
    
    [self initDb];
    
    if([db open]) {
        FMResultSet *s  = [db executeQuery:@"select FID from Fichier where FName = ?", name];
        if ([s next]) {
            retId = [s intForColumnIndex:0];
        }
    }
    else {
        NSLog(@"fail to open database");
    }
    
    return retId;
}

@end
