//
//  JXTextMaker.h
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXAttributeText.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXTextMaker : NSObject

- (JXAttributeText * (^)(NSString *))text;

- (NSAttributedString *)pack;
- (NSArray<NSString *> *)tapList;

@end

NS_ASSUME_NONNULL_END
