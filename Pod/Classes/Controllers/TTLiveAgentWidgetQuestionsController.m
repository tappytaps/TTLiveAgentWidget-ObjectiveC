//
//  TTLiveAgentWidgetQuestionsController.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidgetQuestionsController.h"
#import "TTLiveAgentWidgetArticleController.h"

@interface TTLiveAgentWidgetQuestionsController ()
@end


@implementation TTLiveAgentWidgetQuestionsController {
    dispatch_once_t onceReloadToken;
}

NSString * const kLAQuestionCellIdentifier = @"TTLiveAgentWidgetQuestionCell";
NSString * const kLAIconCellIdentifier = @"TTLiveAgentWidgetIconCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.supportWidget = [TTLiveAgentWidget sharedInstance];
    
    self.navigationItem.title = self.topic.title;
   
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
        
    NSArray *unsortedArticles = [self.supportWidget.dataManager getArticlesByKeyword:self.topic.key];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArticles = [unsortedArticles sortedArrayUsingDescriptors:sortDescriptors];
    
    self.articles = sortedArticles;
    
    [self setupViews];
    
}

- (void)closeController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delaysContentTouches = NO;
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLAQuestionCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLAIconCellIdentifier];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        if (self.articles) {
            return self.articles.count > self.supportWidget.maxArticlesCount ? self.supportWidget.maxArticlesCount : self.articles.count;
        }
        return 0;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (self.articles.count == 0) {
                return nil;
            } else {
                return NSLocalizedString(@"Popular questions", comment: "Popular questions table view section header title.");
            }
            break;
        
        case 1:
            return  NSLocalizedString(@"Contact us", comment: "Contact us table view section header title.");
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.articles == nil || self.articles.count == 0) {
            return 0.01;
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLAQuestionCellIdentifier];
        [self configureQuestionCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLAIconCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSBundle *bundle = [NSBundle bundleForClass:[TTLiveAgentWidgetQuestionsController class]];
        
        cell.imageView.image = [[UIImage imageNamed:@"ic_email" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        if (self.tintColor) {
            cell.imageView.tintColor = self.tintColor;
        }
        
        cell.textLabel.text = NSLocalizedString(@"Send email to support", "Send support email table view row.");
        
        return cell;
    }
}

- (void)configureQuestionCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    TTLiveAgentWidgetSupportArticle *article = self.articles[indexPath.row];
    
    NSBundle *bundle = [NSBundle bundleForClass:[TTLiveAgentWidgetQuestionsController class]];
    
    cell.imageView.image = [UIImage imageNamed:@"ic_question" inBundle:bundle compatibleWithTraitCollection:nil];
    cell.textLabel.text = article.title;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        
        TTLiveAgentWidgetArticleController *lawa = [[TTLiveAgentWidgetArticleController alloc] init];
        lawa.article = self.articles[indexPath.row];
        lawa.navigationItem.title = self.topic.title;
        
        [self.navigationController pushViewController:lawa animated:YES];
        
    } else if (indexPath.section == 1) {
        [self.supportWidget openEmailComposerFromController:self withTopic:self.topic];
    }
}

@end
