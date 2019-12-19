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

@property (nonatomic, assign) JXAttributeTextAttachmentPos pos;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *str;

@property (nonatomic, strong) NSMutableDictionary<NSAttributedStringKey, id> *attributes;

@end

@implementation JXAttributeText

- (instancetype)initWithText:(NSString *)text icon:(nullable NSString *)icon {
    self = [super init];
    if (self) {
        self.offsetY = 0;
        self.str = text;
        self.icon = icon;
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

- (JXAttributeText * _Nonnull (^)(SEL _Nonnull))tap {
    kChainImplement(SEL selector, {
        NSString *urlStr = [NSString stringWithFormat:@"jx://tap?selector=%@&str=%@", NSStringFromSelector(selector), self.str];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.attributes setObject:urlStr forKey:NSLinkAttributeName];
        [self.attributes setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    });
}

- (JXAttributeText * _Nonnull (^)(CGFloat))attachmentY {
    kChainImplement(CGFloat y, {
        self.offsetY = y;
    });
}

- (JXAttributeText * _Nonnull (^)(JXAttributeTextAttachmentPos))attachmentPos {
    kChainImplement(JXAttributeTextAttachmentPos pos, {
        self.pos = pos;
    });
}

- (NSAttributedString *)apply {
    if (!self.icon) {
        return [[NSAttributedString alloc] initWithString:self.str attributes:self.attributes];
    }

    NSTextAttachment *ta = [[NSTextAttachment alloc] init];
    CGSize size = [self getAttachmentSize];
    ta.bounds = CGRectMake(0, self.offsetY, size.width, size.height);
    ta.image = [UIImage imageNamed:self.icon];
    
    if (self.pos == JXAttributeTextAttachmentPosLeft) {
        NSMutableAttributedString *mas = [[NSAttributedString attributedStringWithAttachment:ta] mutableCopy];
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:self.str attributes:self.attributes];
        [mas appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [mas appendAttributedString:as];
        return [mas copy];
    } else {
        NSMutableAttributedString *mas = [[[NSAttributedString alloc] initWithString:self.str attributes:self.attributes] mutableCopy];
        NSAttributedString *attchmentAs = [NSAttributedString attributedStringWithAttachment:ta];
        [mas appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [mas appendAttributedString:attchmentAs];
        return [mas copy];
    }
}

#pragma mark - getter and setter
- (NSMutableDictionary<NSAttributedStringKey,id> *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return _attributes;
}

- (CGSize)getAttachmentSize {
    UIImage *img = [UIImage imageNamed:self.icon];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    return imgView.intrinsicContentSize;
}

@end
