//
//  ListVC.m
//  ListPro
//
//  Created by 曾宪杰 on 2018/6/23.
//  Copyright © 2018年 zengxianjie. All rights reserved.
//

#import "ListVC.h"
#import "XJTableViewCell.h"
#import "SearchInfoVC.h"

#define kCNSSTRING_ISEMPTY(str) (str == nil || [str isEqual:[NSNull null]] || str.length <= 0)
#define kShowApp_ISHAVE(obj) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:obj]])

static NSString *const idinifier = @"cell";
@interface ListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) UISearchController *searchVC;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSDictionary *allKeysDict;
@property (nonatomic,strong) NSMutableArray *dicToArr;
@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];

//      打开QQ
//    [self openScheme:@"mqq://"];

}

- (void)createUI {
    self.title = @"搜索";
    
    _array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Data" ofType:@"plist"]];
/*
 // 需要打开的app中注册 URL Types。 通过app打开的plist文件里添加 LSApplicationQueriesSchemes （Array） 相同的URL Types。参考https://blog.csdn.net/u010828718/article/details/79104266
 
    if (kShowApp_ISHAVE(@"Echo://")) {
        NSLog(@"okkkkkkk is have Echo");
    } else {
        [_array removeObjectAtIndex:0];
    }
    if (kShowApp_ISHAVE(@"365://")) {
         NSLog(@"okkkkkkk is have 365");
    } else {
          [_array removeObjectAtIndex:1];
    }
    if (kShowApp_ISHAVE(@"mqq://")) {
          NSLog(@"okkkkkkk is have QQ");
    } else {
         [_array removeObjectAtIndex:2];
    }
    if (kShowApp_ISHAVE(@"mqzone://")) {
        NSLog(@"okkkkkkk is have QQ空间");
    } else {
        [_array removeObjectAtIndex:3];
    }
    if (kShowApp_ISHAVE(@"wechat://")) {
        NSLog(@"okkkkkkk is have 微信");
    } else {
         [_array removeObjectAtIndex:4];
    }
    if (kShowApp_ISHAVE(@"alipay://")) {
        NSLog(@"okkkkkkk is have 支付宝");
    } else {
        [_array removeObjectAtIndex:5];
    }
*/
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"XJTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:idinifier];
    self.myTableView.sectionIndexColor = [UIColor blackColor];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.tableFooterView = [UIView new];
    //
    _dataArr = [[NSArray alloc]init];
    _allKeysDict = [self createCharacter:_array]; NSLog(@"............%@",_allKeysDict);
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
    
    for (NSDictionary *obj in _array) {
        NSString *name = obj[@"name"];
        [self.dicToArr addObject:name];
    }
    SearchInfoVC *seVC = [[SearchInfoVC alloc] init];
    seVC.searchData = self.dicToArr; //
    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:seVC];
    self.searchVC.searchResultsUpdater = seVC;
//    self.searchVC.searchBar.delegate = self;
    self.searchVC.searchBar.placeholder = @"搜索列表";
    self.searchVC.searchBar.returnKeyType = UIReturnKeyDone;
    [self.searchVC.searchBar sizeToFit];
    self.definesPresentationContext = YES;
//    self.myTableView.tableHeaderView = self.searchVC.searchBar;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchVC;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        self.myTableView.tableHeaderView = self.searchVC.searchBar;
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

-  (void)openScheme:(NSString *)scheme {
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:scheme];
    if ([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [app openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"open   %@ suc 1,err 0 show :%d",scheme,success);
        }];
    } else {
        if ([app canOpenURL:url]) {
            BOOL success = [app openURL:url];
             NSLog(@"open   %@:%d",scheme,success);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
