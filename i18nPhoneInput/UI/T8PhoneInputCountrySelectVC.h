//
//  T8PhoneInputCountrySelectVC.h
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "T8PhoneInputCountryDataSource.h"

@class T8PhoneInputCountryModel;

typedef void(^T8PhoneInputCountrySelectDoneBlock)(T8PhoneInputCountryModel *country);

@interface T8PhoneInputCountrySelectVC : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) T8PhoneInputCountrySelectDoneBlock doneBlock;

- (id)initWithDataSource:(id<T8PhoneInputCountryDataSource>)dataSource;

@end
