//
//  T8PhoneInputCountryModel.h
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "T8PhoneInputCountryModelProtocol.h"

@interface T8PhoneInputCountryModel : NSObject<T8PhoneInputCountryModelProtocol>

- (id)initWithDict:(NSDictionary *)dict;

@end
