//
//  LJCoreDataManager.m
//  LJCoreData
//
//  Created by LiJie on 16/6/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "LJCoreDataManager.h"
#import "AppDelegate.h"
@interface LJCoreDataManager ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation LJCoreDataManager

+(instancetype)shareCoreDataManager{
    static dispatch_once_t onceToken;
    static LJCoreDataManager* shareManager;
    dispatch_once(&onceToken, ^{
        shareManager=[[LJCoreDataManager alloc]init];
        shareManager.appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    });
    return shareManager;
}

-(void)saveModelWithName:(NSString *)name{
    
    NSEntityDescription* description=[NSEntityDescription entityForName:@"Area" inManagedObjectContext:self.appDelegate.managedObjectContext];
    Area* myArea=[[Area alloc]initWithEntity:description insertIntoManagedObjectContext:self.appDelegate.managedObjectContext];
    
    myArea.city=@"深圳";
    myArea.province=@"广东省";
    
    NSString* documetsPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"...%@", documetsPath);
    [self.appDelegate saveContext];
    
}

-(id)fetchModelWithName:(NSString *)name
{
    NSFetchRequest* fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"Area" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"city = '%@'",name];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"city" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    NSError* error=nil;
    id fetObject=[self.appDelegate.managedObjectContext executeRequest:fetchRequest error:&error];
    if (error || !fetchRequest) {
        NSLog(@"....%@  没找到",error.description);
    }
    return fetObject;
}

-(void)deleteModelWithName:(NSString *)name{
    NSMutableArray* array=[NSMutableArray arrayWithArray:[self fetchModelWithName:name]];
    if (array.count>0) {
        for (Area* myArea in array) {
            [self.appDelegate.managedObjectContext deleteObject:myArea];
        }
    }
}

-(void)updateModelWithName:(NSString *)name{
    
}














@end
