//
//  AHBaseRequest.m
//  AHNetworkDemo
//
//  Created by Aalen on 16/8/23.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "AHBaseRequest.h"

#import "AHNetworkManager.h"

@implementation AHBaseRequest

- (void)dealloc
{
	[self clearCompleteBlock];
}

- (NSString *)requestURLString
{
	return nil;
}

- (NSString *)requestMethod
{
	return @"GET";
}

- (NSDictionary<NSString *,NSString *> *)headerFieldValueDictionary
{
	return nil;
}

- (NSData *)bodyData
{
	return nil;
}

- (NSTimeInterval)timeout
{
	return 15.0;
}

- (AHRequestConflictHandleType)conflictHandleType
{
	return AHRequestConflictHandleType_Ignore;
}

- (void)clearCompleteBlock
{
	self.successCompleteBlock = nil;
	self.failedCompleteBlock = nil;
}

- (void)start
{
	[_manager addRequest: self];
}

- (void)stop
{
	[_manager cancelRequest: self];
}

@end
