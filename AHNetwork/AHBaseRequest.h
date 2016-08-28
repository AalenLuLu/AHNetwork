//
//  AHBaseRequest.h
//  AHNetworkDemo
//
//  Created by Aalen on 16/8/23.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AHRequestConflictHandleType) {
	AHRequestConflictHandleType_Ignore = 0,
	AHRequestConflictHandleType_CancelBefore
};

typedef void (^RequestSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^RequestFailedBlock)(NSURLSessionDataTask *task, NSError *error);

@class AHNetworkManager;

@interface AHBaseRequest : NSObject

@property (weak, nonatomic) AHNetworkManager *manager;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (copy, nonatomic) RequestSuccessBlock successCompleteBlock;
@property (copy, nonatomic) RequestFailedBlock failedCompleteBlock;

- (NSString *)requestURLString;
- (NSString *)requestMethod;
- (NSDictionary<NSString *, NSString *> *)headerFieldValueDictionary;
- (NSData *)bodyData;
- (NSTimeInterval)timeout;
- (AHRequestConflictHandleType)conflictHandleType;

- (void)clearCompleteBlock;

- (void)start;
- (void)stop;

@end
