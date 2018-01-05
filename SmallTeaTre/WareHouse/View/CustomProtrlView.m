//
//  CustomProtrlView.m
//  SmallTeaTre
//
//  Created by 余建清 on 2017/11/28.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "CustomProtrlView.h"
@interface CustomProtrlView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *baView;
@end

@implementation CustomProtrlView

+ (id)creatCustomView{
    CustomProtrlView *headView = [[CustomProtrlView alloc]init];
    return headView;
}

- (id)init{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomProtrlView" owner:nil options:nil][0];
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        [self.baView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    if (titleStr) {
        _titleStr = titleStr;
        self.titleLab.text = _titleStr;
    }
}

- (void)setStr:(NSString *)str{
    if (str) {
        _str = str;
        NSDictionary *dic = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithData:
        [_str dataUsingEncoding:NSUnicodeStringEncoding] options:dic
                                            documentAttributes:nil error:nil];
        self.textView.attributedText = attStr;
    }
}

- (IBAction)nextClick:(id)sender {
    if (self.back) {
        self.back(YES);
    }
}

@end
