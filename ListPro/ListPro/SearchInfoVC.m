//
//  SearchInfoVC.m
//  ListPro
//
//  Created by 曾宪杰 on 2018/6/23.
//  Copyright © 2018年 supertech. All rights reserved.
//

#import "SearchInfoVC.h"
#import "XJTableViewCell.h"
#define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))

static NSString *const idinifier = @"cell";
@interface SearchInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *listArr;

@end

@implementation SearchInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myTableView registerNib:[UINib nibWithNibName:@"XJTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:idinifier];
    self.myTableView.sectionIndexColor = [UIColor blackColor];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.tableFooterView = [UIView new];

    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
        // Fallback on earlier versions
        
    }
    

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idinifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XJTableViewCell" owner:self options:nil] firstObject];
    }
    cell.titleLab.text = self.listArr[indexPath.row];
    cell.icon.image = [UIImage imageNamed:self.listArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    searchController.searchBar.showsCancelButton = YES;
//    for(id sousuo in [searchController.searchBar subviews])
//    {
//        for (id zz in [sousuo subviews])
//        {
//            if([zz isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton *)zz;
//                [btn setTitle:@"搜索" forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            }
//        }
//    }
    searchController.searchResultsController.view.hidden = NO;
    NSLog(@"%@", [NSThread currentThread]);
    
    if (!self.listArr) {
         [self.listArr removeAllObjects];
    }
   
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchController.searchBar.text];
    self.listArr = [[self.searchData filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.myTableView reloadData];
    });

}

- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
