//
//  Notes.m
//  OnlineNote
//
//  Created by YIFAN MA on 30/07/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Notes.h"
#import "Tags.h"

@implementation Notes
@dynamic text;
@dynamic title;
@dynamic date;
@dynamic has;



- (void)addTag:(Tags *)value{
    NSMutableSet *TagsSet = [self mutableSetValueForKey:@"has"];
    NSEnumerator *next = [TagsSet objectEnumerator];
    Tags *tag;
    while (tag = [next nextObject]) {
        if ([tag.tagtext isEqualToString:value.tagtext])
            return;
    }
    [TagsSet addObject:value];
    [self setValue:TagsSet forKey:@"has"];
    
}


- (void)removeTagWihtString:(NSString *) value{
    NSMutableSet *TagsSet = [self mutableSetValueForKey:@"has"];
    //is value in set
    NSEnumerator *next = [TagsSet objectEnumerator];
    Tags *tag;
    while (tag = [next nextObject]) {
        if ([tag.tagtext isEqualToString:value]) {
            
            //remove tag from note has relationship
            [TagsSet removeObject:tag];
            
            //remove note from tag belongto relationship
            [tag removeBelongtoObject:self];
            return;
        }
    }
    
}

- (void)addHasObjectWithString:(NSString *)value{
    
    //get tags set
    self.has = [self mutableSetValueForKey:@"has"];

    NSArray *newTagList = [value componentsSeparatedByString:@","];
    NSArray *oldTagList = [self.getTagsWithString componentsSeparatedByString:@","];
    
    NSEnumerator *iterator = newTagList.objectEnumerator;
    NSManagedObjectContext *context= [self managedObjectContext];
    NSString *oneTag;
    
    //find new tags
    while (oneTag = [iterator nextObject]) {
        if (![oldTagList containsObject:oneTag]) {
            //add new tag to tagset
            Tags *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
            newTag.tagtext = oneTag;
            
            [self addHasObject:newTag];
            [newTag addBelongtoObject:self];
        }
    }

    //find remove tags
    iterator = oldTagList.objectEnumerator;
    while (oneTag = [iterator nextObject]) {
        if (![newTagList containsObject:oneTag]) {
            
            //remove tag from note has relationship
            [self removeTagWihtString:oneTag];
        }
    }
    
    //save note has relationship
    [self setValue:self.has forKey:@"has"];

    [context processPendingChanges];

    
//       while (oneTag = [iterator nextObject]) {
//        Tags *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
//        NSLog(@"Notes.m - oneTag:%@", oneTag);
//           [self addHasObject:newTag];
//        
//        }
        
        
//       [context processPendingChanges];
//        NSError *error;
//		if (![context save:&error]) {
//			// Update to handle the error appropriately.
//			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//			exit(-1);  // Fail
//		}

}

- (NSString *)getTagsWithString{
    NSMutableSet *TagsSet = [self mutableSetValueForKey:@"has"];

    NSEnumerator *nextObject =[TagsSet objectEnumerator];
    NSString *taglistText = [[NSString alloc] init];
    
    Tags *storedtag = [nextObject nextObject];
    NSLog(@"Notes.m - storedtag:%@", storedtag.tagtext);
    
    //handle nil tags
    if (storedtag == nil){
        return nil;
    }
    taglistText =[taglistText stringByAppendingString:storedtag.tagtext];
    while (storedtag = [nextObject nextObject]) {
        taglistText =[taglistText stringByAppendingString:@","];
        taglistText =[taglistText stringByAppendingString:storedtag.tagtext];
        
    }
    NSLog(@"Notes.m - taglistText: %@",taglistText);
    return taglistText;
}
@end
