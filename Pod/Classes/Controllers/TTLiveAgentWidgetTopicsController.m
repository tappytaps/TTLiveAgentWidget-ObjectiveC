//
//  TTLiveAgentWidgetTopicsController.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidgetTopicsController.h"

@interface TTLiveAgentWidgetTopicsController ()

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;

@end

@implementation TTLiveAgentWidgetTopicsController

NSString * const kLATopicCellIdentifier = @"TTLiveAgentWidgetArticleCell";

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.offscreenCells = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Contact Us", "Contact us nav bar title");
    
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
    
    [self setupViews];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)closeController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delaysContentTouches = YES;
    
    if ([self.tableView respondsToSelector:@selector(estimatedRowHeight)]){
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    [self.tableView registerClass:[TopicQuestionTableViewCell class] forCellReuseIdentifier:kLATopicCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            return NSLocalizedString(@"Choose topic of your message", comment: "Choose topic table view section title.");
        default:
            return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"We answer to every message you sent to us. Correct topic helps us to get back to you faster.", comment: "Choose topic table view footer message.");
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLATopicCellIdentifier forIndexPath:indexPath];
    
    [self configureTopicCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureTopicCell:(TopicQuestionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TTLiveAgentWidgetSupportTopic *topic = self.topics[indexPath.row];
    
    cell.topicQestionLabel.text = topic.title;
    
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
        TopicQuestionTableViewCell *cell = [self.offscreenCells objectForKey:kLATopicCellIdentifier];
        if (!cell) {
            cell = [[TopicQuestionTableViewCell alloc] init];
            [self.offscreenCells setObject:cell forKey:kLATopicCellIdentifier];
        }
        
        [self configureTopicCell:cell atIndexPath:indexPath];
        
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    } else {
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TTLiveAgentWidgetQuestionsController *lawq = [[[TTLiveAgentWidgetQuestionsController alloc] init] autorelease];
    lawq.topic = self.topics[indexPath.row];
    
    [self.navigationController pushViewController:lawq animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
