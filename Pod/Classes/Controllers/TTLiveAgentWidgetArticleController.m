//
//  TTLiveAgentWidgetArticleControllerViewController.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidgetArticleController.h"
#import "TTLiveAgentWidgetArticleCell.h"

@interface TTLiveAgentWidgetArticleController ()

@end

@implementation TTLiveAgentWidgetArticleController

NSString * const kLAArticleCellIdentifier = @"TTLiveAgentWidgetArticleCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    
    [self setupViews];
    
}

- (void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delaysContentTouches = NO;
    self.tableView.estimatedRowHeight = 120.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[TTLiveAgentWidgetArticleCell class] forCellReuseIdentifier:kLAArticleCellIdentifier];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTLiveAgentWidgetArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:kLAArticleCellIdentifier];
    cell.article = self.article;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell layoutIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
