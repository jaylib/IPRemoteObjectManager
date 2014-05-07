//
//  IPRemoteImage.m
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPRemoteImage.h"
#import <ReactiveCocoa.h>

@interface IPRemoteImage ()
@end

@implementation IPRemoteImage

- (void)setResponseObject:(id)object {
    [super setResponseObject:object];
    self.image = object;
}

- (AFHTTPRequestOperation *)requestOperationWithRequest:(NSMutableURLRequest *)request {
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [[AFImageResponseSerializer alloc] init];
    return requestOperation;
}

@end
