//
//  Area+CoreDataProperties.h
//  LJCoreData
//
//  Created by LiJie on 16/6/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Area.h"

NS_ASSUME_NONNULL_BEGIN

@interface Area (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *province;

@end

NS_ASSUME_NONNULL_END
