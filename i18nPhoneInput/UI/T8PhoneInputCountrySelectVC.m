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

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    view.text = @"   A";
    view.font = [UIFont boldSystemFontOfSize:14];
    view.textColor = [UIColor grayColor];
    view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:245.0/255 alpha:1];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    T8PhoneInputCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[T8PhoneInputCountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.countryLabel.text = @"中国";
    cell.codeLabel.text = @"+86";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
