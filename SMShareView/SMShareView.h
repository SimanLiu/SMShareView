//
//  SMShareView.h
//  SMShareView
//
//  Created by Siman on 2017/8/15.
//  Copyright © 2017年 Siman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , SMShareType) {
    SMShareTypeWechatSession    = 1,               //微信好友
    SMShareTypeWechatTimeline   = 2,               //微信朋友圈
    SMShareTypeSina             = 3,               //新浪微博
    SMShareTypeQQ               = 4,               //QQ好友
    SMShareTypeQzone            = 5,               //QQ空间
    SMShareTypeAlipaySession    = 6,               //支付宝好友
    SMShareTypeSms              = 7,               //短信
    SMShareTypeEmail            = 8,               //邮箱
    SMShareTypeCollect          = 9,               //收藏
    SMShareTypeRefresh          = 10,              //刷新
    SMShareTypeUrl              = 11,              //链接
    SMShareTypeComplaint        = 12,              //投诉
};

@interface SMShareView : UIView

- (void)showShareViewWithCancel:(void(^)(void))cancel
                         finish:(void(^)(SMShareType shareType))finishBlock;

@end
