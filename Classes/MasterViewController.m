//
//  MasterViewController.m
//  NGDynamicGradientCell
//
//  Created by Nicolas Gomollon on 8/31/13.
//  Copyright (c) 2013 Techno-Magic. All rights reserved.
//

#import "MasterViewController.h"

NSString *const NGMessageContentKey = @"content";
NSString *const NGMessageSentKey = @"sent";

@implementation MasterViewController

@synthesize objects;


- (void)loadView {
	[super loadView];
	
	[self setTitle:@"NGDynamicGradientCell"];
	self.tableView = [[UITableView alloc] init];
	
	// This is the gradient that will be shown behind the sent message bubbles.
	SSGradientView *gradientView = [[SSGradientView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[gradientView setColors:@[RGBA(90.0f, 200.0f, 250.0f, 1.0f), RGBA(0.0f, 122.0f, 255.0f, 1.0f)]];
	[self.tableView setBackgroundView:gradientView];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	
	// We need white header and footer views for our table view to cover the gradient in the background.
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[tableHeaderView setBackgroundColor:[UIColor whiteColor]];
	[self.tableView setTableHeaderView:tableHeaderView];
	
	UIView *tableFooterView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[tableFooterView setBackgroundColor:[UIColor whiteColor]];
	[self.tableView setTableFooterView:tableFooterView];
	
	[self.tableView setContentInset:UIEdgeInsetsMake(kMessagePadding - tableHeaderView.bounds.size.height, 0.0f, -tableFooterView.bounds.size.height, 0.0f)];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView registerClass:[NGDynamicGradientCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view.
	self.objects = [[NSMutableArray alloc] init];
	
	[self.objects addObject:@{NGMessageContentKey: @"This is just a message.", NGMessageSentKey: @YES}];
	[self.objects addObject:@{NGMessageContentKey: @"Test", NGMessageSentKey: @NO}];
	[self.objects addObject:@{NGMessageContentKey: @"Lorem ipsum dolor sit amet.", NGMessageSentKey: @YES}];
	[self.objects addObject:@{NGMessageContentKey: @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ut malesuada ante. Ut eros dui malesuada non velit sed, porttitor accumsan nibh. Maecenas ac fringilla nisi, non tincidunt turpis. Suspendisse posuere tempus sem in cursus massa volutpat sit amet.", NGMessageSentKey: @YES}];
	[self.objects addObject:@{NGMessageContentKey: @"This is an example of a received message.", NGMessageSentKey: @NO}];
	[self.objects addObject:@{NGMessageContentKey: @"This is another sent message.", NGMessageSentKey: @YES}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInterface) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)updateInterface {
	// Redraw cells and recalculate their heights to account for change in system-wide dynamic type size.
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.objects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *object = self.objects[indexPath.row];
	NSString *messageText = object[NGMessageContentKey];
	
	return [NGDynamicGradientCell heightForMessage:messageText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NGDynamicGradientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	NSDictionary *object = self.objects[indexPath.row];
	NSString *messageText = object[NGMessageContentKey];
	BOOL messageSent = [object[NGMessageSentKey] boolValue];
	
	[cell.textLabel setText:messageText];
	[cell setSent:messageSent];
	
	[cell setNeedsDisplay];
	
	return cell;
}

@end
