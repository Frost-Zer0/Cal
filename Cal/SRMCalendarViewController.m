//
//  SRMCalendarViewController.m
//  Cal
//
//  Created by Sorumi on 16/7/27.
//  Copyright © 2016年 Sorumi. All rights reserved.
//


#import "SRMCalendarViewController.h"
#import "SRMCalendarConstance.h"
#import "SRMCalendarTool.h"
#import "SRMCalendarHeader.h"
#import "SRMMonthDayCell.h"
#import "SRMWeekDayCell.h"
#import "SRMWeekWeekdayHeader.h"

@interface SRMCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) CGFloat const viewWidth;

@property (nonatomic, strong) SRMCalendarTool *tool;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *today;
@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;
@property (nonatomic) NSInteger selectedDay;

@property (nonatomic) SRMCalendarViewMode viewMode;

@property (weak, nonatomic) IBOutlet SRMCalendarHeader *headerView;
@property (weak, nonatomic) IBOutlet SRMWeekWeekdayHeader *weekWeekdayHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *weekCollectionView;

@property (nonatomic) BOOL isFirstTimeViewDidLayoutSubviews;

#pragma mark - Constraint

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monthWeekdayViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekHeaderTrailing;

@end

@implementation SRMCalendarViewController

static NSString * const reuseMonthCellIdentifier = @"MonthDateCell";
static NSString * const reuseWeekCellIdentifier = @"WeekDateCell";

#pragma mark - Properties


- (void)setDate:(NSDate *)date
{
    _date = date;
    self.selectedYear = [_tool yearOfDate:self.date];
    self.selectedMonth = [_tool monthOfDate:self.date];
    self.selectedDay = [_tool dayOfDate:self.date];
    [self.headerView setWeekHeaderYear:self.selectedYear month:self.selectedMonth day:self.selectedDay weekday:[self.tool weekdayOfDate:self.date]];
}

#pragma mark - Life Cycle & Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    _tool = [[SRMCalendarTool alloc] init];
    self.date = [NSDate date];
    self.today = self.date;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view reloadInputViews];
    
    //const
    self.viewWidth = self.view.frame.size.width;

    [self.monthCollectionView registerNib:[UINib nibWithNibName:@"SRMMonthDayCell" bundle:nil] forCellWithReuseIdentifier:reuseMonthCellIdentifier];
    [self.weekCollectionView registerNib:[UINib nibWithNibName:@"SRMWeekDayCell" bundle:nil] forCellWithReuseIdentifier:reuseWeekCellIdentifier];
    
//    [self.monthCollectionView registerNib:[UINib nibWithNibName:@"SRMMonthClipboardView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseClipboardIdentifier];
    
    self.monthCollectionView.bounces = NO;
    self.monthCollectionView.pagingEnabled = YES;
    self.monthCollectionView.showsVerticalScrollIndicator = NO;
    self.monthCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.monthCollectionView.delegate = self;
    self.monthCollectionView.dataSource = self;
    
    self.weekCollectionView.bounces = NO;
    self.weekCollectionView.pagingEnabled = YES;
    self.weekCollectionView.showsVerticalScrollIndicator = NO;
    self.weekCollectionView.showsHorizontalScrollIndicator = NO;
    
    self.weekCollectionView.delegate = self;
    self.weekCollectionView.dataSource = self;
    
    self.viewMode = SRMCalendarMonthViewMode;
    
    // add custum gesture
    UISwipeGestureRecognizer *monthToWeek = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(MonthToWeek:)];
    monthToWeek.direction = UISwipeGestureRecognizerDirectionUp;
    [self.monthCollectionView addGestureRecognizer:monthToWeek];
    
    UISwipeGestureRecognizer *weekToMonth = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(WeekToMonth:)];
    weekToMonth.direction = UISwipeGestureRecognizerDirectionDown;
    [self.weekCollectionView addGestureRecognizer:weekToMonth];
    
    self.isFirstTimeViewDidLayoutSubviews = YES;

}


- (void)viewDidLayoutSubviews
{
    
    if (self.isFirstTimeViewDidLayoutSubviews) {
        
        [self monthScrollToDate:self.today animated:NO];
        [self weekScrollToDate:self.today animated:NO];
        [self.headerView setMonthHeaderYear:self.selectedYear month:self.selectedMonth];
        
        self.date = self.today;
        self.isFirstTimeViewDidLayoutSubviews = NO;

    }
}

#pragma mark - Private

- (void)monthScrollToDate:(NSDate *)date animated:(BOOL)animated
{
    SRMCalendarTool *tool = self.tool;
    if ([tool monthsFromDate:tool.minimumDate toDate:date] > 0 && [tool monthsFromDate:date toDate:tool.maximumDate] > 0 ) {
        NSInteger monthCount = [tool monthsFromDate:tool.minimumDate toDate:date];
        CGFloat offsetX = self.viewWidth * monthCount;
        [self.monthCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
        
    }
}

- (void)weekScrollToDate:(NSDate *)date animated:(BOOL)animated
{
    SRMCalendarTool *tool = self.tool;
    if ([tool monthsFromDate:tool.minimumDate toDate:date] > 0 && [tool monthsFromDate:date toDate:tool.maximumDate] > 0 ) {
        date = [tool beginningOfWeekOfDate:date];
        NSDate *beginDate = [tool beginningOfWeekOfDate:tool.minimumDate];
        NSInteger weekCount = [tool weeksFromDate:beginDate toDate:date];
        CGFloat offsetX = self.viewWidth * weekCount;
        [self.weekCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    }
}

#pragma mark - Action

- (IBAction)setPrevMonth:(id)sender
{
    NSDate *date = [self.tool dateByAddingMonths:-1 toDate:self.date];
    [self monthScrollToDate:date animated:YES];
}

- (IBAction)setNextMonth:(id)sender
{
    NSDate *date = [self.tool dateByAddingMonths:1 toDate:self.date];
    [self monthScrollToDate:date animated:YES];
}

- (void)MonthToWeek:(UISwipeGestureRecognizer *)gesture
{
    self.viewMode = SRMCalendarWeekViewMode;
    
    // animation
    [self.view bringSubviewToFront:self.headerView];
    self.monthWeekdayViewTop.constant = - self.monthCollectionView.frame.size.height - SRMMonthViewWeekdayHeight + self.viewWidth / 7;
    self.weekViewBottom.constant = self.weekCollectionView.frame.size.height;
    self.weekHeaderTrailing.constant = self.headerView.weekHeader.frame.size.width;

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.headerView.monthHeader.alpha = 0;
                         self.headerView.weekHeader.alpha = 1;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)WeekToMonth:(UISwipeGestureRecognizer *)gesture
{
    self.viewMode = SRMCalendarMonthViewMode;
    
    // animation
    [self.view bringSubviewToFront:self.headerView];
    self.monthWeekdayViewTop.constant = 0;
    self.weekViewBottom.constant = 0;
    self.weekHeaderTrailing.constant = 0;

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.headerView.monthHeader.alpha = 1;
                         self.headerView.weekHeader.alpha = 0;
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //month view change the label
    NSDate *date;
    SRMCalendarTool *tool = self.tool;
    
    if (scrollView == self.monthCollectionView) {
        NSInteger page = round(self.monthCollectionView.contentOffset.x / self.viewWidth);
    
        date = [tool dateByAddingMonths:page toDate:tool.minimumDate];
        NSInteger year = [tool yearOfDate:date];
        NSInteger month = [tool monthOfDate:date];
        

        [self.headerView setMonthHeaderYear:year month:month];
        
    } else if (scrollView == self.weekCollectionView) {
               
//        NSInteger page = round(self.weekCollectionView.contentOffset.x / self.viewWidth);
//
//        NSDate *beginDate = [tool beginingOfWeekOfDate:tool.minimumDate];
//        date = [tool dateByAddingWeeks:page toDate:beginDate];
        
//        self.date = date;
//        [self scrollToDate:date animated:NO];
    }

}

// use finger ti scroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.monthCollectionView && self.viewMode == SRMCalendarMonthViewMode) {

        SRMCalendarTool *tool = self.tool;
        NSInteger page = self.monthCollectionView.contentOffset.x / self.viewWidth;
        NSDate *currentBeginningDate = [tool dateByAddingMonths:page toDate:tool.minimumDate];
        NSDate *selfBeginningDate = [tool beginningOfMonthOfDate:self.date];

        if (![tool date:currentBeginningDate isEqualToDate:selfBeginningDate]) {
            self.date = currentBeginningDate;
            [self weekScrollToDate:self.date animated:NO];
        }
        
    } else if (scrollView == self.weekCollectionView && self.viewMode == SRMCalendarWeekViewMode) {
        
        SRMCalendarTool *tool = self.tool;
        NSInteger page = self.weekCollectionView.contentOffset.x / self.viewWidth;
        NSDate *currentBeginningDate = [tool beginningOfWeekOfDate:tool.minimumDate];
        currentBeginningDate = [tool dateByAddingWeeks:page toDate:currentBeginningDate];
        NSDate *selfBeginningDate = [tool beginningOfWeekOfDate:self.date];
        
        if (![tool date:currentBeginningDate isEqualToDate:selfBeginningDate]) {
            self.date = currentBeginningDate;
            [self.weekWeekdayHeader setCirclePos:[tool weekdayOfDate:self.date] animated:YES];
            [self monthScrollToDate:self.date animated:NO];
        }
    }

}

// use code to scroll
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.monthCollectionView && self.viewMode == SRMCalendarMonthViewMode) {

        SRMCalendarTool *tool = self.tool;
        NSInteger page = self.monthCollectionView.contentOffset.x / self.viewWidth;
        NSDate *currentBeginningDate = [tool dateByAddingMonths:page toDate:tool.minimumDate];
        NSDate *selfBeginningDate = [tool beginningOfMonthOfDate:self.date];
        
        if (![tool date:currentBeginningDate isEqualToDate:selfBeginningDate]) {
            self.date = currentBeginningDate;
            [self weekScrollToDate:self.date animated:NO];
        }
        
    }
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    SRMCalendarTool *tool = self.tool;
    
    if (collectionView == self.monthCollectionView) {
        
        return [tool monthsFromDate:tool.minimumDate toDate:tool.maximumDate] + 1;
        
    } else if (collectionView == self.weekCollectionView) {
        
        return [tool weeksFromDate:tool.minimumDate toDate:tool.maximumDate] + 1;
    }
    
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.monthCollectionView) {
        
        return 42;
        
    } else if (collectionView == self.weekCollectionView) {
        
        return 7;
        
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.monthCollectionView) {
        SRMMonthDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseMonthCellIdentifier forIndexPath:indexPath];
        
        SRMCalendarTool *tool = self.tool;
        
        NSDate *date = [tool dateByAddingMonths:indexPath.section toDate:tool.minimumDate];
        
        NSInteger blankDayCount = [self.tool weekdayOfDate:[self.tool beginningOfMonthOfDate:date]];
        NSInteger currentMonthDayCount = [self.tool dayCountOfMonthofDate:date];
        
        
        NSDate *prevDate = [tool dateByAddingMonths:-1 toDate:date];
        NSInteger previousMonthDayCount = [self.tool dayCountOfMonthofDate:prevDate];

        date = [tool dateByAddingDays:(indexPath.row - blankDayCount) toDate:date];
        cell.date = date;
        
        if (indexPath.row < blankDayCount) {
            [cell setOtherMonthDate:previousMonthDayCount - blankDayCount + indexPath.row + 1];
            
        } else if (indexPath.row > blankDayCount + currentMonthDayCount - 1) {
            [cell setOtherMonthDate:indexPath.row - blankDayCount - currentMonthDayCount + 1];
            
        } else {
            [cell setCurrentMonthDate:indexPath.row - blankDayCount + 1];
        }
        
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
//        if (cell.selected) {
//            cell.backgroundColor = [UIColor whiteColor]; // highlight selection
//        }
        return cell;
        
    } else if (collectionView == self.weekCollectionView) {
        SRMWeekDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseWeekCellIdentifier forIndexPath:indexPath];
        
        SRMCalendarTool *tool = self.tool;
        NSDate *date = [tool dateByAddingWeeks:indexPath.section toDate:tool.minimumDate];
        date = [tool beginningOfWeekOfDate:date];
        date = [tool dateByAddingDays:indexPath.row toDate:date];
        
        cell.date = date;
        [cell setWeekDate:[tool dayOfDate:date]];
        
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

        return cell;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = self.viewWidth / 7.0;
    CGSize size = CGSizeMake(cellWidth, cellWidth);

    return size;
}

/*
// 允许选中时，高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 高亮完成后回调
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
// 由高亮转成非高亮完成时的回调
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

}
*/
// 设置是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 设置是否允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 选中操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.monthCollectionView) {
        SRMMonthDayCell *cell = (SRMMonthDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.backgroundColor = [UIColor redColor];
        if ([self.tool monthOfDate:cell.date] != self.selectedMonth) {
            [self monthScrollToDate:cell.date animated:YES];
        } else {
            self.date = cell.date;
            [self.weekWeekdayHeader setCirclePos:[self.tool weekdayOfDate:self.date] animated:NO];
            [self weekScrollToDate:self.date animated:NO];
            [self MonthToWeek:nil];
        }
        
    } else if (collectionView == self.weekCollectionView) {
        SRMWeekDayCell *cell = (SRMWeekDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        self.date = cell.date;
        [self.weekWeekdayHeader setCirclePos:[self.tool weekdayOfDate:self.date] animated:YES];
        [self monthScrollToDate:self.date animated:NO];
    }
}

// 取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (collectionView == self.monthCollectionView) {
//        UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
//    }
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader)
//    {
//        SRMMonthClipboardView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseClipboardIdentifier forIndexPath:indexPath];
//        reusableview = headerView;
//    }
//    
//    return reusableview;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
