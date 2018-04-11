//
//  CycCollectionLayout.m
//  cycleDemo
//
//  Created by xsd on 2018/4/10.
//  Copyright © 2018年 com.GF. All rights reserved.
//

#import "CycCollectionLayout.h"


@interface CycCollectionLayout()

@property (nonatomic, assign) CGFloat scaleFactor;//缩放系数
@property (nonatomic, assign) CGFloat activeDistance;

@end

@implementation CycCollectionLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scaleFactor = 0.15;//缩放系数
        self.activeDistance = 150;//[UIScreen mainScreen].bounds.size.width * 2;//这个值越大，缩放比例越不明显，最小不能小于item的宽度
    }
    return self;
}

//要展示的cell的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect frame = CGRectZero;
    frame.origin = self.collectionView.contentOffset;
    frame.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attribute in array) {
        //确立cell相对于屏幕中央的距离
        CGFloat distance = CGRectGetMidX(frame) - attribute.center.x;
        
        //到中心位置的相对于x的比例,原则就是越近的越大，越远的越小。
        CGFloat normalDistance = fabs(distance / self.activeDistance);
        
        /*
        //确定每个cell的缩放量
        
         CGFloat scale = 1 -  normalDistance;
        */
        //还有更简单的处理方式，就是给上面算出来的缩放比例，再次✖️一个缩放系数，就是为了让上面的activeDistance更变量
        CGFloat scale = 1 - self.scaleFactor * normalDistance;
        //属性赋值
        attribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
    }
    return array;
}

// 确定最终滚到的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat horizontalCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width / 2.;
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attribute in array) {
        //
        CGFloat tempCenterX = attribute.center.x;
        if (fabs(horizontalCenterX - tempCenterX) < fabs(offsetAdjustment)) {
            offsetAdjustment = tempCenterX - horizontalCenterX;
        }
    }
    
    CGPoint resultPoint = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    
    return resultPoint;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}


@end
