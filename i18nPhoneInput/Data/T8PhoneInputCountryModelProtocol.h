//
//  T8PhoneInputCountryModelProtocol.h
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#ifndef T8PhoneInputCountryModelProtocol_h
#define T8PhoneInputCountryModelProtocol_h

@protocol T8PhoneInputCountryModelProtocol <NSObject>

- (NSString *)t8_country_key;
- (NSString *)t8_country_code;
- (NSString *)t8_country_name_en;
- (NSString *)t8_country_name_zh;

@end

#endif /* T8PhoneInputCountryModelProtocol_h */
