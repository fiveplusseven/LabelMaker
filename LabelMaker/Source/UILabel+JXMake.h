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

@protocol JXMakeTapActionDelegate <NSObject>
@end

@interface UILabel (JXMake)

- (void)jx_make:(void (^)(JXTextMaker *make))block;

/**
 If a tap action is set, deleagte needs to be set for message dispatch.
 */
@property (nonatomic, weak) id<JXMakeTapActionDelegate> jx_tapDelegate;

@end

NS_ASSUME_NONNULL_END
