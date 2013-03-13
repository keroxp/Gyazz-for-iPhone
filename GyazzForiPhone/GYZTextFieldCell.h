//
//  FANTextFieldCell.h
//  fan
//
//  Created by 桜井 雄介 on 12/05/17.
//  Copyright (c) 2012年 LoiLo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYZTextFieldCell : UITableViewCell

@property (nonatomic,readonly, strong) UITextField *textField;
@property (nonatomic,assign)   CGFloat      textFieldMinX;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
