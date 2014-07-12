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

@interface IPRemoteObjectManager ()
@property (nonatomic, strong) RACDisposable * signal;
@end

@implementation IPRemoteObjectManager

- (void) getRemoteObjects:(NSArray *)remoteObjects complete:(void (^)(NSArray * remoteImages))complete error:(void (^)(NSError * error))errorBlock
{
    
    if ([remoteObjects count] == 0)
    {
        complete(nil);
        return;
    }
    
    
    NSMutableArray * signals = [NSMutableArray array];
    
    [remoteObjects enumerateObjectsUsingBlock:^(IPRemoteObject * remoteObject, NSUInteger idx, BOOL * stop) {
        RACSignal * signal = [self racSingalForRemoteObject:remoteObject];
        [signals addObject:signal];
    }];
    //
    
    self.signal = [[RACSignal merge:signals] subscribeNext:^(IPRemoteImage * x) {
        if (x.completionBlock)
        {
            x.completionBlock(x);
        }
    } error:^(NSError * error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorBlock)
            {
                errorBlock(error);
            }
        });
    } completed:^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete)
            {
                complete(remoteObjects);
            }
        });
    }];
    
    
}

- (void) cancel
{
    [self.signal dispose];
}

- (RACSignal *) racSingalForRemoteObjectCollection:(IPRemoteObjectCollection *)remoteObjectCollection
{
    
    NSArray * remoteObjects = [remoteObjectCollection subObjects];
    
    NSArray * remoteObjectSingals = [[[remoteObjects rac_sequence] map:^id (id value) {
        return [self racSingalForRemoteObject:value];
    }] array];
    
    return [RACSignal createSignal:^(id < RACSubscriber > subscriber) {
        
        RACReplaySubject * subject = [RACReplaySubject replaySubjectWithCapacity:1];
        
        [[RACSignal merge:remoteObjectSingals] subscribeNext:^(IPRemoteImage * x) {
            if (x.completionBlock)
            {
                x.completionBlock(x);
            }
        } error:^(NSError * error) {
            
            // [subject sendError:error];
            
            [subject sendNext:remoteObjectCollection];
            [subject sendCompleted];
            
        } completed:^{
            
            [subject sendNext:remoteObjectCollection];
            [subject sendCompleted];
            
        }];
        
        [subject subscribe:subscriber];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}

- (RACSignal *) racSingalForRemoteObject:(IPRemoteObject *)remoteObject
{
    if ([remoteObject isKindOfClass:[IPRemoteObjectCollection class]])
    {
        return [self racSingalForRemoteObjectCollection:(IPRemoteObjectCollection *) remoteObject];
    }
    else
    {
        return [self racSignalForSingleRemoteObject:remoteObject];
    }
}

- (RACSignal *) racSignalForSingleRemoteObject:(IPRemoteObject *)remoteObject
{
    return [RACSignal createSignal:^(id < RACSubscriber > subscriber) {
        
        RACReplaySubject * subject = [RACReplaySubject replaySubjectWithCapacity:1];
        
        AFHTTPRequestOperation * operation = [self operationForRemoteObject:remoteObject];
        
        [subject setNameWithFormat:@"-rac_start: %@", operation.request.URL];
        
        [(AFHTTPRequestOperation *) operation setCompletionBlockWithSuccess :^(id operation, id responseObject) {
            
            remoteObject.responseObject = responseObject;
            
            [subject sendNext:remoteObject];
            [subject sendCompleted];
            
        } failure :^(id operation, NSError * error) {
            
            [subject sendNext:remoteObject];
            [subject sendCompleted];
            
        }];
        
        [self.operationQueue addOperation:operation];
        
        [subject subscribe:subscriber];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

#pragma mark - AFHTTPRequestOperations

- (AFHTTPRequestOperation *) operationForRemoteObject:(IPRemoteObject *)remoteObject
{
    NSMutableURLRequest * request = [self requestWithMethod:@"GET" path:remoteObject.path parameters:nil];
    
    return [remoteObject requestOperationWithRequest:request];
}

#pragma mark - NSMutableURLRequests

- (NSMutableURLRequest *) requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSURL * baseURL = self.baseURL;
    
    if ([path rangeOfString:@"http"].location != NSNotFound)
    {
        baseURL = nil;
    }
    
    NSMutableURLRequest * request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:path relativeToURL:baseURL] absoluteString] parameters:nil error:nil];
    
    return request;
}

@end
