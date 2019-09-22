//
//  ViewController.m
//  LabelMaker
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+JXMake.h"

@interface ViewController ()<JXMakeTapActionDelegate>

@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@end

@implementation ViewController

- (void)basicUsage {
    [self.view addSubview:self.labelOne];
    
    [[self.labelOne.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50] setActive:YES];
    [[self.labelOne.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.labelOne.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    
    [self.labelOne jx_make:^(JXTextMaker * _Nonnull make) {
        make.text(@"已获").font(15).color([UIColor blackColor]);
        make.text(@"7").font(30).color([UIColor orangeColor]);
        make.text(@"个图鉴").font(15).color([UIColor blackColor]);
    }];
}

- (void)tapUsage {
    [self.view addSubview:self.labelTwo];
    
    [[self.labelTwo.topAnchor constraintEqualToAnchor:self.labelOne.bottomAnchor constant:20] setActive:YES];
    [[self.labelTwo.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.labelTwo.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    
    [self.labelTwo jx_make:^(JXTextMaker * _Nonnull make) {
        make.text(@"phone ").font(15).color([UIColor blackColor]);
        make.text(@"182 6193 2918").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
        make.text(@"phone ").font(15).color([UIColor blackColor]);
        make.text(@"182 6193 2917").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
        make.text(@"phone ").font(15).color([UIColor blackColor]);
        make.text(@"182 6193 2916").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
        make.text(@"phone ").font(15).color([UIColor blackColor]);
        make.text(@"182 6193 2915").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
        make.text(@"phone ").font(15).color([UIColor blackColor]);
        make.text(@"182 6193 2914").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
        make.text(@"phone ").font(15).color([UIColor blackColor]);
        make.text(@"182 6193 2913").font(15).color([UIColor redColor]).tap(@selector(clickPhoneNumber:));
    }];
}

- (void)clickPhoneNumber:(NSString *)phone {
    NSLog(@"tap tap => %@", phone);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicUsage];
    [self tapUsage];
}

#pragma mark - getter and setter
- (UILabel *)labelOne {
    if (_labelOne == nil) {
        _labelOne = [UILabel new];
        _labelOne.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _labelOne;
}

- (UILabel *)labelTwo {
    if (_labelTwo == nil) {
        _labelTwo = [UILabel new];
        _labelTwo.translatesAutoresizingMaskIntoConstraints = NO;
        _labelTwo.numberOfLines = 0;
        _labelTwo.jx_tapDelegate = self;
    }
    return _labelTwo;
}
@end
