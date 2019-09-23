//
//  JXAttributeText.h
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXAttributeText : NSObject

- (instancetype)initWithText:(NSString *)text icon:(nullable NSString *)icon;

- (JXAttributeText * (^)(CGFloat fontSize))font;
- (JXAttributeText * (^)(UIColor *textColor))color;
- (JXAttributeText * (^)(SEL selector))tap;
- (JXAttributeText * (^)(CGFloat y))attachmentY;

- (NSAttributedString *)apply;

@end

NS_ASSUME_NONNULL_END
