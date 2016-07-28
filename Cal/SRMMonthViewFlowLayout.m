//
//  SRMMonthViewFlowLayout.m
//  Cal
//
//  Created by Sorumi on 16/7/26.
//  Copyright © 2016年 Sorumi. All rights reserved.
//

#import "SRMMonthViewFlowLayout.h"

@implementation SRMMonthViewFlowLayout



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
           }
    return self;
}

- (CGSize)itemSize
{
    CGFloat width = self.collectionView.frame.size.width/7;
    return CGSizeMake(width, width);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
//    if (!attributes.representedElementKind) {
//        return;
//    }
    
    UICollectionView *collectionView = self.collectionView;
        
    CGFloat xPageOffset = attributes.indexPath.section * collectionView.frame.size.width;
    CGFloat xCellOffset = xPageOffset + (attributes.indexPath.item % 7) * self.itemSize.width;
    CGFloat yCellOffset = self.headerReferenceSize.height + (attributes.indexPath.item / 7) * self.itemSize.width;
    attributes.frame = CGRectMake(xCellOffset, yCellOffset, self.itemSize.width, self.itemSize.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    [self applyLayoutAttributes:attrs];
    return attrs;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect].copy];
    
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        [self applyLayoutAttributes:attr];
    }
    return attributes;
}
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray* attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect].copy];
//    
//    //从第二个循环到最后一个
//    for(int i = 1; i < [attributes count]; ++i) {
//        //当前attributes
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        //上一个attributes
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
//        //我们想设置的最大间距，可根据需要改
//        NSInteger maximumSpacing = 0;
//        //前一个cell的最右边
//        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
//        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = origin + maximumSpacing;
//            currentLayoutAttributes.frame = frame;
//        }
//    }
//
//    for(int i = 7; i < [attributes count]; ++i) {
//        //当前attributes
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        //上一个attributes
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 7];
//        //我们想设置的最大间距，可根据需要改
//        NSInteger maximumSpacing = 0;
//        //前一个cell的最右边
//        NSInteger origin = CGRectGetMaxY(prevLayoutAttributes.frame);
//        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.height < self.collectionViewContentSize.height) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.y = origin + maximumSpacing;
//            currentLayoutAttributes.frame = frame;
//        }
//    }
//    
//    for (int i = 0; i < [attributes count]; ++i) {
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        CGRect frame = currentLayoutAttributes.frame;
//        frame.origin.x += 2;
//        currentLayoutAttributes.frame = frame;
//    }
//
//    return attributes;
//}

//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    
//    NSArray *attrKinds = [answer valueForKeyPath:@"representedElementKind"];
//    NSUInteger headerIndex = [attrKinds indexOfObject:UICollectionElementKindSectionHeader];
//    if (headerIndex != NSNotFound) {
//        [answer removeObjectAtIndex:headerIndex];
//    }
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//    [answer addObject:attributes];
//    
//    return answer;
//}

//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    UICollectionView * const cv = self.collectionView;
//    CGPoint const contentOffset = cv.contentOffset;
//    
//    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
//    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
//        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
//            [missingSections addIndex:layoutAttributes.indexPath.section];
//        }
//    }
//    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
//        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//            [missingSections removeIndex:layoutAttributes.indexPath.section];
//        }
//    }
//    
//    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
//        
//        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//        
//        [answer addObject:layoutAttributes];
//        
//    }];
//    
//    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
//        
//        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//            
//            NSInteger section = layoutAttributes.indexPath.section;
//            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
//            
//            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
//            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
//            
//            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
//            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
//            
//            
//            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//                CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
//                CGPoint origin = layoutAttributes.frame.origin;
//                origin.y = MIN(
//                               MAX(contentOffset.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)),
//                               (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
//                               );
//                
//                layoutAttributes.zIndex = 1024;
//                layoutAttributes.frame = (CGRect){
//                    .origin = origin,
//                    .size = layoutAttributes.frame.size
//                };
//            } else {
//                CGFloat headerWidth = CGRectGetWidth(layoutAttributes.frame);
//                CGPoint origin = layoutAttributes.frame.origin;
//                origin.x = MIN(
//                               MAX(contentOffset.x, (CGRectGetMinX(firstCellAttrs.frame) - headerWidth)),
//                               (CGRectGetMaxX(lastCellAttrs.frame) - headerWidth)
//                               );
//                
//                layoutAttributes.zIndex = 1024;
//                layoutAttributes.frame = (CGRect){
//                    .origin = origin,
//                    .size = layoutAttributes.frame.size
//                };
//            }
//            
//        }
//    }
//    
//    return answer;
//}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
