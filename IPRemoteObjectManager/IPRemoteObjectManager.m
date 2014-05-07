//
//  IPDownloadManager.m
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPRemoteObjectManager.h"
#import "IPRemoteImage.h"
#import "IPRemoteJSON.h"

@implementation IPRemoteObjectManager

- (void)getRemoteObjects:(NSArray *)remoteObjects complete:(void (^)(NSArray *remoteImages))complete error:(void (^)(NSError *error))errorBlock {

    NSMutableArray *signals = [NSMutableArray array];
    
    [remoteObjects enumerateObjectsUsingBlock:^(IPRemoteObject *remoteObject, NSUInteger idx, BOOL *stop) {
        
        RACSignal *signal = [self racSingalForRemoteObject:remoteObject];
        [signals addObject:signal];
    
    }];
//    
    [[RACSignal merge:signals] subscribeNext:^(IPRemoteImage *x) {
        x.completionBlock(x);
    } error:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    } completed:^{
        if (complete) complete(remoteObjects);
    }];
    
}

- (RACSignal *)racSingalForRemoteObjectCollection:(IPRemoteObjectCollection *)remoteObjectCollection {

    NSArray *remoteObjects = [remoteObjectCollection subObjects];

    NSArray *remoteObjectSingals = [[[remoteObjects rac_sequence] map:^id(id value) {
        return [self racSingalForRemoteObject:value];
    }] array];
    
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        
        RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
        
        [[RACSignal merge:remoteObjectSingals] subscribeNext:^(IPRemoteImage *x) {
            
            x.completionBlock(x);
            
        } completed:^{
            
            [subject sendNext:remoteObjectCollection];
            [subject sendCompleted];
            
        }];
        
        [subject subscribe:subscriber];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}

- (RACSignal *)racSingalForRemoteObject:(IPRemoteObject *)remoteObject {
    if ([remoteObject isKindOfClass:[IPRemoteObjectCollection class]]) {
        return [self racSingalForRemoteObjectCollection:(IPRemoteObjectCollection *)remoteObject];
    } else {
        return [self racSignalForSingleRemoteObject:remoteObject];
    }
}

- (RACSignal *)racSignalForSingleRemoteObject:(IPRemoteObject *)remoteObject {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        
        RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
        
        AFHTTPRequestOperation *operation = [self operationForRemoteObject:remoteObject];
        
        [subject setNameWithFormat:@"-rac_start: %@", operation.request.URL];
        
        [(AFHTTPRequestOperation*)operation setCompletionBlockWithSuccess:^(id operation, id responseObject) {
            
            remoteObject.responseObject = responseObject;
            
            [subject sendNext:remoteObject];
            [subject sendCompleted];
            
        } failure:^(id operation, NSError *error) {
            [subject sendError:error];
        }];
        
        [self.operationQueue addOperation:operation];
		
        [subject subscribe:subscriber];
		
        return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

#pragma mark - AFHTTPRequestOperations

- (AFHTTPRequestOperation *)operationForRemoteObject:(IPRemoteObject *)remoteObject {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:remoteObject.path parameters:nil];
    return [remoteObject requestOperationWithRequest:request];
}

#pragma mark - NSMutableURLRequests

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:nil error:nil];
    return request;
}

@end
