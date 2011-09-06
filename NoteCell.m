//
//  NoteCell.m
//  OnlineNote
//
//  Created by YIFAN MA on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell
@synthesize titleLabel,dateLabel,detailLabel,note;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setNote:(Notes *)newNote
{
    // A date formatter for the time stamp.
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
    }
    
    //config the cell content for display
    note = newNote;
    self.detailLabel.text = newNote.text;
    self.titleLabel.text = newNote.title;
    self.dateLabel.text = [dateFormatter stringFromDate:[newNote cdate]];    
  	
}

-(void)dealloc{

    [titleLabel release];
    [dateLabel release];
    [detailLabel release];
    [note   release];
    [super dealloc];

}
@end
