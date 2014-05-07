//
//  IPRemoteObject.h
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface IPRemoteObject : NSObject

typedef void (^RemoteObjectCompletionBlock)(IPRemoteObject *remoteObject);

@property (nonatomic, copy) RemoteObjectCompletionBlock completionBlock;

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) NSDictionary *userInfo;

- (instancetype)initWithPath:(NSString *)path completion:(RemoteObjectCompletionBlock)completion;

- (AFHTTPRequestOperation *)requestOperationWithRequest:(NSURLRequest *)request;

- (NSArray *)subObjects;

@end
