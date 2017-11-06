//
//  UserCenterListCell.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/7.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterListCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)NSDictionary *dic;
@end
