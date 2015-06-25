//
//  TTLiveAgentWidgetEmailComposer.m
//  Pods
//
//  Created by Lukas Boura on 24/06/15.
//
//

#import "TTLiveAgentWidgetEmailComposer.h"
#import "TTLiveAgentWidget.h"

@implementation TTLiveAgentWidgetEmailComposer

- (void)show:(UIViewController *)controller withTopic:(TTLiveAgentWidgetSupportTopic *)topic {
    
    if (![TTLiveAgentWidget sharedInstance].supportEmail) {
        NSLog(@"TTLiveAgentWidget - can't open email composer without support email address.");
        return;
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *subject = [TTLiveAgentWidget sharedInstance].supportEmailSubject;
        NSString *emailAddress = [TTLiveAgentWidget sharedInstance].supportEmail;
        NSDictionary *footDic = [TTLiveAgentWidget sharedInstance].supportEmailFooter;
        NSString *emailBody = @"\n\n\n\n------";
        
        for (id key in footDic) {
            NSString *item = [NSString stringWithFormat:@"\n%@: %@", (NSString *)key, (NSString *)footDic[key]];
            emailBody = [emailBody stringByAppendingString:item];
        }
        
        if (topic) {
            NSString *item = [NSString stringWithFormat:@"\nTopic: %@", topic.title];
            emailBody = [emailBody stringByAppendingString:item];
        }
        
        MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        [mailController setSubject:subject];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:@[emailAddress]];
        [mailController setMessageBody:emailBody isHTML:NO];
        
        [controller presentViewController:mailController animated:YES completion:nil];
        
    } else {
        NSLog(@"TTLiveAgentWidget - can not send email");
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", error.localizedDescription);
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
