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


- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)loadView {
	self.tableView = [[UITableView alloc] init];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NGDynamicGradientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	NSDictionary *object = self.objects[indexPath.row];
	cell.textLabel.text = object[NGMessageContentKey];
	
	return cell;
}

@end
