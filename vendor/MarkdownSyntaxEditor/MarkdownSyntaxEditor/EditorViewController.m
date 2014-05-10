//
// Created by azu on 2013/10/26.
//


#import "EditorViewController.h"
#import "MarkdownTextView.h"


@implementation EditorViewController {
    __weak IBOutlet MarkdownTextView *editorTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)textViewDidEndEditing:(UITextView *) textView {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)textViewDidBeginEditing:(UITextView *) textView {
    [self.navigationController setNavigationBarHidden:YES];

}


@end