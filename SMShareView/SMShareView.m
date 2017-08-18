//
//  SMShareView.m
//  SMShareView
//
//  Created by Siman on 2017/8/15.
//  Copyright © 2017年 Siman. All rights reserved.
//

#import "SMShareView.h"
#import "UIColor+HNExtensions.h"
#import "UIImage+Category.h"

#define SM_HEX_COLOR(HexString)     [UIColor colorForHexString:HexString]

#define SM_COLOR_RGB(r,g,b)         [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define SM_COLOR_SECTION            SM_COLOR_RGB(239, 239, 244)

#define W_SCREEN                    [UIScreen mainScreen].bounds.size.width     // 屏幕宽

#define H_SCREEN                    [UIScreen mainScreen].bounds.size.height    // 屏幕高

/*---------------------------------  SMShareItemModel  --------------------------------*/

@interface SMShareItemModel : NSObject
@property (copy , nonatomic)    NSString    *icon;
@property (copy , nonatomic)    NSString    *title;
@property (assign , nonatomic)  SMShareType shareType;
@end

@implementation SMShareItemModel
@end

/*---------------------------------  SMShareViewCollectionCell  --------------------------------*/

@interface SMShareViewCollectionCell : UICollectionViewCell
@property (strong , nonatomic)SMShareItemModel *itemModel;
@end

@interface SMShareViewCollectionCell ()
@property (strong , nonatomic)UIImageView *imgView;
@property (strong , nonatomic)UILabel *nameLabel;
@end

@implementation SMShareViewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_imgView]-30-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_imgView)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[_imgView]-7-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_imgView)]];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.textColor = SM_HEX_COLOR(@"#535455");
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.text = @"分享到朋友圈";
        [self.contentView addSubview:_nameLabel];
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imgView]-6-[_nameLabel(_nameLabel)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_imgView,_nameLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_nameLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_nameLabel)]];

    }
    return self;
}

- (void)setItemModel:(SMShareItemModel *)itemModel {
    self.imgView.image = [UIImage imageNamed:itemModel.icon];
    self.nameLabel.text = itemModel.title;
}
@end

/*---------------------------------  SMShareView  --------------------------------*/

@interface SMShareView ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong , nonatomic)  UIView                      *popView;
@property (strong , nonatomic)  UICollectionView            *topCollectView;
@property (nonatomic, strong)   UICollectionViewFlowLayout  *topFlowLayout;
@property (strong , nonatomic)  UICollectionViewFlowLayout  *bottomFlowLayout;
@property (strong , nonatomic)  UICollectionView            *bottomColloectView;

@property (strong , nonatomic)  NSMutableArray              *topItemArray;

@property (strong , nonatomic)  NSMutableArray              *bottomItemArray;

@property (copy , nonatomic)void(^selectShareType)(SMShareType);

@end

static CGFloat const SMShreViewHeight = 270.f;
static CGFloat const SMShreCancelHeight = 46.f;
static NSString *const SMShareViewCellIdentifier = @"SMShareViewCellIdentifier";

@implementation SMShareView

- (void)dealloc {
    NSLog(@"dealloc -> %@",NSStringFromClass([self class]));
}

- (NSMutableArray *)topItemArray {
    if (nil == _topItemArray) { _topItemArray = [[NSMutableArray alloc] init]; } return _topItemArray;
}

- (NSMutableArray *)bottomItemArray {
    if (nil == _bottomItemArray) { _bottomItemArray = [[NSMutableArray alloc] init]; } return _bottomItemArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgButton setFrame:CGRectMake(0, 0, W_SCREEN, H_SCREEN)];
        [bgButton setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [bgButton addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, H_SCREEN, W_SCREEN, SMShreViewHeight)];
        self.popView.backgroundColor = SM_COLOR_SECTION;
        [self addSubview:_popView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, SMShreViewHeight - SMShreCancelHeight, W_SCREEN, SMShreCancelHeight)];
        [cancelButton setTitleColor:SM_HEX_COLOR(@"#353535") forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelButton setBackgroundImage:[UIImage createImageWithColor:SM_HEX_COLOR(@"#ffffff")] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:cancelButton];
        
        CGFloat wShareCell = 74;
        CGFloat hShareCell = 90;
        
        _topFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _topFlowLayout.itemSize = CGSizeMake(wShareCell, hShareCell);
        _topFlowLayout.minimumLineSpacing = 6;
        _topFlowLayout.minimumInteritemSpacing = 6;
        _topFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向排布
        _topFlowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 4, 8);
        _topCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, W_SCREEN, (SMShreViewHeight - SMShreCancelHeight - 20)/2) collectionViewLayout:_topFlowLayout];
        _topCollectView.backgroundColor = [UIColor clearColor];
        [self.popView addSubview:_topCollectView];
        _topCollectView.showsHorizontalScrollIndicator = NO;
        _topCollectView.showsVerticalScrollIndicator = NO;
        _topCollectView.alwaysBounceHorizontal = YES;    //允许水平方向滑动
        _topCollectView.alwaysBounceVertical = NO;     //允许纵向滑动
        _topCollectView.dataSource = self;
        _topCollectView.delegate = self;
        _topCollectView.bounces = YES;
        //注册cell
        [_topCollectView registerClass:[SMShareViewCollectionCell class] forCellWithReuseIdentifier:SMShareViewCellIdentifier];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topCollectView.frame) + 10, H_SCREEN, .5)];
        line.backgroundColor = SM_HEX_COLOR(@"#DDDDDE");
        [self.popView addSubview:line];
        
        _bottomFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bottomFlowLayout.itemSize =  CGSizeMake(wShareCell, hShareCell);
        _bottomFlowLayout.minimumLineSpacing = 6;
        _bottomFlowLayout.minimumInteritemSpacing = 6;
        _bottomFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//横向排布
        _bottomFlowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 4, 8);
        _bottomColloectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topCollectView.frame) + 10, W_SCREEN, (SMShreViewHeight - SMShreCancelHeight - 20)/2) collectionViewLayout:_bottomFlowLayout];
        _bottomColloectView.backgroundColor = [UIColor clearColor];
        [self.popView addSubview:_bottomColloectView];
        _bottomColloectView.showsHorizontalScrollIndicator = NO;
        _bottomColloectView.showsVerticalScrollIndicator = NO;
        _bottomColloectView.alwaysBounceHorizontal = YES;    //允许水平方向滑动
        _bottomColloectView.alwaysBounceVertical = NO;     //允许纵向滑动
        _bottomColloectView.dataSource = self;
        _bottomColloectView.delegate = self;
        _bottomColloectView.bounces = YES;
        
        [_bottomColloectView registerClass:[SMShareViewCollectionCell class] forCellWithReuseIdentifier:SMShareViewCellIdentifier];
    }
    return self;
}

- (void)bgButtonClick:(UIButton *)button {
    
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.popView.frame = CGRectMake(0, H_SCREEN, W_SCREEN, SMShreCancelHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelButtonAction:(UIButton *)button {
    [self bgButtonClick:nil];
}


- (void)showShareViewWithCancel:(void(^)(void))cancel
                         finish:(void(^)(SMShareType shareType))finishBlock {
    
    [self setUpPlatformsItems];
    
    [self setUpBottomItems];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    self.selectShareType = finishBlock;
    [self.topCollectView reloadData];
    [self.bottomColloectView reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.popView.frame = CGRectMake(0, H_SCREEN - SMShreViewHeight, W_SCREEN, SMShreViewHeight);
    }];
}

#pragma mark 设置平台
- (void)setUpPlatformsItems {
    [self.topItemArray removeAllObjects];
    
    SMShareItemModel *wechatSessionModel = [[SMShareItemModel alloc] init];
    wechatSessionModel.icon = @"share_weixin_session";
    wechatSessionModel.shareType = SMShareTypeWechatSession;
    wechatSessionModel.title = @"分享给微信好友";
    [self.topItemArray addObject:wechatSessionModel];
#warning 为了应对苹果的审核规则，这里必须检测分享的平台是否安装，如果有安装就加入数组，如果没有安装就隐藏。这里用的UMeng分享SDK来判断，需要注意的是要在info.plist文件里配置平台的白名单
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
//        [self.topItemArray addObject:wechatSessionModel];
//    }
    
    SMShareItemModel *wechatTimeLineModel = [[SMShareItemModel alloc] init];
    wechatTimeLineModel.icon = @"share_weixin_timeline";
    wechatTimeLineModel.shareType = SMShareTypeWechatTimeline;
    wechatTimeLineModel.title = @"分享到微信朋友圈";
    [self.topItemArray addObject:wechatTimeLineModel];
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
//        [self.topItemArray addObject:wechatTimeLineModel];
//    }
    
    SMShareItemModel *sinaModel = [[SMShareItemModel alloc] init];
    sinaModel.icon = @"share_sina";
    sinaModel.shareType = SMShareTypeSina;
    sinaModel.title = @"分享到新浪微博";
    [self.topItemArray addObject:sinaModel];
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
//        [self.topItemArray addObject:sinaModel];
//    }
    
    SMShareItemModel *qqModel = [[SMShareItemModel alloc] init];
    qqModel.icon = @"share_qq";
    qqModel.shareType = SMShareTypeQQ;
    qqModel.title = @"分享到手机QQ";
    [self.topItemArray addObject:qqModel];
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
//        [self.topItemArray addObject:qqModel];
//    }
    
    SMShareItemModel *qqZone = [[SMShareItemModel alloc] init];
    qqZone.icon = @"share_qzone";
    qqZone.shareType = SMShareTypeQzone;
    qqZone.title = @"分享到QQ空间";
    [self.topItemArray addObject:qqZone];
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
//        [self.topItemArray addObject:qqZone];
//    }
    
    SMShareItemModel *alipayModel = [[SMShareItemModel alloc] init];
    alipayModel.icon = @"share_alipay";
    alipayModel.shareType = SMShareTypeAlipaySession;
    alipayModel.title = @"分享给支付宝好友";
    [self.topItemArray addObject:alipayModel];
//    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_AlipaySession]) {
//        [self.topItemArray addObject:alipayModel];
//    }
    
    SMShareItemModel *smsModel = [[SMShareItemModel alloc] init];
    smsModel.icon = @"share_sms";
    smsModel.shareType = SMShareTypeSms;
    smsModel.title = @"短信分享";
    [self.topItemArray addObject:smsModel];
    
    SMShareItemModel *emailModel = [[SMShareItemModel alloc] init];
    emailModel.icon = @"share_email";
    emailModel.shareType = SMShareTypeEmail;
    emailModel.title = @"邮件分享";
    [self.topItemArray addObject:emailModel];
    
}

- (void)setUpBottomItems {
    [self.bottomItemArray removeAllObjects];
    
    SMShareItemModel *collectItem = [[SMShareItemModel alloc] init];
    collectItem.title = @"收藏";
    collectItem.icon = @"collect_icon";
    collectItem.shareType = SMShareTypeCollect;
    [self.bottomItemArray addObject:collectItem];
    
    SMShareItemModel *refreshItem = [[SMShareItemModel alloc] init];
    refreshItem.title = @"刷新";
    refreshItem.icon = @"refresh_icon";
    refreshItem.shareType = SMShareTypeRefresh;
    [self.bottomItemArray addObject:refreshItem];
    
    SMShareItemModel *urlModel = [[SMShareItemModel alloc] init];
    urlModel.icon = @"share_url";
    urlModel.shareType = SMShareTypeUrl;
    urlModel.title = @"复制链接";
    [self.bottomItemArray addObject:urlModel];
    
    SMShareItemModel *complaintItem = [[SMShareItemModel alloc] init];
    complaintItem.title = @"投诉";
    complaintItem.icon = @"complaint_icon";
    complaintItem.shareType = SMShareTypeComplaint;
    [self.bottomItemArray addObject:complaintItem];
}

#pragma mark --------------UICollectionViewDelegate dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView == _topCollectView ? [self.topItemArray count] : [self.bottomItemArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMShareViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SMShareViewCellIdentifier forIndexPath:indexPath];
    cell.itemModel = collectionView == _topCollectView ? self.topItemArray[indexPath.row] : self.bottomItemArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SMShareItemModel *model = collectionView == _topCollectView ? self.topItemArray[indexPath.row] : self.bottomItemArray[indexPath.row];
    !self.selectShareType ? : self.selectShareType(model.shareType);
    [self bgButtonClick:nil];
}

@end
