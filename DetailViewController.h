//
//  DetailViewController.h
//  OnlineNote
//
//  Created by YIFAN MA on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
@protocol AddNewViewControllerDelegate;

@class Notes;
@class Tags;
@interface DetailViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    id <AddNewViewControllerDelegate> delegate;

    Notes *note;
    NSDateFormatter *dateFormatter;
    NSUndoManager *undoManager;
    UITextView *textview;
    UITextField *tags;
    NSManagedObjectContext *managedObjectContext;	    
    BOOL keyboardIsShow;
}
@property (nonatomic, assign) BOOL keyboardIsShow;
@property (nonatomic, retain) Notes *note;   
@property (nonatomic, assign) id <AddNewViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain)NSDateFormatter *dateFormatter;
@property (nonatomic, retain)NSUndoManager *undoManager;
@property (nonatomic, retain) IBOutlet UITextView *textview;
@property (nonatomic, retain) IBOutlet UITextField *tags;
- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;
- (IBAction)save:(id)sender;
- (void)save;
- (NSDate *)getCurrentDate;
- (IBAction)addNote;

@end
@protocol AddNewViewControllerDelegate
- (void)addNewViewController;
@end
