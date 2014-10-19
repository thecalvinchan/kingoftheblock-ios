//
//  WebSocket.m
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "WebSocket.h"

@implementation WebSocket

@synthesize socketIO;

- (id)init {
    if (self = [super init]) {
        socketIO = [[SocketIO alloc] init];
    }
    return self;
}

+ (id)sharedWebSocket:(id)SocketIODelegate {
    static WebSocket *sharedWebSocket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWebSocket = [[self alloc] init];
        [sharedWebSocket.socketIO connectToHost:@"172-30-26-111.dynapool.nyu.edu" onPort:3000];
    });
    [sharedWebSocket.socketIO setDelegate:SocketIODelegate];
    return sharedWebSocket.socketIO;
}

@end

