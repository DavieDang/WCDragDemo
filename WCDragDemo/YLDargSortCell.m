
//
//  ViewController.h
//  WCDragDemo
//
//  Created by admin on 2017/2/28.
//  Copyright © 2017年 com.gz.bingoMobileSchoolss. All rights reserved.
//
#import "YLDargSortCell.h"
#import "YLDragSortTool.h"
#import "UIView+Frame.h"
#import "YLDefine.h"

#define kDeleteBtnWH 15 * SCREEN_WIDTH_RATIO
@interface YLDargSortCell ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)  UILabel *label;
@property (nonatomic,assign) BOOL  isEditing;
//@property (nonatomic,strong) UIButton * deleteBtn;
@end
@implementation YLDargSortCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {

    
    //给每个cell添加一个长按手势
    UILongPressGestureRecognizer * longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer * pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];

    _appButton = [UIButton buttonWithType:0];
    _appButton.backgroundColor = [UIColor redColor];
    _appButton.width = self.width - kDeleteBtnWH;
    _appButton.height = self.height - kDeleteBtnWH;
    _appButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    [self.contentView addSubview:_appButton];
    

    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.hidden = ![YLDragSortTool shareInstance].isEditing;
    [_deleteBtn setImage:[UIImage imageNamed:@"drag_delete"] forState:UIControlStateNormal];
    _deleteBtn.width = kDeleteBtnWH;
    _deleteBtn.height = kDeleteBtnWH;
    
    [_deleteBtn addTarget:self action:@selector(cancelSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
      
}

- (void)cancelSubscribe {

    if (self.delegate && [self.delegate respondsToSelector:@selector(YLDargSortCellCancelSubscribe:)]) {
        [self.delegate YLDargSortCellCancelSubscribe:self.deleteBtn.tag];
    }
}

- (void)showDeleteBtn {

    _deleteBtn.hidden = NO;
}

- (void)editStateChange:(NSNotification *)noti {

    self.isEditing = YES;
}

- (void)setSubscribe:(NSString *)subscribe {
    
//    _subscribe = subscribe;
//    _deleteBtn.hidden = ![YLDragSortTool shareInstance].isEditing;
//    _label.text = subscribe;
//    _label.width = self.width - kDeleteBtnWH;
//    _label.height = self.height - kDeleteBtnWH;
//    _label.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![YLDragSortTool shareInstance].isEditing) {
        return NO;
    }
    return YES;
}


- (void)gestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(YLDargSortCellGestureAction:)]) {
        [self.delegate YLDargSortCellGestureAction:gestureRecognizer];
    }
}

@end
