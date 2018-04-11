//
//  ViewController.m
//  cycleDemo
//
//  Created by xsd on 2018/4/10.
//  Copyright © 2018年 com.GF. All rights reserved.
//

#import "ViewController.h"
#import "CycCollectionLayout.h"
#import "CustomerCollectionViewCell.h"

static NSInteger sectionCount = 100;
static NSInteger itemsCount = 10;

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timers;//时间！

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.collectionView];
    //滚动到屏幕中央
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionCount/2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.timers class];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timers invalidate];
    self.timers = nil;
    
}
- (void)timeHandle:(NSTimer *)timer {
    //处理time到点事件
    
    NSArray *array = self.collectionView.indexPathsForVisibleItems;
    
    //取出最中间的cell的index，
    array = [array sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        if (obj1.section == obj2.section) {
            return obj1.row > obj2.row;
        } else {
            return obj1.section > obj2.section;
        }
    }];
    
    __block NSIndexPath *index = array[1];
    [UIView animateWithDuration:0.001 animations:^{
        if (index.row == itemsCount-1) {
            //
            index = [NSIndexPath indexPathForRow:index.row inSection:sectionCount/2-1];
    
        } else {
            index = [NSIndexPath indexPathForRow:index.row inSection:sectionCount/2];
        }
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        
        if (index.row == itemsCount-1) {
            //
            index = [NSIndexPath indexPathForRow:0 inSection:sectionCount/2];
            
        } else {
            index = [NSIndexPath indexPathForRow:index.row+1 inSection:sectionCount/2];
        }
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
    
    
    
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemsCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerCollectionViewCell *cell = (CustomerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellFlag" forIndexPath:indexPath];
    cell.lable.text = [NSString stringWithFormat:@"第 %ld 个lable",(long)indexPath.row];
    
    return cell;
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        CycCollectionLayout *layout = [[CycCollectionLayout alloc] init];
        layout.itemSize = CGSizeMake(180, 100);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 150) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CustomerCollectionViewCell class] forCellWithReuseIdentifier:@"cellFlag"];
        _collectionView.backgroundColor = [UIColor grayColor];
        
    }
    return _collectionView;
}

- (NSTimer *)timers {
    if (!_timers) {
        //一秒跳一次
        _timers = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeHandle:) userInfo:nil repeats:YES];
    }
    return _timers;
}

@end
