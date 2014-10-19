//
//  WebSocket.h
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SocketIO.h>

@interface WebSocket : NSObject <SocketIODelegate> {
    SocketIO *socketIO;
}

@property (nonatomic, strong) SocketIO *socketIO;
+ (id)sharedWebSocket:(id)SocketIODelegate;
@end
