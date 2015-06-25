//
//  ViewController.m
//  TTLiveAgentWidgetObjCExample
//
//  Created by Lukas Boura on 22/06/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

#import "ViewController.h"
#import "TTLiveAgentWidget.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[TTLiveAgentWidget sharedInstance] openFromController:self withStyle:Present];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
