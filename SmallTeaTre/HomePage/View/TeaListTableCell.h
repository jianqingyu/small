//
//  TeaListTableCell.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/1.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListInfo.h"
typedef void (^HomeTeaBack)(int staue,BOOL isSel);
@interface TeaListTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,  copy)HomeTeaBack back;
@property (nonatomic,strong)ShoppingListInfo *listInfo;
@end
