//
//  YFWheel.m
//  day21-ui-lottery03
//
//  Created by apple on 15/10/19.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "YFWheel.h"
#import "YFTabBar.h"

#define COUNT 12

@interface YFWheel()<UIAlertViewDelegate>
@property (nonatomic,weak)UIView *view;
@property (nonatomic,weak)UIImageView *wheel;
@property (nonatomic,weak)UIButton *go;
@property (nonatomic,strong)CADisplayLink *link;
@property (nonatomic,weak)UIButton *selected;
@end

@implementation YFWheel


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self initState];
}


-(CADisplayLink *)link{
    if(!_link){
        _link=[CADisplayLink displayLinkWithTarget:self selector:@selector(onBtnClicked:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}

-(void)onBtnClicked:(id)sender{
    if(self.link==sender) {
        self.wheel.transform=CGAffineTransformRotate(self.wheel.transform,- M_PI/600);
    }else if(self.go==sender){
        if(![self.wheel.layer animationForKey:@"abc"]){
            CABasicAnimation *ba=[[CABasicAnimation alloc] init];
            ba.keyPath=@"transform.rotation";
            ba.toValue=@(2*M_PI-self.selected.tag*2*M_PI/COUNT);
            ba.duration=2;
            [ba setFillMode:kCAFillModeForwards];
            [ba setRemovedOnCompletion:NO];
            [self.wheel.layer addAnimation:ba forKey:@"abc"];
            [self.wheel setUserInteractionEnabled:NO];
            [self.link setPaused:YES];
            dispatch_after(dispatch_time(0, 1e9*ba.duration), dispatch_get_main_queue(), ^{
                self.wheel.transform=CGAffineTransformMakeRotation([ba.toValue doubleValue]);
                UIAlertView *aler=[[UIAlertView alloc] initWithTitle:@"alert" message:@"wewerwe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:0, nil];
                [aler show];
            }) ;
        }
        
    }else{
        self.selected.selected=NO;
        self.selected=sender;
        self.selected.selected=YES;
    }
}

-(void)initUI{
    UIView *view =[[UIView alloc] init];
    [self addSubview:view];
    self.view=view;
    view.layer.contents=(__bridge id)[[UIImage imageNamed:@"LuckyBaseBackground"]CGImage];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.right.top.bottom.equalTo(@0);
    }];
    
    UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LuckyRotateWheel"]];
    [self.view addSubview:wheel];
    [wheel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    self.wheel=wheel;

    
    UIButton *go=[[UIButton alloc] init];
    [go setImage:[UIImage imageNamed:@"LuckyCenterButton"] forState:UIControlStateNormal];
    [go setImage:[UIImage imageNamed:@"LuckyCenterButtonPressed"] forState:UIControlStateHighlighted];
    self.go=go;
    [self.view addSubview:go];
    [go mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    [go addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img=[UIImage imageNamed:@"LuckyAstrology"];
    UIImage *imgpre=[UIImage imageNamed:@"LuckyAstrologyPressed"];
    UIImage *imgsel=[UIImage imageNamed:@"LuckyRototeSelected"];
    for(int i=0;i<COUNT;i++){
        UIButton *btn=[[YFTabButton alloc] init];
        [btn setBackgroundImage:imgsel forState:UIControlStateSelected];
        btn.size=imgsel.size;
        [btn setImage:[img clipBy:i count:COUNT scale:2] forState:UIControlStateNormal];
        [btn setImage:[imgpre clipBy:i count:COUNT scale:2] forState:UIControlStateSelected];
        [wheel addSubview:btn];
        btn.center=wheel.innerCenter;
        btn.transform=CGAffineTransformMakeRotation(M_PI*2/COUNT*i);
        btn.tag=i;
        btn.layer.anchorPoint=(CGPoint){.5,1};
        [btn setImageEdgeInsets:(UIEdgeInsets){0,0,50,0}];
        [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
}
-(void)initState{
    [self.wheel setUserInteractionEnabled:YES];
    [self.link  setPaused:NO];
    [self.wheel.layer removeAllAnimations];
}

-(instancetype)init{
    if(self = [super init]){
        [self initUI];
        [self initState];
    }
    return self;
}

@end
