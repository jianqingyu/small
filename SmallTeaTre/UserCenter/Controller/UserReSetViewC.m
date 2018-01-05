//
//  UserReSetViewC.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "UserReSetViewC.h"
#import "CommonUsedTool.h"
#import "UserEditNameVC.h"
#import "CustomChoosePhotoV.h"
#import "UserEditPasswordVC.h"
#import "CustomBackgroundView.h"
@interface UserReSetViewC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (assign,nonatomic) CGFloat height;
@property (weak,  nonatomic) CustomChoosePhotoV *shareView;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,  copy)NSString *url;
@end

@implementation UserReSetViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.height = 135;
    [self.headView setLayerWithW:45 andColor:[UIColor whiteColor] andBackW:2];
    [self creatBaseView];
    [self loadHomeData];
}
#pragma mark -- 上传头像
- (void)creatBaseView{
    CustomBackgroundView *bView = [CustomBackgroundView createBackView];
    bView.hidden = YES;
    [self.view addSubview:bView];
    [bView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = bView;
    
    CustomChoosePhotoV *infoV = [CustomChoosePhotoV creatCustomView];
    infoV.picBack = ^(NSInteger staue){
        switch (staue) {
            case 0:
                [self openAlbum];
                break;
            case 1:
                [self openCamera];
                break;
            default:
                [self changeStoreView:YES];
                break;
        }
    };
    [self.view addSubview:infoV];
    [infoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(self.height);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(135);
    }];
    self.shareView = infoV;
}

- (void)shareShopClick {
    [self changeStoreView:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeStoreView:YES];
}

- (void)changeStoreView:(BOOL)isClose{
    BOOL isHi = YES;
    if (self.height==135) {
        if (isClose) {
            return;
        }
        self.height = 0;
        isHi = NO;
    }else{
        self.height = 135;
        isHi = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(self.height);
        }];
        [self.shareView layoutIfNeeded];//强制绘制
        self.baView.hidden = isHi;
    }];
}

- (void)loadHomeData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId;
    if ([[SaveUserInfoTool shared].id isKindOfClass:[NSString class]]) {
        userId = [SaveUserInfoTool shared].id;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/info/%@",baseNet,userId];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self setBaseView:response.result];
        }else{
            NSString *str = response.msg?response.msg:@"查询失败";
            [MBProgressHUD showError:str];
        }
    } requestURL:netUrl params:params];
}

- (void)setBaseView:(NSDictionary *)dic{
    NSString *url = [SaveUserInfoTool shared].imgUrl;
    if ([YQObjectBool boolForObject:url]) {
        if (![url containsString:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",baseNet,url];
        }
        [self.headView sd_setImageWithURL:[NSURL URLWithString:url]
                         placeholderImage:DefaultHead];
    }
    self.phoneLab.text = dic[@"mobile"];
    self.nameLab.text = dic[@"nickName"];
}

- (IBAction)openImage:(id)sender {
    [self shareShopClick];
}

- (IBAction)editName:(id)sender {
    UserEditNameVC *editName = [UserEditNameVC new];
    editName.back = ^(BOOL isYes){
        [self loadHomeData];
    };
    [self.navigationController pushViewController:editName animated:YES];
}

- (IBAction)editPass:(id)sender {
    UserEditPasswordVC *editPass = [UserEditPasswordVC new];
    [self.navigationController pushViewController:editPass animated:YES];
}

//打开相机
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
//打开相册
//TypePhotoLibrary > TypeSavedPhotosAlbum
- (void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
//通过imagePickerController获取图片
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:ipc animated:YES completion:nil];
        [self changeStoreView:YES];
    }];
}

#pragma mark -- UIImagePickerControllerDelagate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //info中包含选择的图片 UIImagePickerControllerOriginalImage
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        self.headView.image = image;
        [self loadUpDateImage:image];
    }];
}
//上传图片
- (void)loadUpDateImage:(UIImage *)image{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [SaveUserInfoTool shared].id;
    if (userId.length==0) {
        userId = @"-1";
    }
    NSString *url = [NSString stringWithFormat:@"%@/api/user/head_img/upload/%@",baseNet,userId];
    [CommonUsedTool loadUpDate:^(NSDictionary *response, NSError *error) {
        if ([response[@"code"] isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response[@"result"]]) {
                SaveUserInfoTool *save = [SaveUserInfoTool shared];
                save.imgUrl = response[@"result"][@"imgUrl"];
            }
        }
    } image:image Dic:params Url:url];
}

@end
