//
//  ViewController.m
//  WCDragDemo
//
//  Created by admin on 2017/2/28.
//  Copyright © 2017年 com.gz.bingoMobileSchoolss. All rights reserved.
//

#import "ViewController.h"
#import "YLDefine.h"
#import "YLDargSortCell.h"
#import "YLDragSortTool.h"
#import "UIView+Frame.h"

#define kSpaceBetweenSubscribe  4 * SCREEN_WIDTH_RATIO
#define kVerticalSpaceBetweenSubscribe  2 * SCREEN_WIDTH_RATIO
#define kSubscribeHeight  35 * SCREEN_WIDTH_RATIO
#define kContentLeftAndRightSpace  20 * SCREEN_WIDTH_RATIO
#define kTopViewHeight  80 * SCREEN_WIDTH_RATIO
#define itemSizeWidth (SCREEN_WIDTH - 3 * kSpaceBetweenSubscribe - 2 * kContentLeftAndRightSpace )/4

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SKDragSortDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView * snapshotView; //截屏得到的view
@property (nonatomic,weak) YLDargSortCell * originalCell;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSIndexPath * nextIndexPath;
@property (nonatomic,strong) UIButton * sortDeleteBtn;

@property (nonatomic,strong) UIButton *moreBtn;


@property (nonatomic,assign) CGRect rectItemFirst;


@property (nonatomic,strong) NSMutableArray *appsArray;

@end

@implementation ViewController

-(UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:0];
        self.moreBtn.backgroundColor = [UIColor grayColor];
        [self.collectionView addSubview:self.moreBtn];
    }
    return _moreBtn;
}


- (NSMutableArray *)appsArray{
    if (!_appsArray) {
        _appsArray = [NSMutableArray array];
        _appsArray = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"8"] mutableCopy];
        
    }
    return _appsArray;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat width = (SCREEN_WIDTH - 3 * kSpaceBetweenSubscribe - 2 * kContentLeftAndRightSpace )/4 ;
        layout.itemSize = CGSizeMake(width,width+5);
        
        layout.minimumLineSpacing = kSpaceBetweenSubscribe;
        layout.minimumInteritemSpacing = kVerticalSpaceBetweenSubscribe;
        layout.sectionInset = UIEdgeInsetsMake(kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT) collectionViewLayout:layout];
        //注册cell
        [_collectionView registerClass:[YLDargSortCell class] forCellWithReuseIdentifier:@"YLDargSortCell"];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.appsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YLDargSortCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YLDargSortCell" forIndexPath:indexPath];
    
    cell.deleteBtn.tag = indexPath.item;
    cell.delegate = self;
  
    
     if (indexPath.item == 0 && self.appsArray.count>0) {
           self.rectItemFirst = cell.frame;
     }
    
    if (indexPath.item == self.appsArray.count - 1 ) {
      
        CGRect rect = cell.frame;
        CGFloat xxx = CGRectGetMaxX(cell.frame);
        CGFloat yyy = CGRectGetMaxY(cell.frame);
        CGFloat widthdd = CGRectGetWidth(cell.frame);
        
        NSInteger row = self.appsArray.count % 4;

        if (row == 0) {
            self.moreBtn.frame = CGRectMake(CGRectGetMinX(self.rectItemFirst), yyy+kVerticalSpaceBetweenSubscribe, widthdd, widthdd);
        }else{
            self.moreBtn.frame = CGRectMake(xxx + kSpaceBetweenSubscribe, rect.origin.y, widthdd, widthdd);
        }
    }
    
    cell.subscribe = [YLDragSortTool shareInstance].subscribeArray[indexPath.row];
    return cell;
    
}

#pragma mark - SKDragSortDelegate

- (void)YLDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    //记录上一次手势的位置
    static CGPoint startPoint;
    //触发长按手势的cell
    YLDargSortCell * cell = (YLDargSortCell *)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //开始长按
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            
            [YLDragSortTool shareInstance].isEditing = YES;
            [_sortDeleteBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.collectionView.scrollEnabled = NO;
        }
        
        if (![YLDragSortTool shareInstance].isEditing) {
            return;
        }
        
        NSArray *cells = [self.collectionView visibleCells];
        for (YLDargSortCell *cell in cells) {
            [cell showDeleteBtn];
        }
        
        //获取cell的截图
        _snapshotView  = [cell snapshotViewAfterScreenUpdates:YES];
        _snapshotView.center = cell.center;
        [_collectionView addSubview:_snapshotView];
        _indexPath = [_collectionView indexPathForCell:cell];
        _originalCell = cell;
        _originalCell.hidden = YES;
        startPoint = [gestureRecognizer locationInView:_collectionView];
        
        //移动
    }else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        
        CGFloat tranX = [gestureRecognizer locationOfTouch:0 inView:_collectionView].x - startPoint.x;
        CGFloat tranY = [gestureRecognizer locationOfTouch:0 inView:_collectionView].y - startPoint.y;
        
        //设置截图视图位置
        _snapshotView.center = CGPointApplyAffineTransform(_snapshotView.center, CGAffineTransformMakeTranslation(tranX, tranY));
        startPoint = [gestureRecognizer locationOfTouch:0 inView:_collectionView];
        //计算截图视图和哪个cell相交
        for (UICollectionViewCell *cell in [_collectionView visibleCells]) {
            //跳过隐藏的cell
            if ([_collectionView indexPathForCell:cell] == _indexPath || [[_collectionView indexPathForCell:cell] item] == 0) {
                continue;
            }
            //计算中心距
            CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
            
            //如果相交一半且两个视图Y的绝对值小于高度的一半就移动
            if (space <= _snapshotView.bounds.size.width * 0.5 && (fabs(_snapshotView.center.y - cell.center.y) <= _snapshotView.bounds.size.height * 0.5)) {
                _nextIndexPath = [_collectionView indexPathForCell:cell];
                if (_nextIndexPath.item > _indexPath.item) {
                    for (NSUInteger i = _indexPath.item; i < _nextIndexPath.item ; i ++) {
                        [self.appsArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                    }
                }else{
                    for (NSUInteger i = _indexPath.item; i > _nextIndexPath.item ; i --) {
                        [self.appsArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                    }
                }
                //移动
                [_collectionView moveItemAtIndexPath:_indexPath toIndexPath:_nextIndexPath];
                //设置移动后的起始indexPath
                _indexPath = _nextIndexPath;
                break;
            }
        }
        //停止
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [_snapshotView removeFromSuperview];
        _originalCell.hidden = NO;
    }
}

- (void)YLDargSortCellCancelSubscribe:(NSInteger)subscribe {
    
        [self.appsArray removeObjectAtIndex:subscribe];
        [self.collectionView reloadData];
    
      if (self.appsArray.count == 0) {
          CGFloat btn_x = CGRectGetMinX(self.rectItemFirst);
          self.moreBtn.left = btn_x;
           [self.view layoutIfNeeded];
      }
}


@end
