//
//  LoginViewController.m
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "LoginViewController.h"
#import "WebSocket.h"

@implementation LoginViewController {
    SocketIO *socketIO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:contentView];
    socketIO = [WebSocket sharedWebSocket:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) socketIODidConnect:(SocketIO *)socket {
    NSMutableDictionary *connectionData = [[NSMutableDictionary alloc] init];
    [connectionData setValue:@"evancasey" forKey:@"userId"];
    [connectionData setValue:@2 forKey:@"lat"];
    [connectionData setValue:@1 forKey:@"lon"];
    [socketIO sendEvent:@"updateLocation" withData:connectionData];
}

@end
