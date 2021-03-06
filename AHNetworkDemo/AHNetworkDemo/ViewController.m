//
//  ViewController.m
//  AHNetworkDemo
//
//  Created by Aalen on 16/8/22.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "ViewController.h"

#import "AHNetworkManager.h"
#import "AHDemoRequest.h"
#import "AHDemoRequest2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	AHDemoRequest *request = [[AHDemoRequest alloc] init];
	request.successCompleteBlock = ^(NSURLSessionDataTask *task, id responseObject) {
		NSLog(@"task: %@", task);
		NSLog(@"response: %@", task.response);
		NSLog(@"responseObject: %@", [[NSString alloc] initWithData: responseObject encoding: NSUTF8StringEncoding]);
	};
	request.failedCompleteBlock = ^(NSURLSessionDataTask *task, NSError *error) {
		NSLog(@"task: %@", task);
		NSLog(@"error: %@", error);
	};
	request.manager = [AHNetworkManager shareInstance];
	[request start];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onRequest2Finished:) name: kAHDemoRequestFinishedNotification object: nil];
	
	AHDemoRequest2 *request2 = [[AHDemoRequest2 alloc] init];
	request2.manager = [AHNetworkManager shareInstance];
	[request2 start];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)onRequest2Finished: (NSNotification *)notification
{
	NSLog(@"%@", notification);
}

@end
