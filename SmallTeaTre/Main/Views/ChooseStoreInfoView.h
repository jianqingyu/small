//
//  ChooseStoreInfoView.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChStoInfoBack)(NSDictionary *store,BOOL isSel);
@interface ChooseStoreInfoView : UIView
+ (ChooseStoreInfoView *)createLoginView;
@property (nonatomic, copy)ChStoInfoBack storeBack;
@property (nonatomic, copy)NSString *areaCode;
@end
