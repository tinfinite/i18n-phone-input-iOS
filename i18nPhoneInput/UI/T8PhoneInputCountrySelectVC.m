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
#import "T8LetterIndexNavigationView.h"

@interface T8PhoneInputCountrySelectVC ()<UITableViewDelegate, UITableViewDataSource, T8LetterIndexNavigationViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) id<T8PhoneInputCountryDataSource> dataSource;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *sectionKeys;
@property (strong, nonatomic) NSMutableDictionary *classifyDict;
@property (strong, nonatomic) NSMutableArray *searchArray;

@property (strong, nonatomic) T8LetterIndexNavigationView *letterIndexView;

@property (strong, nonatomic) UISearchController *searchController;

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
    self.tableView.separatorColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    
    [self setUpNavigation];
    
    [self prepareData];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.letterIndexView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
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
    NSMutableArray *letters = [@[@"*",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]mutableCopy];
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
        
        if ([[obj t8_country_key] isEqualToString:@"CN"]) {
            [self.classifyDict[@"*"] addObject:obj];
        }
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
    self.letterIndexView.keys = letters;
}

- (void)searchDone
{
    self.searchController.searchBar.text = nil;
    self.searchController.active = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (T8LetterIndexNavigationView *)letterIndexView
{
    if (!_letterIndexView) {
        _letterIndexView = [[T8LetterIndexNavigationView alloc] init];
        _letterIndexView.frame = CGRectMake(self.tableView.frame.origin.x+self.tableView.frame.size.width-20, self.tableView.frame.origin.y+64, 20, self.tableView.frame.size.height-64);
        _letterIndexView.isNeedSearchIcon = NO;
        _letterIndexView.delegate = self;
    }
    return _letterIndexView;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        UITableViewController *searchResult = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        searchResult.tableView.delegate = self;
        searchResult.tableView.dataSource = self;
        searchResult.view.backgroundColor = [UIColor whiteColor];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResult];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0f);
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.layer.borderWidth = 1;
        _searchController.searchBar.layer.borderColor = [[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1] CGColor];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.sectionKeys.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        NSString *key = self.sectionKeys[section];
        NSArray *array = self.classifyDict[key];
        return array.count;
        
    }else{
        return self.searchArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 0.1f;
        }
        return 23.0f;
    }else{
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        UILabel *view = [[UILabel alloc] init];
        view.text = [NSString stringWithFormat:@"    %@", self.sectionKeys[section]];
        view.font = [UIFont boldSystemFontOfSize:16];
        view.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
        return view;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    T8PhoneInputCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[T8PhoneInputCountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    T8PhoneInputCountryModel *model = nil;
    if (tableView == self.tableView) {
        NSString *key = self.sectionKeys[indexPath.section];
        NSArray *array = self.classifyDict[key];
        model = array[indexPath.row];
    }else{
        model = self.searchArray[indexPath.row];
    }
    cell.countryLabel.text = [model t8_country_name_zh];
    cell.codeLabel.text = [NSString stringWithFormat:@"+%@", [model t8_country_code]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    T8PhoneInputCountryModel *model = nil;
    if (tableView == self.tableView) {
        NSString *key = self.sectionKeys[indexPath.section];
        NSArray *array = self.classifyDict[key];
        model = array[indexPath.row];
    }else{
        model = self.searchArray[indexPath.row];
    }
    
    if (self.doneBlock) {
        self.doneBlock(model);
    }
    
    [self searchDone];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - T8LetterIndexNavigationViewDelegate
- (void)LetterIndexNavigationView:(T8LetterIndexNavigationView *)LetterIndexNavigationView didSelectIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    if (searchBar.subviews.count > 0) {
        [searchBar.subviews[0].subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
            }
        }];
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchArray removeAllObjects];
    [self.searchArray addObjectsFromArray:[self.dataSource searchCountryModelsWithKey:searchController.searchBar.text]];
    
    CGFloat offset = 0;
    if (searchController.active) {
        offset = 64;
    }else{
        offset = 20;
    }
    UITableView *tableView = self.tableView;
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = offset;
    tableView.contentInset = contentInset;
    UIEdgeInsets scrollInset = tableView.scrollIndicatorInsets;
    scrollInset.top = offset;
    tableView.scrollIndicatorInsets = scrollInset;
    [tableView reloadData];
    
    tableView = ((UITableViewController *)searchController.searchResultsController).tableView;
    contentInset = tableView.contentInset;
    contentInset.top = 64;
    tableView.contentInset = contentInset;
    scrollInset = tableView.scrollIndicatorInsets;
    scrollInset.top = 64;
    tableView.scrollIndicatorInsets = scrollInset;
    [tableView reloadData];
}

@end
