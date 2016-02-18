//
//  T8PhoneInputView.h
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T8PhoneInputCommon.h"
#import "T8PhoneInputCountrySelectVC.h"

@class T8PhoneInputView;

@protocol T8PhoneInputViewDelegate <NSObject>

- (void)inputView:(T8PhoneInputView *)view presentSelectVC:(T8PhoneInputCountrySelectVC *)select;

@end

@interface T8PhoneInputView : UIView

@property (weak, nonatomic) id<T8PhoneInputViewDelegate> delegate;

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *countryButton;
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UITextField *numberTextField;

@property (strong, nonatomic) NSString *codeStr;
@property (strong, nonatomic) NSString *numberStr;

@end
