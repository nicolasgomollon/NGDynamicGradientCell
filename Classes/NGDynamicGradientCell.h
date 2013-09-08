//
//  NGDynamicGradientCell.h
//  NGDynamicGradientCell
//
//  Created by Nicolas Gomollon on 8/31/13.
//  Copyright (c) 2013 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBubbleEdgeInset 10.0f
#define kMessagePadding   9.0f

@interface NGDynamicGradientCell : UITableViewCell {
	UIImageView *grayView;
	UILabel *messageLabel;
	
	UIImage *maskFill;
	UIImage *bubbleImage;
	UIImage *bubbleMaskImage;
	UIEdgeInsets bubbleEdgeInsetsSent;
	UIEdgeInsets bubbleEdgeInsetsReceived;
	
	BOOL sent;
}

@property (nonatomic, assign, getter=isSent) BOOL sent;

+ (CGFloat)heightForMessage:(NSString *)message;

@end
