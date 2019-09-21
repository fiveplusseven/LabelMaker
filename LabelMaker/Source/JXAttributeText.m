//
//  JXAttributeText.m
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import "JXAttributeText.h"

#define kChainImplement(params, ...) \
return ^id(params) { \
__VA_ARGS__ \
return self; \
};

@interface JXAttributeText ()

@property (nonatomic, copy) NSString *str;

@property (nonatomic, strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;

@end

@implementation JXAttributeText

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.str = text;
    }
    return self;
}

- (JXAttributeText * _Nonnull (^)(CGFloat))font {
    kChainImplement(CGFloat size, {
        [self.attributes setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    });
}

- (JXAttributeText * _Nonnull (^)(UIColor * _Nonnull))color {
    kChainImplement(UIColor *color, {
        [self.attributes setObject:color forKey:NSForegroundColorAttributeName];
    });
}

- (NSAttributedString *)apply {
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:self.str attributes:self.attributes];
    return as;
}

#pragma mark - getter and setter
- (NSMutableDictionary<NSAttributedStringKey,id> *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return _attributes;
}

@end
