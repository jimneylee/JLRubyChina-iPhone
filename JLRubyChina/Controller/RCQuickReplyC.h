//
//  RCQuickReplyC.h
//  JLRubyChina
//
//  Created by Lee jimney on 12/12/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface RCQuickReplyC : UIViewController<HPGrowingTextViewDelegate>
@property(nonatomic, strong) HPGrowingTextView *textView;
- (id)initWithTopicId:(unsigned long)topicId;
- (void)appendString:(NSString*)string;
@end
