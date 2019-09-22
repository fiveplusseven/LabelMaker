//
//  UILabel+JXMake.m
//  JXLabel
//
//  Created by longjianjiang on 2019/9/21.
//  Copyright © 2019 Jiang. All rights reserved.
//

#import "UILabel+JXMake.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

@interface JXTapModel : NSObject

@property (nonatomic, copy) NSString *str;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, copy) NSString *selector;

- (instancetype)initWithStr:(NSString *)str selector:(NSString *)selector range:(NSRange)range;

@end

@implementation JXTapModel

- (instancetype)initWithStr:(NSString *)str selector:(NSString *)selector range:(NSRange)range {
    self = [super init];
    if (self) {
        self.str = str;
        self.selector = selector;
        self.range = range;
    }
    return self;
}

@end

#pragma mark - JXMake
@implementation UILabel (JXMake)

- (void)jx_make:(void (^)(JXTextMaker * _Nonnull))block {
    JXTextMaker *maker = [JXTextMaker new];
    block(maker);
    self.attributedText = [maker pack];
    
    [self _setupTapModel:[maker tapList]];
}

- (void)_setupTapModel:(NSArray<NSString *> *)list {
    if (list.count == 0) { return; }
    
    self.isTapAction = YES;
    self.userInteractionEnabled = YES;
    
    NSArray *paramsList = [self getParamsList:list];
    NSArray *selectorList = paramsList[0];
    NSArray *strList = paramsList[1];
    
    NSString *textStr = self.attributedText.string;
    [strList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [textStr rangeOfString:obj];
        JXTapModel *tm = [[JXTapModel alloc] initWithStr:obj selector:selectorList[idx] range:range];
        [self.tapComponents addObject:tm];
    }];
}

#pragma mark - touch methods
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isTapAction) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (![self judgePointIsAtTapComponent:point]) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isTapAction) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (![self judgePointIsAtTapComponent:point]) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
}

#pragma mark - judge methods
- (BOOL)judgePointIsAtTapComponent:(CGPoint)point {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frame);
    CGFloat totalHeight =  [self getAttributedStringSize:self.attributedText width:self.bounds.size.width lines:0].height;

    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(path);
        return NO;
    }
    
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = [self transformForCoreText];
    
    for (CFIndex i = 0; i < lineCount; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        CGFloat lineOutSpace = (self.bounds.size.height - totalHeight) / 2;
        rect.origin.y = lineOutSpace + [self getLineOrign:line];
        
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            for (int j = 0; j < self.tapComponents.count; j++) {
                JXTapModel *model = self.tapComponents[j];
                
                if (NSLocationInRange(index, model.range)) {
                    SEL tapSelector = NSSelectorFromString(model.selector);
                    if (![self.jx_tapDelegate respondsToSelector:tapSelector]) {
                        NSLog(@"Warning> tap selector not implement");
                    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [self.jx_tapDelegate performSelector:tapSelector withObject:model.str];
#pragma clang diagnostic pop
                    }
                    
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(path);
                    return YES;
                }
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
    return NO;
}

- (CGSize)getAttributedStringSize:(NSAttributedString *)as width:(CGFloat)width lines:(NSInteger)lines {
    UILabel *sizeLabel = [UILabel new];
    sizeLabel.numberOfLines = lines;
    sizeLabel.attributedText = as;
    CGSize fitSize = [sizeLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return fitSize;
}

- (CGAffineTransform)transformForCoreText {
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = 0.0f;
    
    CFRange range = CTLineGetStringRange(line);
    NSAttributedString *as = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
    if ([as.string hasSuffix:@"\n"] && as.string.length > 1) {
        as = [as attributedSubstringFromRange:NSMakeRange(0, as.length - 1)];
    }
    height = [self getAttributedStringSize:as width:self.bounds.size.width lines:0].height;
    return CGRectMake(point.x, point.y , width, height);
}

- (CGFloat)getLineOrign:(CTLineRef)line {
    CFRange range = CTLineGetStringRange(line);
    if (range.location == 0) {
        return 0;
    } else {
        NSAttributedString *as = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, range.location)];
        if ([as.string hasSuffix:@"\n"] && as.string.length > 1) {
            as = [as attributedSubstringFromRange:NSMakeRange(0, as.length - 1)];
        }
        return [self getAttributedStringSize:as width:self.bounds.size.width lines:0].height;
    }
}

#pragma mark - assosiate property
- (NSMutableArray<JXTapModel *> *)tapComponents {
    NSMutableArray *tapComponents = objc_getAssociatedObject(self, _cmd);
    if (!tapComponents) {
        tapComponents = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, tapComponents, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tapComponents;
}

- (BOOL)isTapAction {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapAction:(BOOL)isTapAction {
    objc_setAssociatedObject(self, @selector(isTapAction), @(isTapAction), OBJC_ASSOCIATION_ASSIGN);
}

- (id<JXMakeTapActionDelegate>)jx_tapDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJx_tapDelegate:(id<JXMakeTapActionDelegate>)jx_tapDelegate {
    objc_setAssociatedObject(self, @selector(jx_tapDelegate), jx_tapDelegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - helper method
- (NSArray *)getParamsList:(NSArray *)tapList {
    NSMutableArray *res = [NSMutableArray array];
    NSMutableArray *selectorList = [NSMutableArray array];
    NSMutableArray *strList = [NSMutableArray array];
    
    for (NSString *str in tapList) {
        NSURL *url = [NSURL URLWithString:str];
        NSArray *paramsString = [url.query componentsSeparatedByString:@"&"];
        for (int i = 0; i < paramsString.count; ++i) {
            NSArray *tempArray = [paramsString[i] componentsSeparatedByString:@"="];
            if (i == 0) {
                [selectorList addObject:tempArray.lastObject];
            } else {
                NSString *str = [tempArray.lastObject stringByRemovingPercentEncoding];
                [strList addObject:str];
            }
        }
    }
    [res addObject:[selectorList copy]];
    [res addObject:[strList copy]];
    
    return [res copy];
}

@end
