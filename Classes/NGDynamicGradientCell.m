//
//  NGDynamicGradientCell.m
//  NGDynamicGradientCell
//
//  Created by Nicolas Gomollon on 8/31/13.
//  Copyright (c) 2013 Techno-Magic. All rights reserved.
//

#import "NGDynamicGradientCell.h"

@implementation NGDynamicGradientCell

@synthesize sent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization code
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		[self setBackgroundColor:[UIColor whiteColor]];
		
		maskFill = [UIImage imageNamed:@"mask-fill.png"];
		maskFill = [maskFill resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
		
		bubbleImage = [UIImage imageNamed:@"bubble-min.png"];
		bubbleMaskImage = [UIImage imageNamed:@"mask-bubble-min.png"];
		bubbleEdgeInsetsSent = UIEdgeInsetsMake(17.0f, 20.0f, 17.0f, 26.0f);
		bubbleEdgeInsetsReceived = UIEdgeInsetsMake(17.0f, 26.0f, 17.0f, 20.0f);
		
		bubbleMaskImage = [bubbleMaskImage resizableImageWithCapInsets:bubbleEdgeInsetsSent];
		
		grayView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[grayView setBackgroundColor:[UIColor clearColor]];
		[grayView setTintColor:RGBA(229.0f, 229.0f, 234.0f, 1.0f)];
		[grayView setAlpha:0.0f];
		[self.contentView addSubview:grayView];
		
		messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[messageLabel setBackgroundColor:[UIColor clearColor]];
		[messageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
		[messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[messageLabel setNumberOfLines:0];
		[self.contentView addSubview:messageLabel];
	}
	return self;
}

+ (CGFloat)heightForMessage:(NSString *)message {
	UIFont *messageFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	CGSize messageConstraints = CGSizeMake(190.0f, MAXFLOAT);
	
	CGSize messageSize = [message boundingRectWithSize:messageConstraints
											   options:NSStringDrawingUsesLineFragmentOrigin
											attributes:@{NSFontAttributeName : messageFont}
											   context:nil].size;
	
	CGFloat messageHeight = MAX(35.0f, 10.0f + roundf(messageSize.height) + 5.0f);
	
	return messageHeight + kMessagePadding;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale);
	
	[image drawInRect:CGRectSetSize(CGRectZero, newSize)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	[messageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
	[messageLabel setTextColor:self.sent?[UIColor whiteColor]:[UIColor blackColor]];
	
	CGSize messageConstraints = CGSizeMake(190.0f, MAXFLOAT);
	CGSize messageSize = [messageLabel.text boundingRectWithSize:messageConstraints
														 options:NSStringDrawingUsesLineFragmentOrigin
													  attributes:@{NSFontAttributeName : messageLabel.font}
														 context:nil].size;
	
	CGFloat originX = 18.0f + kBubbleEdgeInset;
	if (self.sent)
		originX = self.bounds.size.width - messageSize.width - originX;
	
	[messageLabel setFrame:CGRectMake(originX, 7.0f, messageSize.width, messageSize.height)];
	
	CGFloat messageWidth = MAX(48.0f, 13.0f + roundf(messageSize.width) + 18.0f);
	CGFloat messageHeight = MAX(35.0f, 10.0f + roundf(messageSize.height) + 5.0f);
	
	if (self.sent) {
		UIImage *maskImage = [self imageWithImage:bubbleMaskImage scaledToSize:CGSizeMake(messageWidth, messageHeight)];
		
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
		
		// Draw the bubble mask image.
		[maskImage drawInRect:CGRectMake(self.bounds.size.width - messageWidth - kBubbleEdgeInset, 0.0f, messageWidth, messageHeight)];
		
		// Draw the message label text (since it'll be masked out).
		[messageLabel.text drawInRect:messageLabel.frame
					   withAttributes:@{NSFontAttributeName : messageLabel.font,
										NSForegroundColorAttributeName : messageLabel.textColor}];
		
		// Draw the mask fill image to the left of the bubble mask image.
		[maskFill drawInRect:CGRectMake(0.0f, 0.0f, self.bounds.size.width - messageWidth - kBubbleEdgeInset, self.bounds.size.height)];
		
		// Draw the mask fill image to the right of the bubble mask image.
		[maskFill drawInRect:CGRectMake(self.bounds.size.width - kBubbleEdgeInset, 0.0f, kBubbleEdgeInset, self.bounds.size.height)];
		
		// Draw the mask fill image in the remaining space below the bubble mask image.
		[maskFill drawInRect:CGRectMake(0.0f, messageHeight, self.bounds.size.width, self.bounds.size.height - messageHeight)];
		
		// Get everything we drew as an image that we can use to mask the cell with.
		UIImage *imageMask = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		CALayer *maskLayer = [CALayer layer];
		
		[maskLayer setContents:(id)imageMask.CGImage];
		[maskLayer setFrame:self.bounds];
		
		[self.layer setMask:maskLayer];
	} else {
		[grayView setFrame:CGRectMake(kBubbleEdgeInset, 0.0f, messageWidth, messageHeight)];
		
		UIImage *maskImage = bubbleImage;
		maskImage = [UIImage imageWithCGImage:maskImage.CGImage scale:maskImage.scale orientation:UIImageOrientationUpMirrored];
		maskImage = [maskImage resizableImageWithCapInsets:bubbleEdgeInsetsReceived];
		maskImage = [self imageWithImage:maskImage scaledToSize:CGSizeMake(messageWidth, messageHeight)];
		maskImage = [maskImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		[grayView setImage:maskImage];
	}
	
	[messageLabel setAlpha:!self.sent];
	[grayView setAlpha:!self.sent];
}

- (UILabel *)textLabel {
	return messageLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

@end
