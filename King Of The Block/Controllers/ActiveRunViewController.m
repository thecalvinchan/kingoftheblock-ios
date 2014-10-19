//
//  LoginViewController.m
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "ActiveRunViewController.h"
#import "WebSocket.h"
#import "Masonry.h"
#import <MapKit/MapKit.h>

@interface ActiveRunViewController()
@property (strong, nonatomic)UIButton *sendCoordsButton;
@property (strong, nonatomic)MKMapView *activeMapView;

@end

@implementation ActiveRunViewController {
    SocketIO *socketIO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor greenColor];
    
    // MapView
    self.activeMapView = [[MKMapView alloc] initWithFrame:contentView.frame];
    [self.activeMapView setRotateEnabled:false];
    [self.activeMapView setPitchEnabled:false];
    [self.activeMapView setZoomEnabled:false];
    [self.activeMapView  setScrollEnabled:false];
    
    // Center map to Manhattan
    CLLocationCoordinate2D manhattanCoords = CLLocationCoordinate2DMake(40.790278, -73.959722);
    MKCoordinateSpan manhattanBounds = MKCoordinateSpanMake(0.05, 0.3);
    [self.activeMapView setRegion:MKCoordinateRegionMake(manhattanCoords, manhattanBounds)];
    [contentView addSubview:self.activeMapView];
    
    // Start Run Button
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.sendCoordsButton = [[UIButton alloc] init];
    [self.sendCoordsButton addTarget:self action:@selector(sendCoords) forControlEvents:UIControlEventTouchUpInside];
    [self.sendCoordsButton setTitle:@"Start Run" forState:UIControlStateNormal];
    [self.sendCoordsButton setBackgroundColor:[UIColor redColor]];
    [contentView addSubview:self.sendCoordsButton];
    [self.sendCoordsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.view.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(contentView.mas_left).with.offset(padding.left);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-self.tabBarController.tabBar.frame.size.height-padding.bottom);
        make.right.equalTo(contentView.mas_right).with.offset(-padding.right);
    }];
    
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
