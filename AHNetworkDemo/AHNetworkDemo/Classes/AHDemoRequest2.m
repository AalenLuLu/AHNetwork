//
//  AHDemoRequest2.m
//  AHNetworkDemo
//
//  Created by Aalen on 16/8/24.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "AHDemoRequest2.h"

NSString * const kAHDemoRequestFinishedNotification = @"com.aalen.network.demo.request2.finished.notification";

@implementation AHDemoRequest2

- (instancetype)init
{
	if(self = [super init])
	{
		self.successCompleteBlock = ^(NSURLSessionDataTask *task, id responseObject) {
			NSLog(@"task: %@", task);
			NSLog(@"response: %@", task.response);
			[[NSNotificationCenter defaultCenter] postNotificationName: kAHDemoRequestFinishedNotification object: nil];
		};
		self.failedCompleteBlock = ^(NSURLSessionDataTask *task, NSError *error) {
			NSLog(@"task: %@", task);
			NSLog(@"error: %@", error);
			[[NSNotificationCenter defaultCenter] postNotificationName: kAHDemoRequestFinishedNotification object: nil];
		};
	}
	return self;
}

- (NSString *)requestURLString
{
	return @"https://www.google.com.hk";
}

@end
