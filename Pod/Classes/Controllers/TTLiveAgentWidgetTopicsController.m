//
//  TTLiveAgentWidgetTopicsController.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidgetTopicsController.h"

@interface TTLiveAgentWidgetTopicsController ()

@end

@implementation TTLiveAgentWidgetTopicsController {
    dispatch_once_t onceReloadToken;
}

NSString * const kLATopicCellIdentifier = @"TTLiveAgentWidgetArticleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Contact us", "Contact us nav bar title");
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", "Close button") style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    } else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    }
    
    if (self.tintColor) {
        self.navigationController.navigationBar.tintColor = self.tintColor;
    }
    
    if (self.barColor) {
        self.navigationController.navigationBar.barTintColor = self.barColor;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    if (self.titleColor) {
        self.navigationController.navigationBar.titleTextAttributes = @{
                                                                        NSForegroundColorAttributeName: self.titleColor
                                                                        };
    }
    
    [self setupViews];
    
}

- (void)closeController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delaysContentTouches = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLATopicCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    dispatch_once(&onceReloadToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.topics) {
        return self.topics.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Topic of your message", comment: "Choose topic table view section title.");
        default:
            return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Selecting the right topic helps us to get back to you faster.", comment: "Choose topic table view footer message.");
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLATopicCellIdentifier forIndexPath:indexPath];
    
    [self configureTopicCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)configureTopicCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    TTLiveAgentWidgetSupportTopic *topic = self.topics[indexPath.row];
    
    NSBundle *bundle = [NSBundle bundleForClass:[TTLiveAgentWidgetTopicsController class]];
    
    cell.imageView.image = [UIImage imageNamed:@"ic_topic" inBundle:bundle compatibleWithTraitCollection:nil];
    cell.textLabel.text = topic.title;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell layoutIfNeeded];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TTLiveAgentWidgetQuestionsController *lawq = [[TTLiveAgentWidgetQuestionsController alloc] init];
    lawq.topic = self.topics[indexPath.row];
    
    [self.navigationController pushViewController:lawq animated:YES];
    
}

@end
