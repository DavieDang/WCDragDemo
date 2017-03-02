//
//  ViewController.h
//  WCDragDemo
//
//  Created by admin on 2017/2/28.
//  Copyright © 2017年 com.gz.bingoMobileSchoolss. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol SKDragSortDelegate <NSObject>

- (void)YLDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer;

- (void)YLDargSortCellCancelSubscribe:(NSInteger)subscribe;

@end

@interface YLDargSortCell : UICollectionViewCell
@property (nonatomic,strong) NSString * subscribe;

@property (nonatomic,strong) UIButton *appButton;

@property (nonatomic,weak) id<SKDragSortDelegate> delegate;

@property (nonatomic,strong) UIButton * deleteBtn;

- (void)showDeleteBtn;
@end
