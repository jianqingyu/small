//
//  ShoppingListTableCell.h
//  SmallTeaTre
//
//  Created by yjq on 17/9/5.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListInfo.h"
typedef void (^ShopListBack)(int staue,BOOL isSel);
@interface ShoppingListTableCell : UITableViewCell
@property (nonatomic,strong)ShoppingListInfo *listInfo;
@property (nonatomic,  copy)ShopListBack back;
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)BOOL isSel;
@end
