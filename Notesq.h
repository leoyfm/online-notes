//
//  Notes.h
//  OnlineNote
//
//  Created by YIFAN MA on 30/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tags;

@interface Notes : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *has;
@end

@interface Notes (CoreDataGeneratedAccessors)

- (void)addHasObject:(Tags *)value;
- (void)removeTagObject:(Tags *)value;
- (void)addHas:(NSSet *)values;
- (void)removeHas:(NSSet *)values;
- (void)removeTag:(Tags *)value;

@end
