//
//  DownloadController.m
//  OnlineNote
//
//  Created by YIFAN MA on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SyncController.h"

@implementation SyncController
@synthesize notelist;

- (id)init
{
    self = [super init];
    if (self) {
        notelist= [[NSMutableDictionary alloc] init];        
    }
    
    return self;
}


-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString*responseString =[request responseString];
    NSLog(@"response:%@", responseString);
    NSDictionary*responseDict =[responseString JSONValue];
    NSString *clinet_id =[responseDict objectForKey:@"client_id"];
    NSString *server_id =[responseDict objectForKey:@"server_id"];
    NSLog(@"server:%@, client:%@",server_id, clinet_id);
    
       
    if (clinet_id && server_id) {
        Notes *note = [notelist objectForKey:[[NSURL alloc] initWithString:clinet_id]];
        note.changed=0;
        note.refnote=[NSNumber numberWithInteger:[server_id integerValue]];
        // Save the changes.
        NSError *error;
        if (![note.managedObjectContext save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }

        
    }
     
}
-(void)syncDelete:(Notes *)note{
    NSURL *url = [NSURL URLWithString:@"http://www.mayifan.net/notes/on-deleteNote.php"];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    //set post data
    [request setPostValue:note.refnote forKey:@"server_id"];
        
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)syncNote:(Notes *) note{
    [notelist setObject:note forKey:[[note objectID] URIRepresentation]];

    NSURL *url = [NSURL URLWithString:@"http://www.mayifan.net/notes/on-insertNote.php"];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    //set post data
    [request setPostValue:[[note objectID] URIRepresentation]  forKey:@"client_id"];
    [request setPostValue:note.refnote forKey:@"server_id"];
    [request setPostValue:note.title forKey:@"title"];
    [request setPostValue:note.text forKey:@"text"];
    [request setPostValue:note.getTagsWithString forKey:@"tag"];
    [request setPostValue:note.cdate.description forKey:@"cdate"];
    [request setPostValue:note.udate.description forKey:@"udate"];
    [request setPostValue:note.refnote forKey:@"refnote_client"];
    [request setPostValue:note.changed forKey:@"changed"];

    [request setDelegate:self];
    [request startAsynchronous];
    
 
    
}
- (void)syncNotes:(NSArray *) notes{
    for (Notes *note in notes) {

        [notelist setObject:note forKey:[[note objectID] URIRepresentation]];
        [self syncNote:note];
     }
}

- (void)dealloc {
    [notelist release];
    [super dealloc];
}


@end
