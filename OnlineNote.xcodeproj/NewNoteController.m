//
//  NewNoteController.m
//  OnlineNote
//
//  Created by YIFAN MA on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewNoteController.h"
#import "Notes.h"
#import "Tags.h"

@implementation NewNoteController


#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Override the DetailViewController viewDidLoad with different navigation bar items and title.
    self.title = @"";
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)] autorelease];
    //set new note state
    
    // Set up the undo manager and set editing state to YES.
    [self setUpUndoManager];
    self.editing = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	[self cleanUpUndoManager];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    
    //get new note created date
    note.cdate= self.getCurrentDate;
    
    //save note
    [super save:sender];
    [self dismissModalViewControllerAnimated:YES];
}


@end
