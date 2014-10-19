//
//  ProfileViewController.m
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic)MKMapView *activeMapView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Profile: %@", self.username]];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor greenColor];
    
    // MapView
    self.activeMapView = [[MKMapView alloc] initWithFrame:contentView.frame];
    [self.activeMapView setDelegate:self];
    /**
    [self.activeMapView setRotateEnabled:false];
    [self.activeMapView setPitchEnabled:false];
    [self.activeMapView setZoomEnabled:false];
    [self.activeMapView  setScrollEnabled:false];
     **/
    
    // Center map to Manhattan
    CLLocationCoordinate2D manhattanCoords = CLLocationCoordinate2DMake(40.790278, -73.959722);
    MKCoordinateSpan manhattanBounds = MKCoordinateSpanMake(0.05, 0.1);
    [self.activeMapView setRegion:MKCoordinateRegionMake(manhattanCoords, manhattanBounds)];
    [self.activeMapView setShowsUserLocation: true];
    
    // Add map subview
    [contentView addSubview:self.activeMapView];
    
    // Add ViewController subview
    [self.view addSubview:contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
