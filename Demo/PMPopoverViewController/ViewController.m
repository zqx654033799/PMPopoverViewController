//
//  ViewController.m
//  PMPopoverViewController
//
//  Created by Paperman on 16/6/12.
//  Copyright © 2016年 Paperman. All rights reserved.
//

#import "ViewController.h"
#import "PMPopoverViewController.h"
#import "PopoverViewController.h"

@interface ViewController ()
@property (strong, nonatomic) PMPopoverViewController *pmPop;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)barItemTapAction:(id)sender {
    PopoverViewController *pop = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    self.pmPop = [[PMPopoverViewController alloc] initWithContentViewController:pop];
    [self.pmPop setPopoverContentSize:CGSizeMake(200, 100)];
    [self.pmPop showPopoverInViewController:self fromBarButtonItem:sender];
}

- (IBAction)buttonTapAction:(id)sender {
    PopoverViewController *pop = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    self.pmPop = [[PMPopoverViewController alloc] initWithContentViewController:pop];
    [self.pmPop setPopoverContentSize:CGSizeMake(200, 100)];
    [self.pmPop showPopoverInViewController:self fromRect:[sender bounds] inView:sender];
}
@end
