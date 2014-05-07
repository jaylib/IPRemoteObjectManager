//
//  IPRemoteObjectQueue.m
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPRemoteObjectCollection.h"

@implementation IPRemoteObjectCollection

- (instancetype)initWithObjects:(NSArray *)objects complete:(RemoteObjectCompletionBlock)complete error:(void (^)(NSError *error))error {
    self = [super init];
    if (self) {
        self.completionBlock = complete;
        self.objects = objects;
    }
    return self;
}

- (NSArray *)subObjects {
    return self.objects;
}


@end
