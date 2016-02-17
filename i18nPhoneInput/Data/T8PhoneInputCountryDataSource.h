//
//  T8PhoneInputCountryDataSource.h
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef T8PhoneInputCountryDataSource_h
#define T8PhoneInputCountryDataSource_h

@protocol T8PhoneInputCountryDataSource <NSObject>

- (NSArray *)getAllCountryModels;
- (NSArray *)searchCountryModelsWithKey:(NSString *)key;

@end

#endif /* T8PhoneInputCountryDataSource_h */
