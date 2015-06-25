//
//  TTLiveAgentWidgetQuestionsController.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidgetQuestionsController.h"

@interface TTLiveAgentWidgetQuestionsController ()

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;

@end


@implementation TTLiveAgentWidgetQuestionsController

NSString * const kLAQuestionCellIdentifier = @"TTLiveAgentWidgetQuestionCell";
NSString * const kLAIconCellIdentifier = @"TTLiveAgentWidgetIconCell";

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.offscreenCells = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.supportWidget = [TTLiveAgentWidget sharedInstance];
    
    self.navigationItem.title = self.topic.title;
   
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", "Close button") style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    } else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", "Back button") style:UIBarButtonItemStylePlain target:self action:nil];
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
    
    if (self.barColor) {
        self.navigationController.navigationBar.barStyle = self.barStyle;
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

- (void)loadView {
    if (!self.isViewLoaded) {
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        UIView *contentView = [[UIView alloc] initWithFrame:appFrame];
        contentView.backgroundColor = [UIColor whiteColor];
        self.view = contentView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tableView) {
        
        if (self.contentOffset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView setContentOffset:CGPointMake(0.0, self.contentOffset) animated:NO];
            });
        }
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            dispatch_once(&_onceLoad, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
        
    }
}

- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delaysContentTouches = NO;

    if ([self.tableView respondsToSelector:@selector(estimatedRowHeight)]){
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    [self.tableView registerClass:[TopicQuestionTableViewCell class] forCellReuseIdentifier:kLAQuestionCellIdentifier];
    [self.tableView registerClass:[IconTableViewCell class] forCellReuseIdentifier:kLAIconCellIdentifier];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (self.tableView) {
        [self.tableView reloadData];
    }
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
        TopicQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLAQuestionCellIdentifier];
        
        [self configureQuestionCell:cell atIndexPath:indexPath];
        
        return cell;
    } else {
        IconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLAIconCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSBundle *bundle = [NSBundle bundleForClass:[TTLiveAgentWidgetQuestionsController class]];
        NSString *imagePath = [bundle pathForResource:@"Envelope" ofType:@"png"];
        
        if (imagePath) {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
            cell.iconView.image = image;
        }

        if (self.tintColor) {
            cell.iconView.tintColor = self.tintColor;
        }
        
        cell.titleLabel.text = NSLocalizedString(@"Send email to support", "Send support email table view row.");
        return cell;
    }
}

- (void)configureQuestionCell:(TopicQuestionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    TTLiveAgentWidgetSupportArticle *article = self.articles[indexPath.row];
        
    cell.topicQestionLabel.text = article.title;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        return UITableViewAutomaticDimension;
    }
    
    if (indexPath.section == 0) {
        
        TopicQuestionTableViewCell *cell = [self.offscreenCells objectForKey:kLAQuestionCellIdentifier];
        if (!cell) {
            cell = [[TopicQuestionTableViewCell alloc] init];
            [self.offscreenCells setObject:cell forKey:kLAQuestionCellIdentifier];
        }
        
        [self configureQuestionCell:cell atIndexPath:indexPath];
        
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        CGFloat contentOffset = tableView.contentOffset.y;
        self.contentOffset = contentOffset;
        TTLiveAgentWidgetArticleControllerViewController *lawa = [[[TTLiveAgentWidgetArticleControllerViewController alloc] init] autorelease];
        lawa.article = self.articles[indexPath.row];
        [self.navigationController pushViewController:lawa animated:YES];
    } else if (indexPath.section == 1) {
        [self.supportWidget openEmailComposer:self withTopic:self.topic];
    }
}

@end

@implementation IconTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.titleLabel];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.iconView) {
        self.iconView.frame = CGRectMake(12, 14, self.contentView.frame.size.height - 10, self.contentView.frame.size.height - 28);
    }
    if (self.titleLabel) {
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) + 6, 0, self.contentView.frame.size.width - (CGRectGetMaxX(self.iconView.frame) + 6 + 48), self.contentView.frame.size.height);
    }
}

@end

