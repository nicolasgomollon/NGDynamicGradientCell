//
//  NGDynamicGradientCell.h
//  NGDynamicGradientCell
//
//  Created by Nicolas Gomollon on 8/31/13.
//  Copyright (c) 2013 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGDynamicGradientCell : UITableViewCell {
	SSGradientView *gradientView;
	UIImageView *grayView;
	UILabel *messageLabel;
	
	UIImage *bubbleImage;
	UIEdgeInsets bubbleEdgeInsetsSent;
	UIEdgeInsets bubbleEdgeInsetsReceived;
	
	BOOL sent;
}

@property (nonatomic, assign, getter=isSent) BOOL sent;

+ (CGFloat)heightForMessage:(NSString *)message;
- (void)setScrollViewContentOffset:(CGPoint)contentOffset;

@end
