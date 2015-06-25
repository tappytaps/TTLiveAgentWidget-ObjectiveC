//
//  TTLiveAgentWidgetArticleControllerViewController.m
//  Pods
//
//  Created by Lukas Boura on 22/06/15.
//
//

#import "TTLiveAgentWidgetArticleControllerViewController.h"

@interface TTLiveAgentWidgetArticleControllerViewController ()

@end

@implementation TTLiveAgentWidgetArticleControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self release];
}

- (void)loadView {
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    UIView *contentView = [[UIView alloc] initWithFrame:appFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)viewWillLayoutSubviews {
    if (self.articleContentWebView) {
        self.articleContentWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)setupViews {
    self.articleContentWebView = [[UIWebView alloc] init];
    self.articleContentWebView.delegate = self;
    self.articleContentWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSString *content = self.article.content;
    NSString *title = self.article.title;

    NSString *htmlString = [NSString stringWithFormat:@"<div style=\"padding: 0px 5px 5px 5px; font-family: %@; font-size: %i\"><h2 style=\"padding-top: 5px;font-weight: 100; margin-bottom: 0;\">%@</h2><br>%@</div>", @"HelveticaNeue", 16, title, content];
    
    [self.articleContentWebView loadHTMLString:htmlString baseURL:nil];
    self.articleContentWebView.opaque = NO;
    self.articleContentWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.articleContentWebView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
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
