//
//  ViewController.m
//  DistanceCalculator
//
//  Created by cristina on 5/2/17.
//  Copyright © 2017 crisbarreiro. All rights reserved.
//

#import "ViewController.h"
#import <DistanceGetter/DGDistanceRequest.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *startingLocation;

@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSelector;

@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;

@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;

@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;

@property (nonatomic) DGDistanceRequest *request;

@end

@implementation ViewController
- (IBAction)onClickDistanceButton:(id)sender {
    _calculateButton.enabled = NO;
    _request = [DGDistanceRequest alloc];
    NSString *start = self.startingLocation.text;
    NSString *destinationA = _endLocationA.text;
    NSString *destinationB = _endLocationB.text;
    NSString *destinationC = _endLocationC.text;
    NSArray *destinations = @[destinationA, destinationB, destinationC];
    NSArray *distances = @[_distanceA, _distanceB, _distanceC];
    
    _request = [_request initWithLocationDescriptions:destinations sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    _request.callback = ^void(NSArray * responses) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) return;
        NSNull *badResult = [NSNull null];
        
        int counter = 0;
        for (id response in responses) {
            if (response != badResult) {
                double distance = 0;
                NSString *tmp = @"";
                switch (strongSelf.unitSelector.selectedSegmentIndex) {
                    case 0:
                        distance = [response floatValue];
                        tmp = [NSString stringWithFormat:@"%.2f m", distance];
                        break;
                    case 1:
                        distance = [response floatValue]/1000;
                        tmp = [NSString stringWithFormat:@"%.2f km", distance];
                        break;
                    case 2:
                        distance = [response floatValue]*0.000621371192;
                        tmp = [NSString stringWithFormat:@"%.2f miles", distance];
                        break;
                }
                ((UILabel*)[distances objectAtIndex:counter]).text = tmp;
            } else {
                ((UILabel*)[distances objectAtIndex:counter]).text = @"Error";
            }
            ++counter;
        }
        
        strongSelf.calculateButton.enabled = YES;
        strongSelf.request = nil;

    };
    
    [_request start];
}



@end
