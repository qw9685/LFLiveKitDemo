//
//  filterView.h
//  视频功能开发
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface filterView : UIView

@property (nonatomic, copy)void(^selectBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
