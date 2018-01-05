//
//  RigisterUserInfoVc.m
//  SmallTeaTre
//
//  Created by yjq on 17/9/4.
//  Copyright © 2017年 com.medium. All rights reserved.
//

#import "RigisterUserInfoVc.h"
#import "CommonUsedTool.h"
#import "CustomChoosePhotoV.h"
#import "CustomBackgroundView.h"
#import "MainTabViewController.h"
@interface RigisterUserInfoVc ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameFie;
@property (weak, nonatomic) IBOutlet UITextField *passFie;
@property (weak, nonatomic) IBOutlet UIButton *rigisBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (nonatomic, weak) UIImage *image;
@property (assign,nonatomic) CGFloat height;
@property (nonatomic,  copy) NSString *imgUrl;
@property (weak,  nonatomic) CustomBackgroundView *baView;
@property (weak,  nonatomic) CustomChoosePhotoV *shareView;
@end

@implementation RigisterUserInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.nameFie.text = [SaveUserInfoTool shared].nickName;
    [self.headView setLayerWithW:self.headView.width/2 andColor:BordColor andBackW:0.0001];
    self.height = 135;
    [self creatBaseView];
    [self.rigisBtn setLayerWithW:4 andColor:BordColor andBackW:0.0001];
    if (self.isFir) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (IBAction)openImage:(id)sender {
    [self shareShopClick];
}

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

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rigisterClick:(UIButton *)sender {
    [self.nameFie resignFirstResponder];
    [self.passFie resignFirstResponder];
    if (self.nameFie.text.length==0) {
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    if (self.passFie.text.length<6) {
        [MBProgressHUD showError:@"密码少于6位"];
        return;
    }
    sender.enabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = _dic[@"phone"];
    params[@"mobile"] = _dic[@"phone"];
    params[@"nickName"] = self.nameFie.text;
    params[@"password"] = self.passFie.text;
    params[@"shopId"] = _dic[@"shopId"];
    if (self.imgUrl.length>0) {
        params[@"imgUrl"] = self.imgUrl;
    }
    NSString *netUrl = [NSString stringWithFormat:@"%@api/user/register/%@/%@",baseNet,_dic[@"biz"],_dic[@"code"]];
    [BaseApi postJsonData:^(BaseResponse *response, NSError *error) {
        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
            [self saveUserInfo:params and:response];
        }
        NSString *str = [YQObjectBool boolForObject:response.msg]?response.msg:@"操作成功";
        [MBProgressHUD showError:str];
        sender.enabled = YES;
    } requestURL:netUrl params:params];
}

- (void)saveUserInfo:(NSMutableDictionary *)params and:(BaseResponse *)response{
    params[@"isLog"] = @1;
    Account *account = [Account accountWithDict:params];
    //自定义类型存储用NSKeyedArchiver
    [AccountTool saveAccount:account];
    SaveUserInfoTool *save = [SaveUserInfoTool shared];
    save.id = response.result[@"id"];
    save.nickName = response.result[@"nickName"];
    save.shopId = response.result[@"shopId"];
    save.imgUrl = response.result[@"imgUrl"];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[MainTabViewController alloc]init];
    });
}

//- (void)loginUserInfo{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"loginName"] = _dic[@"phone"];
//    params[@"password"] = self.passFie.text;
//    NSString *logUrl = [NSString stringWithFormat:@"%@api/user/login",baseNet];
//    [BaseApi postGeneralData:^(BaseResponse *response, NSError *error) {
//        if ([response.code isEqualToString:@"0000"]&&[YQObjectBool boolForObject:response.result]) {
//            
//        }
//    } requestURL:logUrl params:params];
//}

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
    NSString *userId = @"-1";
    NSString *url = [NSString stringWithFormat:@"%@/api/user/head_img/upload/%@",baseNet,userId];
    [CommonUsedTool loadUpDate:^(NSDictionary *response, NSError *error) {
        if ([response[@"code"] isEqualToString:@"0000"]) {
            if ([YQObjectBool boolForObject:response[@"result"]]) {
                self.imgUrl = response[@"result"][@"imgUrl"];
            }
        }
    } image:image Dic:params Url:url];
}

@end
