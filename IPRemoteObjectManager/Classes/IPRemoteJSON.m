//
//  IPRemoteJSON.m
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPRemoteJSON.h"

@implementation IPRemoteJSON

- (void)setResponseObject:(id)object {
    [super setResponseObject:object];
    self.responseData = object;
}

- (AFHTTPRequestOperation *)requestOperationWithRequest:(NSMutableURLRequest *)request {
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    return requestOperation;
}

@end
