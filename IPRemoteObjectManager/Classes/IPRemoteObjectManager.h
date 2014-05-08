//
//  IPDownloadManager.h
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <RACAFNetworking.h>
#import "IPRemoteImage.h"
#import "IPRemoteJSON.h"
#import "IPRemoteObjectCollection.h"

@interface IPRemoteObjectManager : AFHTTPRequestOperationManager

- (void)getRemoteObjects:(NSArray *)remoteObjects complete:(void (^)(NSArray *remoteImages))complete error:(void (^)(NSError *error))errorBlock;

- (void)cancel;

@end
