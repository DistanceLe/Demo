//
//  User+CoreDataProperties.h
//  LJCoreData
//
//  Created by LiJie on 16/6/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *sex;
@property (nullable, nonatomic, retain) Department *myUser;

@end

NS_ASSUME_NONNULL_END
