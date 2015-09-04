//
//  ViewController.m
//  Menu
//
//  Created by fcx on 15/7/31.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "ViewController.h"
#import "MenuPopover.h"
#import "MenuScrollView.h"
#import "FCXPathMenu.h"
#import "FCXPathButtonItem.h"

@interface ViewController ()
{
    FCXPathMenu *pathMenu;
}
@property (nonatomic, strong)MenuPopover *menuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width - 80, 0, 80, 64);
    [btn setTitle:@"菜单" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 300);
    scrollView.backgroundColor = [UIColor magentaColor];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        if (i == 0) {
            view.backgroundColor = [UIColor greenColor];
        }else if (i == 1){
            view.backgroundColor = [UIColor lightGrayColor];
        }else {
            view.backgroundColor = [UIColor yellowColor];
        }
        [scrollView addSubview:view];
    }
    
    MenuScrollView *menu = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 200 - 40, scrollView.frame.size.width, 40) dataScrollView:scrollView];
    menu.backgroundColor = [UIColor purpleColor];
    menu.bottomLineIndentation = 10;
    menu.bottomLineHeight = 2;
    menu.bottomLineColor = [UIColor redColor];
    menu.titleArray = @[@"111111", @"2222", @"3333"];
    [self.view addSubview:menu];
    
    
    FCXPathButtonItem *pathItem1 = [FCXPathButtonItem buttonWithType:UIButtonTypeCustom];
    pathItem1.expandAngle = M_PI_4;
    [pathItem1 setBackgroundImage:[UIImage imageNamed:@"PathEdit"] forState:UIControlStateNormal];
    pathItem1.tag = 1;
    
    FCXPathButtonItem *pathItem2 = [FCXPathButtonItem buttonWithType:UIButtonTypeCustom];
    [pathItem2 setBackgroundImage:[UIImage imageNamed:@"PathEdit"] forState:UIControlStateNormal];
    pathItem2.expandAngle = M_PI_2;
    pathItem2.tag = 2;
    
    FCXPathButtonItem *pathItem3 = [FCXPathButtonItem buttonWithType:UIButtonTypeCustom];
    [pathItem3 setBackgroundImage:[UIImage imageNamed:@"PathEdit"] forState:UIControlStateNormal];
    pathItem3.tag = 3;
    pathItem3.expandAngle = M_PI_4 * 3;
    
    scrollView.userInteractionEnabled = YES;
    pathMenu = [[FCXPathMenu alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 72)/2.0, (self.view.frame.size.height - 72)/2.0, 72, 72) superView:self.view menusArray:@[pathItem1, pathItem2, pathItem3]];
    pathMenu.menuClickBlock = ^(NSInteger buttonIndex){
        NSLog(@"index %d", buttonIndex);
    };
}

- (void)buttonAction {

    [self.menuView show];
}


- (MenuPopover *)menuView {

    if (!_menuView) {
        _menuView = [[MenuPopover alloc] initWithMenuFrame:CGRectMake(self.view.frame.size.width - 95.5 - 10, 64, 95.5, 99) menuClickBlock:^(NSInteger buttonIndex) {
            NSLog(@"index %ld", buttonIndex);
        }];
    }
    return _menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
