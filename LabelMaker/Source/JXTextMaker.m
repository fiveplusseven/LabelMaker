//
//  JXTextMaker.m
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import "JXTextMaker.h"

@interface JXTextMaker ()

@property (nonatomic, strong) NSMutableArray<JXAttributeText *> *components;

@end

@implementation JXTextMaker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.components = [NSMutableArray array];
    }
    return self;
}

- (JXAttributeText * _Nonnull (^)(NSString * _Nonnull))text {
    return ^JXAttributeText *(NSString *text) {
        JXAttributeText *at = [[JXAttributeText alloc] initWithText:text];
        [self.components addObject:at];
        return at;
    };
}

- (NSAttributedString *)pack {
    NSMutableAttributedString *mas = [NSMutableAttributedString new];
    for (JXAttributeText *item in self.components) {
        NSAttributedString *as = [item apply];
        [mas appendAttributedString:as];
    }
    
    return [mas copy];
}

@end
