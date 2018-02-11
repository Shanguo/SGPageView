//
//  UIView+SGPageView.m
//  SGPageView
//
//  Created by 刘山国 on 2018/2/11.
//  Copyright © 2018年 山国. All rights reserved.
//

#import "UIView+SGPageView.h"
#import <objc/runtime.h>

@implementation UIView (SGPageView)

- (void)setPageViewIndex:(NSInteger)pageViewIndex {
    [self willChangeValueForKey:@"pageViewIndex"];
    objc_setAssociatedObject(self, _cmd, @(pageViewIndex), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pageViewIndex"];
}

- (NSInteger)pageViewIndex {
    NSNumber *value = objc_getAssociatedObject(self, @selector(setPageViewIndex:));
    return [value integerValue];
}

- (void)setWebViewUrl:(NSURL *)webViewUrl {
    [self willChangeValueForKey:@"webViewUrl"];
    objc_setAssociatedObject(self, _cmd, webViewUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"webViewUrl"];
}

- (NSURL *)webViewUrl {
    return objc_getAssociatedObject(self, @selector(setWebViewUrl:));
}

@end
