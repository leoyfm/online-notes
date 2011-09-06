//
//  Tags.m
//  OnlineNote
//
//  Created by YIFAN MA on 10/08/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tags.h"
#import "Notes.h"


@implementation Tags
@dynamic tagtext;
@dynamic reftag;
@dynamic changed;
@dynamic belongto;

- (void)addNote:(Notes *)value{
    NSMutableSet *belongtoS = [self mutableSetValueForKey:@"belongto"];
    [belongtoS addObject:value];
    [self setValue:belongtoS forKey:@"belongto"];
    
}
- (void)removeNote:(Notes *)value{
    NSMutableSet *belongtoS = [self mutableSetValueForKey:@"belongto"];
    [belongtoS removeObject:value];
    [self removeBelongto:belongtoS];
    
}


@end
