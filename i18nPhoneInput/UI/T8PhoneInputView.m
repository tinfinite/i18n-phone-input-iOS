//
//  T8PhoneInputView.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "T8PhoneInputView.h"
#import "Masonry.h"
#import "T8PhoneInputCountryDefaultDataSource.h"

@interface T8PhoneInputView ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *lineHor;
@property (strong, nonatomic) UIView *lineVer;

@property (strong, nonatomic) T8PhoneInputCountryDefaultDataSource *dataSource;

@end

@implementation T8PhoneInputView

- (id)init
{
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.lineHor];
        [self addSubview:self.lineVer];
        [self addSubview:self.infoLabel];
        [self addSubview:self.countryButton];
        [self addSubview:self.arrowView];
        [self addSubview:self.codeTextField];
        [self addSubview:self.numberTextField];
        
        [self.lineHor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        [self.lineVer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineHor.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(@0.5);
            make.left.equalTo(@105);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@45);
            make.width.equalTo(@105);
        }];
        [self.countryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-40);
            make.left.equalTo(self.infoLabel.mas_right);
            make.top.equalTo(self);
            make.height.equalTo(@45);
        }];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-14);
            make.centerY.equalTo(self.countryButton);
        }];
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoLabel);
            make.right.equalTo(self.infoLabel);
            make.top.equalTo(self.infoLabel.mas_bottom);
            make.bottom.equalTo(self);
        }];
        [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.codeTextField.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self.countryButton.mas_bottom);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - method
- (void)countryButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:presentSelectVC:)]) {
        T8PhoneInputCountrySelectVC *select = [[T8PhoneInputCountrySelectVC alloc] initWithDataSource:self.dataSource];
        __weak typeof(self) weakSelf = self;
        select.doneBlock = ^(T8PhoneInputCountryModel *country){
            weakSelf.codeTextField.text = [NSString stringWithFormat:@"+%@", [country t8_country_code]];
            [weakSelf.countryButton setTitle:[country t8_country_name_zh] forState:UIControlStateNormal];
        };
        [self.delegate inputView:self presentSelectVC:select];
    }
}

- (void)refreshStatus
{
    NSString *code = [self.codeTextField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    T8PhoneInputCountryModel *country = [self.dataSource getModelWithCode:code];
    if (country) {
        [self.countryButton setTitle:[country t8_country_name_zh] forState:UIControlStateNormal];
    }else{
        [self.countryButton setTitle:@"国家代码无效" forState:UIControlStateNormal];
    }
}

#pragma mark - getter
- (UIView *)lineHor
{
    if (!_lineHor) {
        _lineHor = [[UIView alloc] init];
        _lineHor.backgroundColor = T8PhoneInputLineColor;
    }
    return _lineHor;
}

- (UIView *)lineVer
{
    if (!_lineVer) {
        _lineVer = [[UIView alloc] init];
        _lineVer.backgroundColor = T8PhoneInputLineColor;
    }
    return _lineVer;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = T8PhoneInputNormalColor;
        _infoLabel.font = [UIFont systemFontOfSize:17];
        _infoLabel.text = @"国家/地区";
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}

- (UIButton *)countryButton
{
    if (!_countryButton) {
        _countryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _countryButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _countryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_countryButton setTitle:@"中国" forState:UIControlStateNormal];
        [_countryButton setTitleColor:T8PhoneInputNormalColor forState:UIControlStateNormal];
        [_countryButton addTarget:self action:@selector(countryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countryButton;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"item_arrow_right@2x" ofType:@"png"]];
    }
    return _arrowView;
}

- (UITextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.font = [UIFont systemFontOfSize:17];
        _codeTextField.textColor = T8PhoneInputLightColor;
        _codeTextField.textAlignment = NSTextAlignmentCenter;
        _codeTextField.delegate = self;
        _codeTextField.text = @"+86";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

- (UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.placeholder = @"请填写手机号码";
        _numberTextField.textColor = T8PhoneInputNormalColor;
        _numberTextField.font = [UIFont systemFontOfSize:17];
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numberTextField;
}

- (NSString *)codeStr
{
    return self.codeTextField.text;
}

- (NSString *)numberStr
{
    return self.numberTextField.text;
}

- (T8PhoneInputCountryDefaultDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[T8PhoneInputCountryDefaultDataSource alloc] init];
    }
    return _dataSource;
}

#pragma mark - setter
- (void)setCodeStr:(NSString *)codeStr
{
    self.codeTextField.text = codeStr;
}

- (void)setNumberStr:(NSString *)numberStr
{
    self.numberTextField.text = numberStr;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *oldText = textField.text;
    NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > 5) {
        return NO;
    }
    if (![newText hasPrefix:@"+"]) {
        newText = [@"+" stringByAppendingString:newText];
    }
    textField.text = newText;
    [self refreshStatus];
    return NO;
}

@end
