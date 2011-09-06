//
//  NoteCell.h
//  NoteOL
//
//  Created by YIFAN MA on 27/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes.h"
@interface NoteCell : UITableViewCell
{
    Notes *note;
    UILabel *noteTextLabel;
    UILabel *noteTitleLabel;
}
@property (nonatomic,retain)UILabel *noteTextLabel;
@property (nonatomic, retain)UILabel *noteTitleLabel;

-(Notes *)note;
-(void)setNote:(Notes *)newNote;
@end
