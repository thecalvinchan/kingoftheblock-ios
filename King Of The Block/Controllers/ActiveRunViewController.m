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
#import "ImageHelpers.h"
#import "ColorHelpers.h"

@interface ActiveRunViewController()
@property (strong, nonatomic)UIButton *sendCoordsButton;
@property (strong, nonatomic)MKMapView *activeMapView;
@property (strong, nonatomic)NSMutableArray *activeUserPath;
@property (strong, nonatomic)MKPolyline *polyline;

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
    [self.activeMapView setDelegate:self];
    [self.activeMapView setRotateEnabled:false];
    [self.activeMapView setPitchEnabled:false];
    [self.activeMapView setZoomEnabled:false];
    [self.activeMapView  setScrollEnabled:false];
    
    // Center map to Manhattan
    CLLocationCoordinate2D manhattanCoords = CLLocationCoordinate2DMake(40.790278, -73.959722);
    MKCoordinateSpan manhattanBounds = MKCoordinateSpanMake(0.05, 0.3);
    [self.activeMapView setRegion:MKCoordinateRegionMake(manhattanCoords, manhattanBounds)];
    [self.activeMapView setShowsUserLocation: true];
    
    // Add map subview
    [contentView addSubview:self.activeMapView];
    
    // Start Run Button
    self.sendCoordsButton = [[UIButton alloc] init];
    [self.sendCoordsButton addTarget:self action:@selector(triggerActiveRunButton) forControlEvents:UIControlEventTouchUpInside];
    
    // Button States
    [self.sendCoordsButton setTitle:@"Start Run" forState:UIControlStateNormal];
    [self.sendCoordsButton setBackgroundImage:[ImageHelpers imageWithColor:[ColorHelpers leanAndGreen]] forState:UIControlStateNormal];
    [self.sendCoordsButton setTitle:@"Finish Run" forState:UIControlStateSelected];
    [self.sendCoordsButton setBackgroundImage:[ImageHelpers imageWithColor:[ColorHelpers deadRed]] forState:UIControlStateSelected];
    
    // Add Start Run Button subview
    [contentView addSubview:self.sendCoordsButton];
    
    // Position Start Run Button
    UIEdgeInsets offsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.sendCoordsButton setContentEdgeInsets:UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0)];
    [self.sendCoordsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.view.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(contentView.mas_left).with.offset(offsets.left);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-self.tabBarController.tabBar.frame.size.height-offsets.bottom);
        make.right.equalTo(contentView.mas_right).with.offset(-offsets.right);
    }];

    
    // Add ViewController subview
    [self.view addSubview:contentView];
    socketIO = [WebSocket sharedWebSocket:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) socketIODidConnect:(SocketIO *)socket {
}

- (void) triggerActiveRunButton {
    if (!self.sendCoordsButton.selected) {
        [self startRun];
    } else {
        [self stopRun];
    }
}

- (void)startRun {
    [self.sendCoordsButton setSelected:true];
    self.activeUserPath = [[NSMutableArray alloc] init];
    [self startStandardUpdates];
    
}

- (void)stopRun {
    [self.sendCoordsButton setSelected:false];
    // Re-center map to Manhattan
    CLLocationCoordinate2D manhattanCoords = CLLocationCoordinate2DMake(40.790278, -73.959722);
    MKCoordinateSpan manhattanBounds = MKCoordinateSpanMake(0.05, 0.3);
    [self.activeMapView setRegion:MKCoordinateRegionMake(manhattanCoords, manhattanBounds)];
    // Remove overlay polygons
    [self.activeMapView removeOverlay:self.polyline];
    
    NSMutableDictionary *connectionData = [[NSMutableDictionary alloc] init];
    [connectionData setValue:@"cchan" forKey:@"userId"];
    [socketIO sendEvent:@"endRun" withData:connectionData];
    [self stopStandardUpdates];
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

- (void)stopStandardUpdates
{
    [self.locationManager stopUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    [self.activeUserPath addObject:location];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    
    // Center map to user
    CLLocationCoordinate2D userCoords = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan userBounds = MKCoordinateSpanMake(0.0025, 0.0025);
    [self.activeMapView setRegion:MKCoordinateRegionMake(userCoords, userBounds)];
    
    // Render existing path
    NSUInteger count = [self.activeUserPath count];
    NSLog([NSString stringWithFormat:@"%lu", (unsigned long)count]);
    if (count > 1) {
        CLLocationCoordinate2D coordinates[count];
        for (NSInteger i = 0; i < count; i++) {
            coordinates[i] = [(CLLocation *)self.activeUserPath[i] coordinate];
        }
        MKPolyline *oldPolyline = self.polyline;
        self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:count];
        [self.activeMapView addOverlay:self.polyline];
        if (oldPolyline)
            [self.activeMapView removeOverlay:oldPolyline];
    }
    
    // Send coordinates to server via websockets
    NSMutableDictionary *connectionData = [[NSMutableDictionary alloc] init];
    NSArray *coords = [NSArray arrayWithObjects:[NSNumber numberWithDouble:location.coordinate.latitude], [NSNumber numberWithDouble:location.coordinate.longitude], nil];
    
    [connectionData setValue:@"cchan" forKey:@"userId"];
    [connectionData setValue:coords forKey:@"coords"];
    [socketIO sendEvent:@"updateLocation" withData:connectionData];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        NSLog(@"HELLO");
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    return nil;
}

// for iOS versions prior to 7; see `rendererForOverlay` for iOS7 and later

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *overlayView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.strokeColor     = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        overlayView.lineWidth       = 3;
        
        return overlayView;
    }
    
    return nil;
}

@end
