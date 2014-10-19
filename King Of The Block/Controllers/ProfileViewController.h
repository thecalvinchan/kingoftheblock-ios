//
//  ProfileViewController.h
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ProfileViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) NSString *username;
@end
