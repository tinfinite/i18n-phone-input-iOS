//
//  T8PhoneInputCountryModel.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "T8PhoneInputCountryModel.h"

@interface T8PhoneInputCountryModel ()

@property (strong, nonatomic) NSString *countryKey;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *countryNameEn;
@property (strong, nonatomic) NSString *countryNameZh;
@property (strong, nonatomic) NSString *countryNameZhPinyin;

@end

@implementation T8PhoneInputCountryModel

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.countryKey = [dict objectForKey:@"key"];
        self.countryCode = [dict objectForKey:@"code"];
        self.countryNameEn = [dict objectForKey:@"nameEn"];
        self.countryNameZh = [dict objectForKey:@"nameZh"];
        self.countryNameZhPinyin = [dict objectForKey:@"nameZhPinYin"];
        
    }
    return self;
}

#pragma mark - T8PhoneInputCountryModelProtocol
- (NSString *)t8_country_key
{
    return self.countryKey;
}

- (NSString *)t8_country_code
{
    return self.countryCode;
}

- (NSString *)t8_country_name_en
{
    return self.countryNameEn;
}

- (NSString *)t8_country_name_zh
{
    return self.countryNameZh;
}

- (NSString *)t8_country_name_zh_pinyin
{
    return self.countryNameZhPinyin;
}

@end
