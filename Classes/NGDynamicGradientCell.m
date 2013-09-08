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
		
		bubbleImage = [UIImage imageNamed:@"bubble-min.png"];
		bubbleEdgeInsetsSent = UIEdgeInsetsMake(17.0f, 20.0f, 17.0f, 26.0f);
		bubbleEdgeInsetsReceived = UIEdgeInsetsMake(17.0f, 26.0f, 17.0f, 20.0f);
		
		gradientView = [[SSGradientView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		[gradientView setColors:@[RGBA(90.0f, 200.0f, 250.0f, 1.0f), RGBA(0.0f, 122.0f, 255.0f, 1.0f)]];
		[gradientView setAlpha:0.0f];
		[self.contentView addSubview:gradientView];
		
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
	
	return messageHeight + 9.0f;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale);
	
	[image drawInRect:CGRectSetSize(CGRectZero, newSize)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (void)setScrollViewContentOffset:(CGPoint)contentOffset {
	CGFloat messageWidth = MAX(48.0f, 13.0f + roundf(messageLabel.frame.size.width) + 18.0f);
	CGFloat messageHeight = MAX(35.0f, 10.0f + roundf(messageLabel.frame.size.height) + 5.0f);
	CGSize messageSize = CGSizeMake(messageWidth, messageHeight);
	
	UIImage *maskImage = bubbleImage;
	CALayer *maskLayer = [CALayer layer];
	
	if (self.sent) {
		[gradientView setFrame:CGRectMake(gradientView.frame.origin.x, roundf(contentOffset.y) - self.frame.origin.y, gradientView.frame.size.width, gradientView.frame.size.height)];
		
		maskImage = [maskImage resizableImageWithCapInsets:bubbleEdgeInsetsSent];
		maskImage = [self imageWithImage:maskImage scaledToSize:messageSize];
		
		[maskLayer setContents:(id)maskImage.CGImage];
		[maskLayer setFrame:CGRectMake(self.bounds.size.width - messageSize.width - 10.0f, self.frame.origin.y - roundf(contentOffset.y), messageSize.width, messageSize.height)];
		
		[gradientView.layer setMask:maskLayer];
	} else {
		[grayView setFrame:CGRectMake(10.0f, 0.0f, messageWidth, messageHeight)];
		
		maskImage = [UIImage imageWithCGImage:maskImage.CGImage scale:maskImage.scale orientation:UIImageOrientationUpMirrored];
		maskImage = [maskImage resizableImageWithCapInsets:bubbleEdgeInsetsReceived];
		maskImage = [self imageWithImage:maskImage scaledToSize:messageSize];
		maskImage = [maskImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		[grayView setImage:maskImage];
	}
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
	
	CGFloat originX = 28.0f;
	if (self.sent)
		originX = self.bounds.size.width - messageSize.width - originX;
	
	[messageLabel setFrame:CGRectMake(originX, 7.0f, messageSize.width, messageSize.height)];
	
	[self setScrollViewContentOffset:CGPointZero];
	
	[gradientView setAlpha:self.sent];
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
