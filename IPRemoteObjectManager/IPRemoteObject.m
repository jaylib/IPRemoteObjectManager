//
//  IPRemoteObject.m
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPRemoteObject.h"

@implementation IPRemoteObject

- (instancetype)initWithPath:(NSString *)path completion:(RemoteObjectCompletionBlock)completion {
    self = [super init];
    if (self) {
        self.completionBlock = completion;
        self.path = path;
    }
    return self;
}

- (NSArray *)subObjects {
    return @[self];
}

- (AFHTTPRequestOperation *)requestOperationWithRequest:(NSURLRequest *)request {
    return [[AFHTTPRequestOperation alloc] initWithRequest:request];
}

@end
