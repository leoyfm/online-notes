//
//  NoteCell.h
//  OnlineNote
//
//  Created by YIFAN MA on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes.h"
@interface NoteCell : UITableViewCell{
    UILabel *titleLabel;
    UILabel *dateLabel;
    UILabel *detailLabel;
    Notes  *note;
}
@property(nonatomic, retain)IBOutlet UILabel *titleLabel;
@property(nonatomic, retain)IBOutlet UILabel *dateLabel;
//@property(nonatomic, retain)IBOutlet UITextView *detailLabel;
@property(nonatomic, retain)IBOutlet UILabel *detailLabel;

@property(nonatomic, retain)Notes *note;

-(void)setNote:(Notes *)newNote;

@end
