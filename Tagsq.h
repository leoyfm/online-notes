//
//  Tags.h
//  OnlineNote
//
//  Created by YIFAN MA on 30/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notes;

@interface Tags : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * tagtext;
@property (nonatomic, retain) NSSet *belongto;
@end

@interface Tags (CoreDataGeneratedAccessors)

- (void)removeNote:(Notes *)value;
- (void)addNote:(Notes *)value;
- (void)addBelongtoObject:(Notes *)value;
- (void)removeBelongtoObject:(Notes *)value;
- (void)addBelongto:(NSSet *)values;
- (void)removeBelongto:(NSSet *)values;
@end
