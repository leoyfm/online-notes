//
//  Notes.h
//  OnlineNote
//
//  Created by YIFAN MA on 10/08/11.
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
@property (nonatomic, retain) NSDate * cdate;
@property (nonatomic, retain) NSNumber * refnote;
@property (nonatomic, retain) NSNumber * changed;
@property (nonatomic, retain) NSDate * udate;
@property (nonatomic, retain) NSSet *has;
@end

@interface Notes (CoreDataGeneratedAccessors)

- (void)addHasObject:(Tags *)value;
- (void)removeHasObject:(Tags *)value;
- (void)addHas:(NSSet *)values;
- (void)removeHas:(NSSet *)values;

- (void)removeTagWihtString:(NSString *) value;
- (void)addTag:(Tags *)value;
- (void)addHasObjectWithString:(NSString *)value;
- (NSString *)getTagsWithString;

@end
