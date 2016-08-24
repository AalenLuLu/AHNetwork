//
//  AHNetworkManager.m
//  AHNetworkDemo
//
//  Created by Aalen on 16/8/22.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "AHNetworkManager.h"
#import "AHBaseRequest.h"
#import <AFNetworking.h>

@interface AHNetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;

@property (copy, nonatomic) NSURL *baseURL;

@property (strong, nonatomic) NSLock *lock;
@property (strong, nonatomic) NSMutableDictionary *requestList;

@end

@implementation AHNetworkManager

+ (instancetype)shareInstance
{
	static AHNetworkManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init
{
	return [self initWithBaseURL: nil sessionConfiguration: nil];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
	if(self = [super init])
	{
		_baseURL = baseURL;
		_manager = [[AFHTTPSessionManager alloc] initWithBaseURL: baseURL sessionConfiguration: sessionConfiguration];
		_requestSerializer = _manager.requestSerializer;
		_responseSerializer = [AFHTTPResponseSerializer serializer];
		_manager.responseSerializer = _responseSerializer;
		
		_lock = [[NSLock alloc] init];
		_requestList = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)addRequest:(AHBaseRequest *)request
{
	//URL...METHOD...
	NSURL *fullURL = [NSURL URLWithString: [request requestURLString] ? : @"" relativeToURL: _baseURL];
	NSMutableURLRequest *urlRequest = [_requestSerializer requestWithMethod: [request requestMethod] URLString: [fullURL absoluteString] parameters: nil error: nil];
	//HEADER
	NSDictionary *headerFieldValue = [request headerFieldValueDictionary];
	NSArray *headers = headerFieldValue.allKeys;
	[headers enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSString *header = obj;
		[urlRequest setValue: headerFieldValue[header] forHTTPHeaderField: header];
	}];
	//BODY
	[urlRequest setHTTPBody: [request bodyData]];
	//timeout
	urlRequest.timeoutInterval = [request timeout];
	
	//task
	__block NSURLSessionDataTask *task = [_manager dataTaskWithRequest: urlRequest completionHandler: ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		NSString *key = [[NSString alloc] initWithFormat: @"%lu", urlRequest.hash];
		if(error)
		{
			if(request.failedCompleteBlock)
			{
				request.failedCompleteBlock(task, error);
			}
		}
		else if(request.successCompleteBlock)
		{
			request.successCompleteBlock(task, responseObject);
		}
		[request clearCompleteBlock];
		
		[_lock lock];
		_requestList[key] = nil;
		[_lock unlock];
	}];
	request.dataTask = task;
	
	//make sure one request
	NSString *key = [[NSString alloc] initWithFormat: @"%lu", urlRequest.hash];
	[_lock lock];
	if(nil == _requestList[key])
	{
		_requestList[key] = request;
		[request start];
	}
	else if(AHRequestConflictHandleType_CancelBefore == request.conflictHandleType)
	{
		AHBaseRequest *oldRequest = _requestList[key];
		[oldRequest stop];
		
		_requestList[key] = request;
		[request start];
	}
	else
	{
		[request stop];
	}
	[_lock unlock];
}

- (void)cancelRequest:(AHBaseRequest *)request
{
	[request stop];
	NSString *key = [[NSString alloc] initWithFormat: @"%lu", request.dataTask.originalRequest.hash];
	[_lock lock];
	_requestList[key] = nil;
	[_lock unlock];
}

@end
