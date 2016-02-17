//
//  T8PhoneInputCountrySelectVC.h
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T8PhoneInputCountryDataSource.h"

@interface T8PhoneInputCountrySelectVC : UIViewController

@property (strong, nonatomic) UITableView *tableView;

- (id)initWithDataSource:(id<T8PhoneInputCountryDataSource>)dataSource;

@end
