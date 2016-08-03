//
//  UITableView+Placeholder.h
//  LsTableViewPlaceholder
//
//  Created by 光头强 on 16/8/3.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef UIView * _Nonnull (^LsTableViewPlaceholderBlock)(UITableView * _Nonnull tableView);
@interface UITableView (Placeholder)
/**
 *  @param block  After call the block must return a view, as the tableView's placeHolder view.
 */
- (void)ls_setPlaceholderView:(_Nullable LsTableViewPlaceholderBlock)block;
@end
