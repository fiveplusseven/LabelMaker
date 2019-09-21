//
//  ViewController.m
//  LabelMaker
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+JXMake.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@end

@implementation ViewController

- (void)basicUsage {
    [self.view addSubview:self.labelOne];
    
    [[self.labelOne.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50] setActive:YES];
    [[self.labelOne.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.labelOne.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.labelOne.heightAnchor constraintEqualToConstant:50] setActive:YES];
    
    [self.labelOne jx_make:^(JXTextMaker * _Nonnull make) {
        make.text(@"已获").font(15).color([UIColor blackColor]);
        make.text(@"7").font(30).color([UIColor orangeColor]);
        make.text(@"个图鉴").font(15).color([UIColor blackColor]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicUsage];
}

#pragma mark - getter and setter
- (UILabel *)labelOne {
    if (_labelOne == nil) {
        _labelOne = [UILabel new];
        _labelOne.translatesAutoresizingMaskIntoConstraints = NO;
        _labelOne.backgroundColor = [UIColor grayColor];
    }
    return _labelOne;
}

- (UILabel *)labelTwo {
    if (_labelTwo == nil) {
        _labelTwo = [UILabel new];
        _labelTwo.translatesAutoresizingMaskIntoConstraints = NO;
        _labelTwo.backgroundColor = [UIColor grayColor];
    }
    return _labelTwo;
}
@end
