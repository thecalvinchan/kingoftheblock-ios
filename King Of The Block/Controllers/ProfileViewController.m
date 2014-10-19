//
//  ProfileViewController.m
//  King Of The Block
//
//  Created by Calvin on 10/19/14.
//  Copyright (c) 2014 hackNY. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking.h>

@interface ProfileViewController ()
@property (strong, nonatomic)MKMapView *activeMapView;
@property (strong, nonatomic)NSMutableArray *userBlocks;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Profile: %@", self.username]];
    // Create the request.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username": self.username};
    [manager GET:@"http://172-30-26-111.dynapool.nyu.edu:3000/blocks" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSLog(@"%@",responseObject);
        NSArray *blocks = [responseObject objectForKey:@"blocks"];
        
        for (NSArray *block in blocks) {
            NSInteger numCoordsInBlock = [block count];
            CLLocationCoordinate2D blockCoords[numCoordsInBlock];
            for (NSInteger i=0; i< numCoordsInBlock; i++) {
                CLLocationCoordinate2D point;
                point.latitude = [[block[i] objectAtIndex:1] doubleValue];
                point.longitude = [[block[i] objectAtIndex:0] doubleValue];
                blockCoords[i] = point;
            }
            MKPolygon *blockPolygon = [MKPolygon polygonWithCoordinates:blockCoords count:numCoordsInBlock];
            [self.activeMapView addOverlay:blockPolygon];
            [self.userBlocks addObject:blockPolygon];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    //NSLog(@"HELLOWORLD%@", overlay);
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        NSLog(@"HELLOWORLD%@", overlay);
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        
        renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:1.0f];
        //renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    return nil;
}

// for iOS versions prior to 7; see `rendererForOverlay` for iOS7 and later

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    //NSLog(@"HELLOWORLD%@", overlay);
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        NSLog(@"HELLOWORLD%@", overlay);
        MKPolygonView *overlayView = [[MKPolygonView alloc] initWithPolygon:overlay];
        
        overlayView.fillColor     = [[UIColor blueColor] colorWithAlphaComponent:1.0f];
        
        return overlayView;
    }
    
    return nil;
}

@end
