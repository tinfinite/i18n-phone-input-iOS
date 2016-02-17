//
//  T8PhoneInputCountryCell.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/17.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "T8PhoneInputCountryCell.h"
#import "Masonry.h"
#import "T8PhoneInputCommon.h"

@implementation T8PhoneInputCountryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:243.0/255 alpha:1];
        
        [self addSubview:self.countryLabel];
        [self addSubview:self.codeLabel];
        
        [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self);
        }];
        [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-30));
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

#pragma mark - getter
- (UILabel *)countryLabel
{
    if (!_countryLabel) {
        _countryLabel = [[UILabel alloc] init];
        _countryLabel.textColor = T8PhoneInputNormalColor;
        _countryLabel.font = [UIFont systemFontOfSize:16];
    }
    return _countryLabel;
}

- (UILabel *)codeLabel
{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = T8PhoneInputLightColor;
        _codeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _codeLabel;
}

@end
