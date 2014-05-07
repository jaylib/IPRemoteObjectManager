//
//  IPViewController.m
//  IPRemoteObjectManager
//
//  Created by Josef Materi on 07.05.14.
//  Copyright (c) 2014 i/POL GmbH. All rights reserved.
//

#import "IPViewController.h"
#import "IPRemoteObjectManager.h"

@interface IPViewController ()

@end

@implementation IPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    IPRemoteObjectManager *manager = [[IPRemoteObjectManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://af.spiegel.de"]];
    
    IPRemoteImage *image = [[IPRemoteImage alloc] initWithPath:@"images/image-691243-quadrat_fussballapp_large-mukl.jpg"
                                                    completion:^(IPRemoteObject *remoteImage) {
                                                        NSLog(@"Complete Image");
                                                        
                                                        
                                                    }];
    
    IPRemoteImage *image2 = [[IPRemoteImage alloc] initWithPath:@"images/image-690952-quadrat_fussballapp_middle-paxp.jpg"
                                                     completion:^(IPRemoteObject *remoteImage) {
                                                         NSLog(@"Complete Image2");
                                                         
                                                     }];
    
    IPRemoteJSON *remoteJSON = [[IPRemoteJSON alloc] initWithPath:@"index.json" completion:^(IPRemoteObject *remoteObject) {
        
        NSLog(@"Completed JSON!");
        
    }];
    
    IPRemoteJSON *remoteJSON2 = [[IPRemoteJSON alloc] initWithPath:@"index.json" completion:^(IPRemoteObject *remoteObject) {
        
        NSLog(@"Completed JSON2!");
        
    }];
    
    IPRemoteObjectCollection *collection =  [[IPRemoteObjectCollection alloc] initWithObjects:@[image2, remoteJSON] complete:^(IPRemoteObject *object) {
        
        NSLog(@"Finished collection1! %@", object);
        
    } error:^(NSError *error) {
        
    }];
    
    IPRemoteObjectCollection *collection2 =  [[IPRemoteObjectCollection alloc] initWithObjects:@[collection] complete:^(IPRemoteObject *object) {
        
        NSLog(@"Finished collection2! %@", object);
        
    } error:^(NSError *error) {
        
    }];
    
    IPRemoteObjectCollection *collection3 =  [[IPRemoteObjectCollection alloc] initWithObjects:@[collection2] complete:^(IPRemoteObject *object) {
        
        NSLog(@"Finished collection3! %@", object);
        
    } error:^(NSError *error) {
        
    }];
    
    
    [manager getRemoteObjects:@[collection3, image, remoteJSON2] complete:^(NSArray *remoteImages) {
        
        NSLog(@"Finsihed all of them");
        
    } error:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
