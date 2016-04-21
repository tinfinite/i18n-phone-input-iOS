//
//  ViewController.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "ViewController.h"
#import "T8PhoneInputView.h"
#import "Masonry.h"

@interface ViewController ()<T8PhoneInputViewDelegate>

@property (strong, nonatomic) T8PhoneInputView *phoneInputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:self.phoneInputView];
    
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(60);
        make.height.equalTo(@90);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (T8PhoneInputView *)phoneInputView
{
    if (!_phoneInputView) {
        _phoneInputView = [[T8PhoneInputView alloc] init];
        _phoneInputView.delegate = self;
    }
    return _phoneInputView;
}

#pragma mark - T8PhoneInputViewDelegate
- (void)inputView:(T8PhoneInputView *)view presentSelectVC:(T8PhoneInputCountrySelectVC *)select
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:select];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
