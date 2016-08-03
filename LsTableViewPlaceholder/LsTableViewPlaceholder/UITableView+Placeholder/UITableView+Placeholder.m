//
//  UITableView+Placeholder.m
//  LsTableViewPlaceholder
//
//  Created by 光头强 on 16/8/3.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "UITableView+Placeholder.h"
#import <objc/runtime.h>

@interface UITableView ()
/** placeholder view */
@property (nonatomic, strong, nullable) UIView *placeholderView;
@end

@implementation UITableView (Placeholder)
- (void)ls_setPlaceholderView:(LsTableViewPlaceholderBlock)block {
    self.ls_placeholderBlock = [block copy];
    if (self.ls_placeholderBlock) {
        [self ls_placehloderSwizzling];
    }
}

- (void)ls_placehloderSwizzling {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(ls_reloadData);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)ls_reloadData {
    [self ls_reloadData];
    BOOL isEmpty = YES;
    
    id<UITableViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self];
    }
    
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
    }
    
    if(isEmpty){
        if(self.placeholderView){
            [self.placeholderView removeFromSuperview];
            self.placeholderView = nil;
        }
        //show the placeHolder view
        self.placeholderView = self.ls_placeholderBlock(self);
        if(!self.placeholderView) @throw [NSException exceptionWithName:NSGenericException
                                                                    reason:[NSString stringWithFormat:@"must return a view at the time of calling the ls_setPlaceholderView:"]
                                                                  userInfo:nil];
        self.backgroundView = self.placeholderView;
    } else{
        //remove the placeHolder from super view
        [self.placeholderView removeFromSuperview];
        self.placeholderView = nil;
        self.backgroundView = nil;
    }
}

- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (LsTableViewPlaceholderBlock)ls_placeholderBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLs_placeholderBlock:(LsTableViewPlaceholderBlock)block {
    objc_setAssociatedObject(self, @selector(ls_placeholderBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
