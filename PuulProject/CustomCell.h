//
//  CustomCell.h
//  PuulProject
//
//  Created by David Ho on 8/6/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *HeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *pay;

@end