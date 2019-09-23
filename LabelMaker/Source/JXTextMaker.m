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
@property (nonatomic, strong) NSArray<NSString *> *tapComponents;

@end

@implementation JXTextMaker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.components = [NSMutableArray array];
        self.tapComponents = [NSMutableArray array];
    }
    return self;
}

- (JXAttributeText * _Nonnull (^)(NSString * _Nonnull))text {
    return ^JXAttributeText *(NSString *text) {
        JXAttributeText *at = [[JXAttributeText alloc] initWithText:text icon:nil];
        [self.components addObject:at];
        return at;
    };
}

- (JXAttributeText * _Nonnull (^)(NSString * _Nonnull, NSString * _Nonnull))attachmentText {
    return ^JXAttributeText *(NSString *text, NSString *icon) {
        JXAttributeText *at = [[JXAttributeText alloc] initWithText:text icon:icon];
        [self.components addObject:at];
        return at;
    };
}

- (NSAttributedString *)pack {
    NSMutableAttributedString *mas = [NSMutableAttributedString new];
    NSMutableArray *list = [NSMutableArray array];
    
    for (JXAttributeText *item in self.components) {
        NSAttributedString *as = [item apply];
        [mas appendAttributedString:as];
        NSString *urlStr = [as attribute:NSLinkAttributeName atIndex:0 effectiveRange:NULL];
        if (urlStr) {
            NSRange range = [mas.string rangeOfString:as.string];
            [mas removeAttribute:NSLinkAttributeName range:range];
            [list addObject:urlStr];
        }
    }
    self.tapComponents = [list copy];
    
    return [mas copy];
}

- (NSArray<NSString *> *)tapList {
    return self.tapComponents;
}

@end
