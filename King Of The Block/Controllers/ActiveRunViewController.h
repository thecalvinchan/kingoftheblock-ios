//
//  LoginViewController.h
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIO.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ActiveRunViewController: UIViewController <SocketIODelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end
