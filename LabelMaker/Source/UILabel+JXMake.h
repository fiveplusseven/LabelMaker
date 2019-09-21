//
//  UILabel+JXMake.h
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTextMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JXMake)

- (void)jx_make:(void (^)(JXTextMaker *make))block;

@end

NS_ASSUME_NONNULL_END
