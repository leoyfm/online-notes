//
//  RootViewController.m
//  OnlineNote
//
//  Created by YIFAN MA on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController

@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext;
@synthesize synccontent, notelist, filteredNotelist;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 //   [self.tableView setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Configure the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    self.title = @"NOTES";
    
    self.notelist= [[NSMutableArray alloc] init];
    
    // create a filtered list that will contain products for the search results table.
	self.filteredNotelist = [NSMutableArray arrayWithCapacity:[self.notelist count]];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    self.notelist = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    if (notelist == nil) {
        NSLog(@"Erorr:no object fetched");
        exit(-1);
    }
    self.synccontent = [[SyncController alloc] init];
    
    [self getSynccontent];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark Table view data source methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 //   return [[self.fetchedResultsController sections] count];
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//    NSInteger a =[sectionInfo numberOfObjects];
//    return a;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.filteredNotelist count];
    }else{
        return [notelist count];
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NoteCell *cell = (NoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //        cell = [[[NoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[NoteCell class]]) {
                cell = (NoteCell *)oneObject;
            }
        }
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath atTableView:tableView];
    return cell;
}
// configure the cell
//fetch the item from core data and configure the cell
- (void)configureCell:(NoteCell *)cell atIndexPath:(NSIndexPath *)indexPath atTableView:(UITableView *)tableView
{
//    Notes *displayNote = (Notes *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    Notes *displayNote = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        displayNote=[filteredNotelist objectAtIndex:indexPath.row];
    }else{
        displayNote=[notelist objectAtIndex:indexPath.row];
    }

    
    //    cell.textLabel.text = [[displayNote valueForKey:@"title"] description];
    [cell setNote:displayNote];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//	
//    // Configure the cell to show the book's title
//	Note *note = [fetchedResultsController objectAtIndexPath:indexPath];
//    //	cell.textLabel.text = book.title;
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
//        Notes *deleteNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
        Notes *deleteNote = [notelist objectAtIndex:indexPath.row];

        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:deleteNote];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        [notelist removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        //to-do delete note from server
        [self.synccontent syncDelete:deleteNote];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            // Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        }
        
        
    }   
}

#pragma mark -
#pragma mark Selection and moving

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Create and push a detail view controller.
    
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    //    NSManagedObject *item = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //    Tags *selectedTags= (Tags *)[item valueForKey:@"has"];
    //    Notes *selectedNote = (Notes *)item;
//    Notes *selectedNote = (Notes *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    Notes *selectedNote = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        selectedNote = [self.filteredNotelist objectAtIndex:indexPath.row];
    }
	else
	{
        selectedNote = [notelist objectAtIndex:indexPath.row];
    }

    
    
    //    NSMutableSet *selectedTags = [selectedNote mutableSetValueForKey:@"has"];
    
    // Pass the selected book to the new view controller.
    detailViewController.note = selectedNote;
    detailViewController.delegate = self;
    //    detailViewController.storedtag = [[selectedTags objectEnumerator] nextObject];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
    
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredNotelist removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Notes *note in notelist)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
        BOOL result = [predicate evaluateWithObject:note.title];
        result =[predicate evaluateWithObject:note.text];
        if (result) {
            [self.filteredNotelist addObject:note];
        }
	}
}

#pragma mark -
#pragma mark sync
- (void)getSynccontent{
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [[[self fetchedResultsController] fetchRequest] entity];
    [request setEntity:entity];
    NSString *value = @"1";
    NSPredicate *changed = [NSPredicate predicateWithFormat:@"changed == %@",value];
    
    [request setPredicate:changed];
	NSError *error = nil;

    NSArray *changedcontent=[self.managedObjectContext executeFetchRequest:request error:&error];

    for (Notes *note in changedcontent) {
        NSLog(@"%@",note.objectID);
    }
    [self.synccontent syncNotes:changedcontent];
    
  //  NSLog(@"%@", a.title);

    [value release];
}

#pragma mark -
#pragma mark Adding a Book
- (IBAction)addNote {
	
        [self addNewViewController];
}
/**
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)addNewViewController{
    
    NewNoteController *addViewController = [[NewNoteController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    addViewController.note = (Notes *)[NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController  pushViewController:addViewController animated:YES];
	
	[addViewController release];
    
    
}
- (void)addViewController:(NewNoteController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		/*
		 The new book is associated with the add controller's managed object context.
		 This is good because it means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad -- but it does make it more difficult to get the new book registered with the fetched results controller.
		 First, you have to save the new book.  This means it will be added to the persistent store.  Then you can retrieve a corresponding managed object into the application delegate's context.  Normally you might do this using a fetch or using objectWithID: -- for example
		 
		 NSManagedObjectID *newBookID = [controller.book objectID];
		 NSManagedObject *newBook = [applicationContext objectWithID:newBookID];
		 
		 These techniques, though, won't update the fetch results controller, which only observes change notifications in its context.
		 You don't want to tell the fetch result controller to perform its fetch again because this is an expensive operation.
		 You can, though, update the main context using mergeChangesFromContextDidSaveNotification: which will emit change notifications that the fetch results controller will observe.
		 To do this:
		 1	Register as an observer of the add controller's change notifications
		 2	Perform the save
		 3	In the notification method (addControllerContextDidSave:), merge the changes
		 4	Unregister as an observer
		 */
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	}
    
    //update notelist
    Notes *savednote=(Notes *)[[addingManagedObjectContext registeredObjects] anyObject];
    [notelist insertObject:savednote atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
     
                          withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	// Release the adding managed object context.
	self.addingManagedObjectContext = nil;
    
	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}

/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
}

#pragma mark -
#pragma mark Fetched results controller
/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cdate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    // Memory management.
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
 //   [NSFetchedResultsController deleteCacheWithName:@"Root"];
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate
/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [notelist insertObject:[[self.fetchedResultsController fetchedObjects] objectAtIndex:newIndexPath.row] atIndex:newIndexPath.row];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath atTableView:tableView];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Memory management
- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.fetchedResultsController = nil;
    self.notelist =nil;
}

- (void)dealloc
{
    [notelist release];
    [fetchedResultsController release];
	[managedObjectContext release];
	[addingManagedObjectContext release];
    [super dealloc];
}


@end
