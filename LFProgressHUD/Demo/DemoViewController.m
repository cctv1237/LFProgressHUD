//
//  ViewController.m
//  LFProgressHUD
//
//  Created by LongFan on 16/5/18.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#import "DemoViewController.h"
#import "LFProgressHUD.h"

NSString * const kDemoTableViewCell = @"kDemoTableViewCell";

@interface DemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *demoTableView;
@property (nonatomic, strong) NSArray *demoTableDataSource;

@end

@implementation DemoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = NSStringFromClass([LFProgressHUD class]);
    
    [self.view addSubview:self.demoTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoTableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoTableViewCell forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.demoTableDataSource[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self demoShowDone];
            break;
            
        case 1:
            [self demoShowError];
            break;
            
        case 2:
            [self demoShowCustomImage];
            break;
            
        case 3:
            [self demoShowInfinityRollFor3s];
            break;
            
        case 4:
            [self demoShowProgressRoll];
            break;
            
        case 5:
            [self demoShowInfinityRollThenDone];
            break;
            
        default:
            break;
    }
}

#pragma mark - private
- (void)demoShowDone
{
    [LFProgressHUD showHUDWithType:LFProgressHUDTypeDone duration:0.8 contentString:@"Done"];
}

- (void)demoShowError
{
    [LFProgressHUD showHUDWithType:LFProgressHUDTypeError duration:0.8 contentString:@"Error"];
}

- (void)demoShowCustomImage
{
    [LFProgressHUD showHUDWithImage:[UIImage imageNamed:@"yao_ming"] duration:0.8 contentString:@"U ask me?"];
}

- (void)demoShowInfinityRollFor3s
{
    [LFProgressHUD showProgressWithType:LFProgressTypeRollInfinity];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LFProgressHUD dissmiss];
    });
}

- (void)demoShowProgressRoll
{
    [LFProgressHUD showProgressWithType:LFProgressTypeRollProgress];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LFProgressHUD updateProgress:0.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LFProgressHUD updateProgress:0.6];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LFProgressHUD updateProgress:0.9];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LFProgressHUD updateProgress:1];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LFProgressHUD dissmiss];
                    });
                });
            });
        });
    });
}

- (void)demoShowInfinityRollThenDone
{
    [LFProgressHUD showProgressWithType:LFProgressTypeRollInfinity];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LFProgressHUD showHUDWithType:LFProgressHUDTypeDone duration:0.8 contentString:@"Done"];
    });
}

#pragma mark - getters & setters
- (UITableView *)demoTableView
{
    if (_demoTableView == nil) {
        _demoTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _demoTableView.dataSource = self;
        _demoTableView.delegate = self;
        
        [_demoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDemoTableViewCell];
    }
    return _demoTableView;
}

- (NSArray *)demoTableDataSource
{
    if (_demoTableDataSource == nil) {
        _demoTableDataSource = @[@"Show Done",
                                 @"Show Error",
                                 @"Show Custom Image",
                                 @"Show Infinity Roll for 3s",
                                 @"Show Progress Roll",
                                 @"Show Infinity Roll then Done"];
        
    }
    return _demoTableDataSource;
}

@end
