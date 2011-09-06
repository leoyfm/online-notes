//
//  RootViewController.h
//  OnlineNote
//
//  Created by YIFAN MA on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "NewNoteController.h"
#import "SyncController.h"
#import "NoteCell.h"
#import "Notes.h"
#import "Tags.h"
@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, AddNewViewControllerDelegate> {
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;	    
    NSManagedObjectContext *addingManagedObjectContext;
    SyncController *synccontent;
    NSMutableArray *notelist;
    NSMutableArray *filteredNotelist;
    
}
@property (nonatomic, retain) NSMutableArray *filteredNotelist;
@property (nonatomic, retain)NSMutableArray *notelist;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) SyncController *synccontent;


- (IBAction)addNote;
- (void)getSynccontent;
- (void)configureCell:(NoteCell *)cell atIndexPath:(NSIndexPath *)indexPath atTableView:(UITableView *)tableView;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
@end
