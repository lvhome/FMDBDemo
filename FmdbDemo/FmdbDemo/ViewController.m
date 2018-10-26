//
//  ViewController.m
//  FmdbDemo
//
//  Created by 祥云创想 on 2018/10/26.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "LHDataBaseManager.h"
#import "myTableCell.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITextField * nameTextField;
    UITextField * contentTextField;
}
@property (nonatomic, strong) UITableView * myTableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 88, 80, 40)];
    nameLable.text = @"姓名";
    nameLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLable];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 88, 250, 40)];
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.layer.cornerRadius = 10;
    nameTextField.placeholder = @"输入姓名";
    nameTextField.layer.borderWidth = 1;
    nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:nameTextField];
    
    UILabel * contetLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 88 + 50, 80, 40)];
    contetLable.text = @"爱好";
    contetLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contetLable];
    
    contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 88 + 50, 250, 40)];
    contentTextField.textAlignment = NSTextAlignmentLeft;
    contentTextField.layer.cornerRadius = 10;
    contentTextField.placeholder = @"输入爱好";
    contentTextField.layer.borderWidth = 1;
    contentTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:contentTextField];
    
    UIButton * insertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    insertBtn.frame = CGRectMake(20, 200, ([UIScreen mainScreen].bounds.size.width - 40 - 40)/4, 40);
    insertBtn.backgroundColor = [UIColor redColor];
    [insertBtn setTitle:@"插入" forState:UIControlStateNormal];
    [insertBtn addTarget:self action:@selector(insert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insertBtn];
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(20 + 20 + ([UIScreen mainScreen].bounds.size.width - 40 - 60)/4, 200, ([UIScreen mainScreen].bounds.size.width - 40 - 60)/4, 40);
    selectBtn.backgroundColor = [UIColor redColor];
    [selectBtn setTitle:@"查询" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:selectBtn];
    
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(20 + 40 + 2*([UIScreen mainScreen].bounds.size.width - 40 - 60)/4, 200, ([UIScreen mainScreen].bounds.size.width - 40 - 60 )/4, 40);
    changeBtn.backgroundColor = [UIColor redColor];
    [changeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(updata) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:changeBtn];
    
    UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(20 + 60 + 3*([UIScreen mainScreen].bounds.size.width - 40 - 60)/4, 200, ([UIScreen mainScreen].bounds.size.width - 40 - 60 )/4, 40);
    delBtn.backgroundColor = [UIColor redColor];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:delBtn];
    [delBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myTableView];
    [[LHDataBaseManager shareManager] createDataBaseAndTable];
}

- (void)insert {
    if ([nameTextField.text isEqualToString:@""] || [contentTextField.text isEqualToString:@""]) {
        NSLog(@"不能为空");
    }
    [[LHDataBaseManager shareManager] insetName:nameTextField.text content:contentTextField.text];
    [self.dataArray removeAllObjects];
    self.dataArray = [[LHDataBaseManager shareManager] selectAllContent];
    [self.myTableView reloadData];
    [nameTextField resignFirstResponder];
    [contentTextField resignFirstResponder];
    nameTextField.text = @"";
    contentTextField.text = @"";
}

- (void)updata {
    if ([nameTextField.text isEqualToString:@""] || [contentTextField.text isEqualToString:@""]) {
        NSLog(@"不能为空");
    }
    [[LHDataBaseManager shareManager] updataDataWithName:nameTextField.text content:contentTextField.text];
    [self.dataArray removeAllObjects];
     self.dataArray = [[LHDataBaseManager shareManager] selectAllContent];
    [self.myTableView reloadData];
    [nameTextField resignFirstResponder];
    [contentTextField resignFirstResponder];
    nameTextField.text = @"";
    contentTextField.text = @"";
}

- (void)select {
    self.dataArray = [[LHDataBaseManager shareManager] selectAllContent];
    [self.myTableView reloadData];
    [nameTextField resignFirstResponder];
    [contentTextField resignFirstResponder];
}

- (void)delete {
    if ([nameTextField.text isEqualToString:@""]) {
        NSLog(@"不能为空");
    }
    [[LHDataBaseManager shareManager] deleteDataByName:nameTextField.text];
    [self.dataArray removeAllObjects];
    self.dataArray = [[LHDataBaseManager shareManager] selectAllContent];
    [self.myTableView reloadData];
    [nameTextField resignFirstResponder];
    [contentTextField resignFirstResponder];
    nameTextField.text = @"";
    contentTextField.text = @"";
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 260, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 260) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
    }
    return _myTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"myTableCell" owner:self options:nil] firstObject];
    }
    UILabel * nameLable = (UILabel *)[cell viewWithTag:1];
    UILabel * contentLable = (UILabel *)[cell viewWithTag:2];
    
    if (indexPath.row > 0) {
        NSDictionary * dict = self.dataArray[indexPath.row - 1];
        nameLable.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        contentLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
