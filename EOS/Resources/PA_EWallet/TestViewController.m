//
//  TestViewController.m
//  EOS
//
//  Created by peng zhu on 2018/9/19.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

#import "TestViewController.h"
#import "BLTWalletIO.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *sn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [sn setBackgroundColor:[UIColor redColor]];
    [sn addTarget:self action:@selector(sn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sn];
    
    UIButton *pub = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 100, 40)];
    [pub setBackgroundColor:[UIColor greenColor]];
    [pub addTarget:self action:@selector(pub) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pub];
    
    // Do any additional setup after loading the view.
}

- (void)sn {
    [[BLTWalletIO shareInstance] getSN:^(NSString *SN, NSString *SN_sig) {
        
    } failed:^(NSString *failedReason) {
        
    }];
}

- (void)pub {
    [[BLTWalletIO shareInstance] getPubKey:^(NSString *pubkey, NSString *pubkey_sig) {
        
    } failed:^(NSString *failedReason) {
        
    }];
}

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
