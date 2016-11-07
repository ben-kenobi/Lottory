//
//  YFLuckVC.m
//  day21-ui-lottery03
//
//  Created by apple on 15/10/19.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "YFLuckVC.h"
#import  "YFWheel.h"
@interface YFLuckVC ()
@property (nonatomic,weak)YFWheel *wheel;

@end

@implementation YFLuckVC

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    YFWheel *wheel=[[YFWheel alloc] init];
    [self.view addSubview:wheel];
    self.wheel=wheel;
    [wheel setBackgroundColor:[UIColor randomColor]];
    [wheel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.height.equalTo(self.view.mas_width);
    }];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
}
@end
