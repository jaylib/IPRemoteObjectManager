//
//  IPRemoteObjectQueue.h
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPRemoteObject.h"

@interface IPRemoteObjectCollection : IPRemoteObject

@property (nonatomic, strong) NSArray *objects;

- (instancetype)initWithObjects:(NSArray *)objects complete:(RemoteObjectCompletionBlock)complete error:(void (^)(NSError *error))error;

@end
