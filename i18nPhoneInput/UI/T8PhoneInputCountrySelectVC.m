//
//  T8PhoneInputCountrySelectVC.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "T8PhoneInputCountrySelectVC.h"
#import "T8PhoneInputCountryDefaultDataSource.h"
#import "T8PhoneInputCountryCell.h"

@interface T8PhoneInputCountrySelectVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<T8PhoneInputCountryDataSource> dataSource;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *sectionKeys;
@property (strong, nonatomic) NSMutableDictionary *classifyDict;

@end

@implementation T8PhoneInputCountrySelectVC

- (id)init
{
    self = [self initWithDataSource:[[T8PhoneInputCountryDefaultDataSource alloc] init]];
    if (self) {
        
    }
    return self;
}

- (id)initWithDataSource:(id<T8PhoneInputCountryDataSource>)dataSource
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavigation];
    
    [self prepareData];
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - method
- (void)setUpNavigation
{
    self.title = @"选择国家和地区";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareData
{
    [self.dataArray addObjectsFromArray:[self.dataSource getAllCountryModels]];
    [self classifyData];
}

- (void)classifyData
{
    //初始化数据结构
    NSMutableArray *letters = [@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]mutableCopy];
    for (NSString *letter in letters) {
        self.classifyDict[letter] = [NSMutableArray array];
    }
    
    //分类
    [self.dataArray enumerateObjectsUsingBlock:^(T8PhoneInputCountryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *firstLetter = @"#";
        if ([obj t8_country_name_zh_pinyin].length > 0) {
            firstLetter = [[[obj t8_country_name_zh_pinyin] substringToIndex:1] uppercaseString];
        }
        [self.classifyDict[firstLetter] addObject:obj];
    }];
    
    //排序 & 清理空的分组
    NSMutableArray *emptyKeys = [NSMutableArray array];
    [self.classifyDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.count == 0) {
            [emptyKeys addObject:key];
        }else{
            [obj sortUsingComparator:^NSComparisonResult(T8PhoneInputCountryModel * _Nonnull obj1, T8PhoneInputCountryModel * _Nonnull obj2) {
                return [[obj1 t8_country_name_zh_pinyin] compare:[obj2 t8_country_name_zh_pinyin]];
            }];
        }
    }];
    [letters removeObjectsInArray:emptyKeys];
    [self.classifyDict removeObjectsForKeys:emptyKeys];
    
    self.sectionKeys = letters;
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)sectionKeys
{
    if (!_sectionKeys) {
        _sectionKeys = [NSMutableArray array];
    }
    return _sectionKeys;
}

- (NSMutableDictionary *)classifyDict
{
    if (!_classifyDict) {
        _classifyDict = [NSMutableDictionary dictionary];
    }
    return _classifyDict;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.sectionKeys[section];
    NSArray *array = self.classifyDict[key];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] init];
    view.text = [NSString stringWithFormat:@"   %@", self.sectionKeys[section]];
    view.font = [UIFont boldSystemFontOfSize:14];
    view.textColor = [UIColor grayColor];
    view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:245.0/255 alpha:1];
    view.backgroundColor = [UIColor colorWithRed:226.0/255 green:226.0/255 blue:226.0/255 alpha:1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    T8PhoneInputCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[T8PhoneInputCountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *key = self.sectionKeys[indexPath.section];
    NSArray *array = self.classifyDict[key];
    T8PhoneInputCountryModel *model = array[indexPath.row];
    cell.countryLabel.text = [model t8_country_name_zh];
    cell.codeLabel.text = [NSString stringWithFormat:@"+%@", [model t8_country_code]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
