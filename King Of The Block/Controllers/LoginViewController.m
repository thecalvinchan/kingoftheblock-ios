//
//  LoginViewController.m
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "LoginViewController.h"
#import "WebSocket.h"
#import "Masonry.h"

@implementation LoginViewController {
    SocketIO *socketIO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor greenColor];
    
    CGRect buttonFrame = CGRectMake(200, 200, 200, 300);
    UIButton *sendCoordsButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [sendCoordsButton addTarget:self action:@selector(sendCoords) forControlEvents:UIControlEventTouchUpInside];
    [sendCoordsButton setTitle:@"Send Coords" forState:UIControlStateNormal];
    [contentView addSubview:sendCoordsButton];
    
    [self.view addSubview:contentView];
    socketIO = [WebSocket sharedWebSocket:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) socketIODidConnect:(SocketIO *)socket {
}

- (void) sendCoords {
    NSLog(@"Hello World");
    [self startStandardUpdates];
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    
    NSMutableDictionary *connectionData = [[NSMutableDictionary alloc] init];
    NSArray *coords = [NSArray arrayWithObjects:[NSNumber numberWithDouble:location.coordinate.latitude], [NSNumber numberWithDouble:location.coordinate.longitude], nil];
    
    [connectionData setValue:@"evancasey" forKey:@"userId"];
    [connectionData setValue:coords forKey:@"coords"];
    [socketIO sendEvent:@"updateLocation" withData:connectionData];
}

@end
