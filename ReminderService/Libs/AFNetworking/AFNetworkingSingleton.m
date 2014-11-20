//
//  AFNetworkingSingleton.m
//  GWS-BS
//
//  Created by quangdung156 on 8/27/13.
//  Copyright (c) 2013 Gulliver. All rights reserved.
//

#import "AFNetworkingSingleton.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFAppDotNetAPIBaseURLString = @"";

@implementation AFNetworkingSingleton

+ (AFNetworkingSingleton *)sharedClient {
    static AFNetworkingSingleton *_sharedClient = nil;
    static dispatch_once_t onceToken;   //lock
    dispatch_once(&onceToken, ^{        // This code is called at most once per app
        _sharedClient = [[AFNetworkingSingleton alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    // By default, the example ships with SSL pinning enabled for the app.net API pinned against the public key of adn.cer file included with the example. In order to make it easier for developers who are new to AFNetworking, SSL pinning is automatically disabled if the base URL has been changed. This will allow developers to hack around with the example, without getting tripped up by SSL pinning.
    if ([[url scheme] isEqualToString:@"https"] && [[url host] isEqualToString:@"alpha-api.app.net"]) {
        self.defaultSSLPinningMode = AFSSLPinningModePublicKey;
    } else {
        self.defaultSSLPinningMode = AFSSLPinningModeNone;
    }
    
    return self;
}

@end
