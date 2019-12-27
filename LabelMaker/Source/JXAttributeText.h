//
//  JXAttributeText.h
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JXAttributeTextAttachmentPos) {
    JXAttributeTextAttachmentPosLeft,
    JXAttributeTextAttachmentPosRight,
};

@interface JXAttributeText : NSObject

- (instancetype)initWithText:(NSString *)text icon:(nullable NSString *)icon;

- (JXAttributeText * (^)(CGFloat fontSize))font;
- (JXAttributeText * (^)(CGFloat fontSize, UIFontWeight weight))fontAndWeight;
- (JXAttributeText * (^)(UIColor *textColor))color;
- (JXAttributeText * (^)(CGFloat offset))baselineOffset;
- (JXAttributeText * (^)(CGFloat spacing, NSTextAlignment alignment))lineSpacing;

- (JXAttributeText * (^)(SEL selector))tap;
- (JXAttributeText * (^)(CGFloat y))attachmentY;
- (JXAttributeText * (^)(JXAttributeTextAttachmentPos pos))attachmentPos;

- (NSAttributedString *)apply;

@end

NS_ASSUME_NONNULL_END
