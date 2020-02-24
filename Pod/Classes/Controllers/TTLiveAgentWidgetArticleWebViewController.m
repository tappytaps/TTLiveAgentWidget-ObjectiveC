//
//  TTLiveAgentWidgetArticleWebViewController.m
//  Pods
//
//  Created by Lukas Boura on 15/03/2017.
//
//

#import "TTLiveAgentWidgetArticleWebViewController.h"

@interface TTLiveAgentWidgetArticleWebViewController () <UIWebViewDelegate>

@property UIScrollView *scrollView;
@property UIImageView *imageView;
@property UILabel *label;
@property UIWebView *webView;

@property UIView *contentView;
@property NSLayoutConstraint *webViewHeightConstraint;

@property BOOL observing;

@end

@implementation TTLiveAgentWidgetArticleWebViewController

- (void)loadView {
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    UIView *contentView = [[UIView alloc] initWithFrame:appFrame];
    if (@available(iOS 13.0, *)) {
        contentView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        contentView.backgroundColor = [UIColor whiteColor];
    }
    self.view = contentView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.observing = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    
    [self setupViews];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setupViews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.scrollView];
    
    [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scrollView addSubview:self.contentView];
    
    [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    
    NSBundle *bundle = [NSBundle bundleForClass:[TTLiveAgentWidget class]];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.image = [[UIImage imageNamed:@"ic_question" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageView.tintColor = [TTLiveAgentWidget sharedInstance].iconsColor;
    
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.font = [UIFont systemFontOfSize:17];
    self.label.numberOfLines = 0;
    
    self.webView = [[UIWebView alloc] init];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.webView];

    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24].active = YES;
    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24].active = YES;
    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:17].active = YES;
    [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:19].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:18].active = YES;
    [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-17].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8].active = YES;
    [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15].active = YES;
    
    self.webViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0];
    self.webViewHeightConstraint.active = YES;
    
    self.label.text = self.article.title;
    
    [self renderBody];
}

- (void)renderBody {
    NSString *content = self.article.content;
    
    UIColor *bodyColor;
    
    if (@available(iOS 13.0, *)) {
        bodyColor = [UIColor secondaryLabelColor];
    } else {
        bodyColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    
    // <meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1; minimum-scale=1;'/>
    // <img src='http://lorempixel.com/400/200' />
    
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'><style>*{line-height:1.33;-webkit-text-size-adjust: none;}html{overflow-x: hidden;}body{overflow-x: hidden;padding: 0; margin: 0; font-family: '-apple-system';}a,a:link,a:visited{color: %@ !important;}</style></head><body><div style='font-size: 15px; color: %@;}'>%@</div></body></html>", [self hexFromUIColor:[TTLiveAgentWidget sharedInstance].iconsColor], [self hexFromUIColor:bodyColor], content];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            [self renderBody];
        }
    }
}

- (NSString *)hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#000"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0), (int)((CGColorGetComponents(color.CGColor))[1]*255.0), (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

- (void)startObservingHeight {
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.observing = YES;
}

- (void)stopObservingHeight {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    self.observing = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (keyPath == nil) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webViewHeightConstraint.constant = self.webView.scrollView.contentSize.height;
        self.scrollView.contentSize = self.contentView.bounds.size;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
    self.scrollView.contentSize = self.contentView.bounds.size;
    if (self.observing == NO) {
        [self startObservingHeight];
    }
}

- (void)dealloc {
    [super dealloc];
    [self stopObservingHeight];
}

@end
