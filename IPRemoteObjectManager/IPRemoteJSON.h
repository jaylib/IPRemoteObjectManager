//
//  IPRemoteJSON.h
//  RACTester
//
//  Created by Josef Materi on 06.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPRemoteObject.h"

@interface IPRemoteJSON : IPRemoteObject
@property (nonatomic, strong) NSDictionary *responseData;
@end
