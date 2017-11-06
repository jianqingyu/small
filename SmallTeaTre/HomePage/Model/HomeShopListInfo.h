//
//  HomeShopListInfo.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/18.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelInfo.h"
@interface HomeShopListInfo : BaseModelInfo
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *createTime;

@end
