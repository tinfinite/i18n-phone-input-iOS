//
//  ViewController.m
//  i18nPhoneInputDemo
//
//  Created by 琦张 on 16/2/3.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "ViewController.h"
#import "T8PhoneInputView.h"
#import "Masonry.h"

@interface ViewController ()<T8PhoneInputViewDelegate>

@property (strong, nonatomic) T8PhoneInputView *phoneInputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:self.phoneInputView];
    
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(60);
        make.height.equalTo(@90);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryAndCode" ofType:@"txt"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"arr:%@", arr);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json:%@", jsonStr);
    NSString *resultPath = @"/Users/qizhang/Desktop/json.txt";

    [jsonData writeToFile:resultPath atomically:YES];
}

- (void)makeCountryData
{
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    NSString *codePath = [[NSBundle mainBundle] pathForResource:@"country_code" ofType:@"txt"];
    NSData *codeData = [NSData dataWithContentsOfFile:codePath];
    NSString *codeStr = [[NSString alloc] initWithData:codeData encoding:NSUTF8StringEncoding];
    NSArray *codeArray = [codeStr componentsSeparatedByString:@"\n"];
    
    [codeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tmp = [obj componentsSeparatedByString:@" "];
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        [tmpDict setObject:tmp[0] forKey:@"key"];
        [tmpDict setObject:tmp[1] forKey:@"code"];
        [jsonArray addObject:tmpDict];
    }];
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"mmregioncode4client" ofType:@"txt"];
    NSData *nameData = [NSData dataWithContentsOfFile:namePath];
    NSString *nameStr = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
    NSArray *nameArray = [nameStr componentsSeparatedByString:@"\n"];
    NSMutableArray *newNameArray = [NSMutableArray array];
    [nameArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"zh_TW"]) {
            
        }else if ([obj hasPrefix:@"zh_CN"] || [obj hasPrefix:@"en"]){
            NSArray *tmp = [obj componentsSeparatedByString:@"|"];
            NSString *tmpStr = tmp[1];
            if (tmpStr.length == 2) {
                [newNameArray addObject:obj];
            }
        }
    }];
    
    NSString *aPath = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"txt"];
    NSData *aData = [NSData dataWithContentsOfFile:aPath];
    NSString *aContent = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    aContent = [aContent stringByReplacingOccurrencesOfString:@"\t" withString:@","];
    NSArray *aArray = [aContent componentsSeparatedByString:@"\n"];
    
    NSMutableArray *notFind = [NSMutableArray array];
    NSMutableArray *someNotFind = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = dict[@"key"];
        NSInteger code = [dict[@"code"] integerValue];
        NSString *zhKey = [NSString stringWithFormat:@"zh_CN|%@", key];
        NSString *enKey = [NSString stringWithFormat:@"en|%@", key];
        __block BOOL zhFind = NO;
        __block BOOL enFind = NO;
        [newNameArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:zhKey]) {
                zhFind = YES;
                NSArray *tmp = [obj componentsSeparatedByString:@"|"];
                [dict setObject:tmp[2] forKey:@"nameZh"];
            }else if ([obj containsString:enKey]){
                enFind = YES;
                NSArray *tmp = [obj componentsSeparatedByString:@"|"];
                [dict setObject:tmp[2] forKey:@"nameEn"];
            }
            if (zhFind && enFind) {
                *stop = YES;
            }
        }];
        [aArray enumerateObjectsUsingBlock:^(NSString * _Nonnull aStr, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([aStr containsString:key]) {
                NSArray *tmpArray = [aStr componentsSeparatedByString:@","];
                if ([tmpArray[2] isEqualToString:key]) {
                    [dict setObject:tmpArray[0] forKey:@"nameEn"];
                    [dict setObject:tmpArray[1] forKey:@"nameZh"];
                    zhFind = YES;
                    enFind = YES;
                }
            }
        }];
        if (!zhFind && !enFind) {
            [notFind addObject:[NSString stringWithFormat:@"%@_%ld", key, (long)code]];
            [dict setObject:@"" forKey:@"nameEn"];
            [dict setObject:@"" forKey:@"nameZh"];
        }else if (!zhFind || !enFind){
            [someNotFind addObject:key];
        }
    }];
    
    NSString *resultPath = @"/Users/qizhang/Desktop/json.txt";
    [jsonArray writeToFile:resultPath atomically:YES];
    
    NSLog(@"111");
    
//    NSArray *arr = [[NBPhoneNumberUtil sharedInstance] getSupportedRegions];
//    NSLog(@"tttt:%@", arr);
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"txt"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@","];
//    NSLog(@"ooo:%@", content);
//    NSArray *arr1 = [content componentsSeparatedByString:@"\n"];
//    NSLog(@"111:%@", arr1);
//    
//    NSMutableArray *jsonArr = [NSMutableArray array];
//    NSMutableArray *notFind = [NSMutableArray array];
//    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
//        __block BOOL find = NO;
//        [arr1 enumerateObjectsUsingBlock:^(NSString * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([item containsString:key]) {
//                NSArray *tmp = [item componentsSeparatedByString:@","];
//                if ([tmp[2] isEqualToString:key]) {
//                    *stop = YES;
//                    find = YES;
//                    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
//                    [tmpDict setObject:key forKey:@"key"];
//                    [tmpDict setObject:tmp[0] forKey:@"nameEn"];
//                    [tmpDict setObject:tmp[1] forKey:@"nameZh"];
//                    [tmpDict setObject:tmp[3] forKey:@"code"];
//                    [jsonArr addObject:tmpDict];
//                }
//            }
//        }];
//        if (!find) {
//            [notFind addObject:key];
//        }
//    }];
//    NSLog(@"fff:%@", jsonArr);
//    NSLog(@"nnn:%@", notFind);
//    
//    NBPhoneMetaData *im = [[[NBMetadataHelper alloc] init] getMetadataForRegion:@"IM"];
//    NBPhoneMetaData *gb = [[[NBMetadataHelper alloc] init] getMetadataForRegion:@"GB"];
//    NSLog(@"11");
}

#pragma mark - getter
- (T8PhoneInputView *)phoneInputView
{
    if (!_phoneInputView) {
        _phoneInputView = [[T8PhoneInputView alloc] init];
        _phoneInputView.delegate = self;
    }
    return _phoneInputView;
}

#pragma mark - T8PhoneInputViewDelegate
- (void)inputView:(T8PhoneInputView *)view presentSelectVC:(T8PhoneInputCountrySelectVC *)select
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:select];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
