//
//  MasterViewController.h
//  NGDynamicGradientCell
//
//  Created by Nicolas Gomollon on 8/31/13.
//  Copyright (c) 2013 Techno-Magic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGDynamicGradientCell.h"

extern NSString *const NGMessageContentKey;
extern NSString *const NGMessageSentKey;

@interface MasterViewController : UITableViewController {
	NSMutableArray *objects;
}

@property (nonatomic, strong) NSMutableArray *objects;

@end
