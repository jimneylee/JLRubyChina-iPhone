//
//  RCQuickReplyC.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/12/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@protocol RCQuickReplyDelegate;
@interface RCQuickReplyC : UIViewController<HPGrowingTextViewDelegate>

@property(nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, assign) id<RCQuickReplyDelegate> replyDelegate;

- (id)initWithTopicId:(unsigned long)topicId;
- (void)appendString:(NSString*)string;

@end

@protocol RCQuickReplyDelegate <NSObject>
@optional
- (void)didReplySuccess;
- (void)didReplyFailure;
- (void)didReplyCancel;

@end
