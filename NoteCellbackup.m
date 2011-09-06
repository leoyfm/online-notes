//
//  NoteCell.m
//  NoteOL
//
//  Created by YIFAN MA on 27/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteCell.h"

@interface NoteCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:
(UIColor *)selectedColor cgRect:(CGRect)cgRect fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end

@implementation NoteCell

@synthesize noteTextLabel,noteTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        UIView *myContentView = self.contentView;
        
		
        CGRect titleRect= CGRectMake(0, 2, 70, 15);
        CGRect textRect=CGRectMake(0, 26, 200, 30);
        self.noteTitleLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] 
                                               selectedColor:[UIColor whiteColor] cgRect:titleRect fontSize:14.0 bold:YES]; 
		self.noteTitleLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.noteTitleLabel];
		[self.noteTitleLabel release];
        
        self.noteTextLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] 
												  selectedColor:[UIColor whiteColor] cgRect:textRect fontSize:10.0 bold:YES];
		self.noteTextLabel.textAlignment = UITextAlignmentRight;
		[myContentView addSubview:self.noteTextLabel];
		[self.noteTextLabel release];
        
        // Position the todoPriorityImageView above all of the other views so
        // it's not obscured. It's a transparent image, so any views
        // that overlap it will still be visible.
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)layoutSubviews {
//    
//#define LEFT_COLUMN_OFFSET 1
//#define LEFT_COLUMN_WIDTH 50
//	
//#define RIGHT_COLUMN_OFFSET 75
//#define RIGHT_COLUMN_WIDTH 240
//	
//#define UPPER_ROW_TOP 4
//    
//    [super layoutSubviews];
//    CGRect contentRect = self.contentView.bounds;
//	
//    if (!self.editing) {
//		
//        CGFloat boundsX = contentRect.origin.x;
//		CGRect frame;
//        
//        // Place the Text label.
//		frame = CGRectMake(boundsX +RIGHT_COLUMN_OFFSET  , UPPER_ROW_TOP, RIGHT_COLUMN_WIDTH, 13);
//		frame.origin.y = 15;
//		self.todoTextLabel.frame = frame;
//        
//        // Place the priority image.
//        UIImageView *imageView = self.todoPriorityImageView;
//        frame = [imageView frame];
//		frame.origin.x = boundsX + LEFT_COLUMN_OFFSET;
//		frame.origin.y = 10;
// 		imageView.frame = frame;
//        
//        // Place the priority label.
//        CGSize prioritySize = [self.todoPriorityLabel.text sizeWithFont:self.todoPriorityLabel.font 
//                                                               forWidth:RIGHT_COLUMN_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
//        CGFloat priorityX = frame.origin.x + imageView.frame.size.width + 8.0;
//        frame = CGRectMake(priorityX, UPPER_ROW_TOP, prioritySize.width, prioritySize.height);
//		frame.origin.y = 15;
//        self.todoPriorityLabel.frame = frame;
//    }
//}

- (Notes *)note
{
    return self.note;
}
//recieve note object from rootviewcontroll and set note information
// to cell
- (void)setNote:(Notes *)newNote
{
    
    note = newNote;
    NSLog(@"NoteCell-- note.text:%@--note.title:%@",newNote.text, newNote.title);
    self.noteTextLabel.text = newNote.text;
    self.noteTitleLabel.text = newNote.title;
    NSLog(@"NoteCell-- note.text:%@--note.title:%@",self.noteTextLabel.text, self.noteTitleLabel.text);

//    self.todoPriorityImageView.image = [self imageForPriority:newTodo.priority];
//    
//	switch(newTodo.priority) {
//		case 2:
//			self.todoPriorityLabel.text = @"Medium";
//			break;
//		case 3:
//			self.todoPriorityLabel.text = @"Low";
//			break;
//		default:
//			self.todoPriorityLabel.text = @"High";
//			break;
//	}
	
    [self setNeedsDisplay];
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
						selectedColor:(UIColor *)selectedColor cgRect:(CGRect)cgRect fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
    
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
	UILabel *newLabel = [[UILabel alloc] initWithFrame:cgRect];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}
- (void)dealloc {
	[super dealloc];
}

@end
