//
//  Department+CoreDataProperties.h
//  LJCoreData
//
//  Created by LiJie on 16/6/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Department.h"

NS_ASSUME_NONNULL_BEGIN

@interface Department (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *code;

@end

NS_ASSUME_NONNULL_END
