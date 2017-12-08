//
//  LJCoreDataManager.h
//  LJCoreData
//
//  Created by LiJie on 16/6/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area+CoreDataProperties.h"

@interface LJCoreDataManager : NSObject

+(instancetype)shareCoreDataManager;

-(void)saveModelWithName:(NSString*)name;


-(void)deleteModelWithName:(NSString*)name;

-(id)fetchModelWithName:(NSString*)name;

-(void)updateModelWithName:(NSString*)name;








@end
