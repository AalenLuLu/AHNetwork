//
//  AHNetworkManager.h
//  AHNetworkDemo
//
//  Created by Aalen on 16/8/22.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AHBaseRequest;

@interface AHNetworkManager : NSObject

+ (instancetype)shareInstance;
- (instancetype)initWithBaseURL: (NSURL *)baseURL sessionConfiguration: (NSURLSessionConfiguration *)sessionConfiguration;

- (void)addRequest: (AHBaseRequest *)request;

- (void)cancelRequest: (AHBaseRequest *)request;

@end
