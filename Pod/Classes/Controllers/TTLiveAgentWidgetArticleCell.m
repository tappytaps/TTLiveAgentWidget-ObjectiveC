//
//  TTLiveAgentWidgetArticleCell.m
//  Pods
//
//  Created by Lukas Boura on 15/03/2017.
//
//

#import "TTLiveAgentWidgetArticleCell.h"


@interface TTLiveAgentWidgetArticleCell () <UIWebViewDelegate>

@property UIImageView *iconImageView;
@property UILabel *titleLabel;
@property UITextView *bodyLabel;

@end

@implementation TTLiveAgentWidgetArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    NSBundle *bundle = [NSBundle bundleForClass:[TTLiveAgentWidgetArticleCell class]];
    UIImage *image = [UIImage imageNamed:@"ic_question" inBundle:bundle compatibleWithTraitCollection:nil];
    
    self.iconImageView = [[UIImageView alloc] initWithImage:image];
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconImageView.contentMode = UIViewContentModeCenter;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    
    self.bodyLabel = [[UITextView alloc] init];
    self.bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.bodyLabel.selectable = YES;
    self.bodyLabel.editable = NO;
    self.bodyLabel.scrollEnabled = NO;
    self.bodyLabel.textContainerInset = UIEdgeInsetsZero;
    self.bodyLabel.textContainer.lineFragmentPadding = 0;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.bodyLabel];
    
    [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24].active = YES;
    [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24].active = YES;
    [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:16].active = YES;
    [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.bodyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8].active = YES;
    [NSLayoutConstraint constraintWithItem:self.bodyLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.bodyLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15].active = YES;
    [NSLayoutConstraint constraintWithItem:self.bodyLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0].active = YES;
    
}

- (void)setArticle:(TTLiveAgentWidgetSupportArticle *)article {
    _article = article;
    self.titleLabel.text = article.title;
    [self updateHTMLBody];
}

- (void)updateHTMLBody {
    
    UIFont *htmlFont = [UIFont systemFontOfSize:15.0];
    NSString *htmlStyle = [NSString stringWithFormat:@"<style>*{line-height:1.4;}p{margin:0; padding:0;}body{padding: 0; margin: 0; font-family: '%@'; font-size: %fpx; color: rgba(0,0,0,0.5);}</style>", htmlFont.fontName, htmlFont.pointSize];
    NSString *htmlString = [self.article.content stringByAppendingString:htmlStyle];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                   options:@{
                                                                             NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                                                                             }
                                                        documentAttributes:nil
                                                                     error:nil];
    
    self.bodyLabel.attributedText = attrStr;
    
}

@end

