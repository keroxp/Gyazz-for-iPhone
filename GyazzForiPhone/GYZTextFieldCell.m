//
//  FANTextFieldCell.m
//  fan
//
//  Created by 桜井 雄介 on 12/05/17.
//  Copyright (c) 2012年 LoiLo Inc. All rights reserved.
//

#import "GYZTextFieldCell.h"

static const CGFloat kDefaultTextFieldLeft = 115;
static const CGFloat kCellHorizontalEdgeMargin = 10;
static const CGFloat kLabelAndTextFieldSpacing = 5;

@implementation GYZTextFieldCell

@synthesize textField = _textField;
@synthesize textFieldMinX = _textFieldMinX;


- (void)myInit
{
    _textFieldMinX = kDefaultTextFieldLeft;
	
	_textField = [[UITextField alloc] initWithFrame:CGRectZero];
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.contentView addSubview:_textField];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

// 通常のinitializeを無効に

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSException *exception = [NSException exceptionWithName:@"exception"
													 reason:@"not supported"
												   userInfo:nil];
	@throw exception;
	
	return nil;
}

- (void)awakeFromNib
{
    [self myInit];
}

// 代わりにこちらを用いる

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if(self) {
		[self myInit];
	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	
	if(CGRectIsEmpty(self.textLabel.frame)) {
		CGRect textFieldFrame;
		textFieldFrame.origin.x = kCellHorizontalEdgeMargin;
		textFieldFrame.origin.y = 0;
		textFieldFrame.size.width = CGRectGetWidth(self.contentView.bounds) - kCellHorizontalEdgeMargin * 2;
		textFieldFrame.size.height = CGRectGetHeight(self.contentView.bounds);
		_textField.frame = textFieldFrame;
	} else {
		CGRect textFieldFrame;
		textFieldFrame.origin.x = _textFieldMinX;
		textFieldFrame.origin.y = 0;
		textFieldFrame.size.width = CGRectGetWidth(self.contentView.bounds) - _textFieldMinX - kCellHorizontalEdgeMargin;
		textFieldFrame.size.height = CGRectGetHeight(self.contentView.bounds);
		_textField.frame = textFieldFrame;
		
		CGRect labelFrame = self.textLabel.frame;
		labelFrame.size.width = _textFieldMinX - CGRectGetMinX(self.textLabel.frame) - kLabelAndTextFieldSpacing;
		self.textLabel.frame = labelFrame;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextFieldMinX:(CGFloat)newTextFieldMinX
{
    _textFieldMinX = newTextFieldMinX;
    [self setNeedsLayout];
}

@end
