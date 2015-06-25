//
//  TopicQuestionTableViewCell.m
//  Pods
//
//  Created by Lukas Boura on 25/06/15.
//
//

#import "TopicQuestionTableViewCell.h"


@implementation TopicQuestionTableViewCell

@synthesize topicQestionLabel;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.topicQestionLabel = [[UILabel alloc] init];
    
    self.topicQestionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topicQestionLabel.numberOfLines = 0;
    self.topicQestionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.topicQestionLabel.backgroundColor = [UIColor clearColor];
    self.topicQestionLabel.font = [UIFont systemFontOfSize:16];
    
    [self.contentView addSubview:self.topicQestionLabel];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topicQestionLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-12.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topicQestionLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:12.0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topicQestionLabel attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-16.0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topicQestionLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:16.0];
    
    [self.contentView addConstraints:@[
                                       topConstraint,
                                       bottomConstraint,
                                       leadingConstraint,
                                       trailingConstraint
                                       ]];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.topicQestionLabel setNeedsLayout];
    [self.topicQestionLabel layoutIfNeeded];
    
    self.topicQestionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.topicQestionLabel.frame);
    
}

@end
