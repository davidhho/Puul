//
//  PUHomeViewController.m
//  Puul
//
//  Created by David Ho on 4/21/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "PUHomeViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "PURoute.h"

@interface PUHomeViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *routes;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) PFGeoPoint *currentLocation;
@property (nonatomic, strong) UITableView *routeTable;

@end

@implementation PUHomeViewController

- (id)init{
    self = [super init];
    if (self) {
        self.routeTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        [self.view addSubview:_routeTable];
        
        self.title = @"Main View";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Methods

- (void)getRoutes{
    PFQuery *query = [PURoute query];
    [query whereKey:@"initialLocation" nearGeoPoint:self.currentLocation];
    query.limit = 15;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.routes = [NSMutableArray arrayWithArray:objects];
        [self loadData];
    }];
}

- (void)loadData{
    [_routeTable reloadData];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    self.currentLocation = [PFGeoPoint geoPointWithLocation:currentLocation];
    [self getRoutes];
}

#pragma mark - UITableViewProtocols

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _routes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    PURoute *route = _routes[indexPath.row];
    
    return cell;
}

@end
