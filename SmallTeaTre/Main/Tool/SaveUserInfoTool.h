//
//  SaveUserInfoTool.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/19.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveUserInfoTool : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,copy)NSString *shopId;
@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,assign)BOOL isQQ;
@property (nonatomic,copy)NSString *openId;
@property (nonatomic,assign)BOOL haveLog;
+ (instancetype)shared;
- (void)clearAllData;
@end
