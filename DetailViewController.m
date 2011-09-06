//
//  DetailViewController.m
//  OnlineNote
//
//  Created by YIFAN MA on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "NewNoteController.h"
#import "SyncController.h"
#import "Notes.h"
#import "Tags.h"

@implementation DetailViewController
@synthesize note, dateFormatter, undoManager, textview,tags,managedObjectContext;
@synthesize delegate, keyboardIsShow;


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


#pragma mark -
#pragma mark View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
      
    // Configure the title, title bar, and table view.
    self.title = self.note.title;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    //    self.textview.text = note.text;
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.keyboardIsShow = NO;
    
    //config display content
    textview.text = note.text;
    tags.text = note.getTagsWithString;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self save];
    self.textview = nil;
    self.title = nil;
    self.tags = nil;
    
    //remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)updateRightBarButtonItemState {
	// Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [note validateForUpdate:NULL];
}


- (IBAction)addNote {
	
    [self.navigationController popViewControllerAnimated:NO];

    [self.delegate addNewViewController];

}
#pragma mark -
#pragma mark save function
//get current date
-(NSDate *)getCurrentDate{
    CFAbsoluteTime      absTime;
    CFDateRef           aCFDate;
    
    absTime = CFAbsoluteTimeGetCurrent();
    aCFDate = CFDateCreate(kCFAllocatorDefault, absTime);
    return (NSDate *)aCFDate;

}
- (void)save{
    [self cleanUpUndoManager];
    
    //prepare note for saving
    note.udate = self.getCurrentDate;
    note.title = ([self.textview.text length] >8)?[self.textview.text substringToIndex:8]:self.textview.text;
    note.text = textview.text;
    note.changed = [[[NSNumber alloc] initWithInteger:1] autorelease];
    [note addHasObjectWithString:tags.text];
    
    // Save the changes.
    NSError *error;
    if (![note.managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    //sync note to server
    SyncController *sync = [[SyncController alloc] init];
    [sync syncNote:note];
    
        [UIView commitAnimations];
    
}

- (IBAction)save:(id)sender {
    
    //change done button to add button
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)] autorelease];
    
    //hide keyboard
     [textview resignFirstResponder];

    
}
#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    if (self.keyboardIsShow == NO) {
        self.keyboardIsShow=YES;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.textview.frame;

    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    textview.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    //restore the original frame
    //get size current textview size
//    CGRect a = textview.frame;
//    
//    //change current textview size to frame size
//    a.size = self.view.frame.size;
//    textview.frame = a;
    

    textview.frame = self.view.bounds;
    [self save];

    [UIView commitAnimations];
}
#pragma mark -
#pragma mark text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //change add button to done button
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)] autorelease];
    [self setUpUndoManager];
    
    return YES;

    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self save];
    return YES;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark -
#pragma mark text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    //change add button to done button
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)] autorelease];
    
    [self setUpUndoManager];
        
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{

    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [self save];
    return YES;
}


#pragma mark -
#pragma mark Undo support

- (void)setUpUndoManager {
	/*
	 If the managed object context doesn't already have an undo manager, then create one and set it for the context and self.
	 The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
	 */
	if (note.managedObjectContext.undoManager == nil) {
		
		NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
		[anUndoManager setLevelsOfUndo:3];
		self.undoManager = anUndoManager;
		[anUndoManager release];
		
		note.managedObjectContext.undoManager = undoManager;
	}
	
	// Register as an observer of the note's context's undo manager.
	NSUndoManager *noteUndoManager = note.managedObjectContext.undoManager;
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:noteUndoManager];
	[dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:noteUndoManager];
}


- (void)cleanUpUndoManager {
	
	// Remove self as an observer.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:nil];
	
	if (note.managedObjectContext.undoManager == undoManager) {
		note.managedObjectContext.undoManager = nil;
		self.undoManager = nil;
	}		
}


- (NSUndoManager *)undoManager {
	return note.managedObjectContext.undoManager;
}


- (void)undoManagerDidUndo:(NSNotification *)notification {
//	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
//	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


/*
 The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.
 */
- (BOOL)canBecomeFirstResponder {
	return YES;
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [undoManager release];
    [dateFormatter release];
    [note release];
    [self.tags release];
    [self.textview release];
    [super dealloc];
}


@end
