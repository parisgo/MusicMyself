//
//  FichierDB.h
//  MusicMyself
//
//  Created by XYU on 05/12/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FichierDB : NSObject

+(void)add:(NSString*)name;
+(void)delete:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
