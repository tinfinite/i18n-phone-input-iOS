//
//  T8PhoneInputCountryDefaultDataSource.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "T8PhoneInputCountryDefaultDataSource.h"

@interface T8PhoneInputCountryDefaultDataSource ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation T8PhoneInputCountryDefaultDataSource

- (id)init
{
    self = [super init];
    if (self) {
        
        [self prepareData];
        
    }
    return self;
}

- (void)prepareData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryAndCode" ofType:@"txt"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        T8PhoneInputCountryModel *model = [[T8PhoneInputCountryModel alloc] initWithDict:obj];
        [self.dataArray addObject:model];
    }];
}

#pragma mark - getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - T8PhoneInputCountryDataSource
- (NSArray *)getAllCountryModels
{
    return [self.dataArray mutableCopy];
}

- (NSArray *)searchCountryModelsWithKey:(NSString *)key
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"(t8_country_name_zh CONTAINS[cd] %@ OR t8_country_name_zh_pinyin CONTAINS[cd] %@)", key, key];
    NSArray *searchResult = [self.dataArray filteredArrayUsingPredicate:pre];
    return [searchResult mutableCopy];
}

- (id)getModelWithCode:(NSString *)code
{
    __block T8PhoneInputCountryModel *country = nil;
    [self.dataArray enumerateObjectsUsingBlock:^(T8PhoneInputCountryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj t8_country_code] isEqualToString:code]) {
            country = obj;
            *stop = YES;
        }
    }];
    return country;
}

@end
