//
//  MLLetterIndexNavigationView.h
//  SecondhandCar
//
//  Created by molon on 14-1-8.
//  Copyright (c) 2014年 Molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class T8LetterIndexNavigationView;

@protocol T8LetterIndexNavigationViewDelegate <NSObject>

-(void)LetterIndexNavigationView:(T8LetterIndexNavigationView *)LetterIndexNavigationView didSelectIndex:(NSInteger)index;

@end

@interface T8LetterIndexNavigationView : UIView

@property (nonatomic, strong) NSArray *keys; //即为sections
@property (nonatomic, weak) id<T8LetterIndexNavigationViewDelegate> delegate;

//PS：需要搜索图标显示的话，delegate返回的index要注意下。搜索图标index为0。
@property (nonatomic, assign) BOOL isNeedSearchIcon;

@end
