//
//  rootViewController.m
//  MyFaceRecognize
//
//  Created by matrix on 15/11/19.
//  Copyright © 2015年 matrix. All rights reserved.
//

#import "rootViewController.h"
#import "recognizViewController.h"

@interface rootViewController ()

@end

@implementation rootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50)];
    
    self.navBar.tintColor = [UIColor grayColor];
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"face recoginze"];
    [self.navBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationAddButton:)];
    navigationBarTitle.rightBarButtonItem = item;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    UIBarButtonItem *itemback = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(navigationBackButton:)];
    navigationBarTitle.leftBarButtonItem = itemback;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)navigationAddButton:(id) sender{
//    recognizViewController *controller = [[recognizViewController alloc] init];
//    if(self.navigationController == nil){
//        NSLog(@"add");
//    }
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navigationBackButton:(id) sender{
    
//    if (self.navigationController != nil) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }

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
