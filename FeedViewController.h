//
//  FeedViewController.h
//  PuulProject
//
//  Created by David Ho on 7/9/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *startCitiesArray;
    NSMutableArray *endCitiesArray;
    NSMutableArray *stopsArray;
    NSMutableArray *requestedPayArray;
    NSMutableArray *startAddressArray;
    NSMutableArray *endAddressArray;
    
    NSMutableArray *sectionArray;
    NSMutableArray *data;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *options;
@property (strong, nonatomic) IBOutlet UITableView *givenRidesTableView;
@property (strong, nonatomic) IBOutlet UITableView *requestedViewController;

- (IBAction)changeRides:(id)sender;



@end
