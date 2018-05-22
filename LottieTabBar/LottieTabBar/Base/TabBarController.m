//
//  TabBarController.m
//  LottieTabBar
//
//  Created by paperclouds on 2018/5/22.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import "TabBarController.h"
#import <objc/runtime.h>
#import "BaseNavigationController.h"
#import <Lottie/LOTAnimationView.h>

#define UIColorFromRGB(rgbValue)    [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TabBarController ()

@property (nonatomic, copy) NSArray *titleArray; //按钮标题
@property (nonatomic, copy) NSArray *iconArray; //未选中按钮图标
@property (nonatomic, copy) NSArray *seletedIconArray; //选中按钮图标
@property (nonatomic, copy) NSArray *controllersArray; //控制器
@property (nonatomic, assign) NSInteger currentIndex; //当前选中下标
@property (nonatomic, strong) LOTAnimationView *animation;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setViewControllers:[self getViewControllers] animated:YES];
    self.selectedIndex = 0;
}

- (NSArray *)getViewControllers{
    self.titleArray = @[@"首页",@"分类",@"订单",@"我的"];
    self.iconArray = @[@"tab_home_nor",@"tab_category_nor",@"tab_order_nor",@"tab_my_nor"];
    self.seletedIconArray = @[@"tab_home",@"tab_category",@"tab_order",@"tab_my"];
    self.controllersArray = @[@"HomeViewController",@"CategoryViewController",@"OrderViewController",@"MyViewController"];
    NSMutableArray *navArray = [NSMutableArray array];
    for (int i = 0; i < self.controllersArray.count; i++) {
        const char *className = [self.controllersArray[i] cStringUsingEncoding:NSASCIIStringEncoding];
        Class newClass = objc_getClass(className);
        UIViewController *controller = [newClass new];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:controller];
        controller.title = self.titleArray[i];
        
        UITabBarItem *tabbar = [[UITabBarItem alloc]initWithTitle:self.titleArray[i] image:[UIImage imageNamed:self.iconArray[i]] selectedImage:[UIImage imageNamed:self.seletedIconArray[i]]];
        tabbar.selectedImage = [tabbar.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabbar.image = [tabbar.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabbar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x505050)} forState:UIControlStateNormal];
        [tabbar setTitleTextAttributes:@{NSForegroundColorAttributeName:  UIColorFromRGB(0x23d41e)} forState:UIControlStateSelected];
        
        tabbar.tag = i;
        controller.tabBarItem = tabbar;
        [navArray addObject:nav];
    }
    return navArray;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSArray *array = self.tabBar.subviews;
    UIView *view = array[item.tag+1];
    UIButton *btn = view.subviews.firstObject;
    [self.animation removeFromSuperview];
    NSString *name = self.seletedIconArray[item.tag];
    CGFloat scale = [[UIScreen mainScreen]scale];
    name = 3.0 == scale?[NSString stringWithFormat:@"%@@3x",name] : [NSString stringWithFormat:@"%@@2x",name];
    LOTAnimationView *animation = [LOTAnimationView animationNamed:name];
    [btn addSubview:animation];
    animation.bounds = CGRectMake(0, 0, btn.bounds.size.width, btn.bounds.size.width*68/140.f);
    animation.center = CGPointMake(btn.bounds.size.width/2, btn.bounds.size.height/2);
    [animation playWithCompletion:^(BOOL animationFinished) {
        
    }];
    self.animation = animation;
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
