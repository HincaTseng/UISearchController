//
//  ListVC.m
//  ListPro
//
//  Created by 曾宪杰 on 2018/6/23.
//  Copyright © 2018年 supertech. All rights reserved.
//

#import "ListVC.h"
#import "XJTableViewCell.h"
#import "SearchInfoVC.h"

#define kCNSSTRING_ISEMPTY(str) (str == nil || [str isEqual:[NSNull null]] || str.length <= 0)
static NSString *const idinifier = @"cell";
@interface ListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) UISearchController *searchVC;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSDictionary *allKeysDict;
@property (nonatomic,strong) NSMutableArray *dicToArr;

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"搜索";
    _dataArr = [[NSArray alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Data" ofType:@"plist"]];

    [self.myTableView registerNib:[UINib nibWithNibName:@"XJTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:idinifier];
    self.myTableView.sectionIndexColor = [UIColor blackColor];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.tableFooterView = [UIView new];
    //
    _allKeysDict = [self createCharacter:array]; NSLog(@"............%@",_allKeysDict);
    _dataArr = [self.allKeysDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *title1 = obj1;
        NSString *title2 = obj2;
        if (kCNSSTRING_ISEMPTY(title2)) {
            return NSOrderedDescending;
        } else if ([title1 characterAtIndex:0] < [title2 characterAtIndex:0]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    for (NSDictionary *obj in array) {
        NSString *name = obj[@"name"];
        [self.dicToArr addObject:name];
    }
    SearchInfoVC *seVC = [[SearchInfoVC alloc] init];
    seVC.searchData = self.dicToArr; //
    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:seVC];
    self.searchVC.searchResultsUpdater = seVC;
//    self.searchVC.searchBar.delegate = self;
    self.searchVC.searchBar.placeholder = @"搜索";
    self.searchVC.searchBar.returnKeyType = UIReturnKeyDone;
    [self.searchVC.searchBar sizeToFit];
//    self.myTableView.tableHeaderView = self.searchVC.searchBar;
    self.definesPresentationContext = YES;
 
    //
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchVC;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
          self.myTableView.tableHeaderView = self.searchVC.searchBar;//只用tableHeaderView时，搜索的tab cell高度 下移。
    }
    

}

#pragma mark-
#pragma mark UITableViewDataSource 和 UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray*)self.allKeysDict[self.dataArr[section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idinifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XJTableViewCell" owner:self options:nil] firstObject];
    }
        cell.titleLab.text = [self.allKeysDict[self.dataArr[indexPath.section]] objectAtIndex:indexPath.row];
        cell.icon.image = [UIImage imageNamed:[self.allKeysDict[self.dataArr[indexPath.section]] objectAtIndex:indexPath.row]];
    
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return self.dataArr[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
        return self.dataArr;
}

-(NSMutableArray *)dicToArr {
    if (!_dicToArr) {
        _dicToArr = [NSMutableArray array];
    }
    return _dicToArr;
}
- (NSDictionary *)createCharacter:(NSMutableArray *)strArr
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSDictionary *stringdict in strArr) {
        NSString *string = stringdict[@"name"];
        if ([string length]) {
            NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:string];
            
            if (CFStringTransform((__bridge CFMutableStringRef)mutableStr, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            if (CFStringTransform((__bridge CFMutableStringRef)mutableStr, 0, kCFStringTransformStripDiacritics, NO)) {
                NSString *str = [NSString stringWithString:mutableStr];
                str = [str uppercaseString];
                NSMutableArray *subArray = [dict objectForKey:[str substringToIndex:1]];
                if (!subArray) {
                    subArray = [NSMutableArray array];
                    [dict setObject:subArray forKey:[str substringToIndex:1]];
                }
                [subArray addObject:string];
            }
        }
    }
    return dict;
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [self.view endEditing:YES];
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
