//
//  UILabel+JXMake.m
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import "UILabel+JXMake.h"

@implementation UILabel (JXMake)

- (void)jx_make:(void (^)(JXTextMaker * _Nonnull))block {
    JXTextMaker *maker = [JXTextMaker new];
    block(maker);
    self.attributedText = [maker pack];
}

@end
