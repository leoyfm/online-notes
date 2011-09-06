//
//  DownloadController.h
//  OnlineNote
//
//  Created by YIFAN MA on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "Notes.h"
#import "ASIFormDataRequest.h"
@protocol SyncNoteDelegate

@end


@interface SyncController : NSObject <SyncNoteDelegate>{
        NSMutableDictionary *notelist;
}
@property (nonatomic, retain) NSMutableDictionary *notelist;
- (void)syncDelete:(Notes *)note;
- (void)syncNote:(Notes *) note;
- (void)syncNotes:(NSArray *) notes;

@end

