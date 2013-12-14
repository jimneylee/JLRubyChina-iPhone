//
// Copyright 2011-2012 Jeff Verkoeyen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "RCUserLauncherButtonView.h"
#import <QuartzCore/QuartzCore.h>
#import "NimbusBadge.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCUserLauncherViewObject

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTitle:(NSString *)title defaultImage:(UIImage *)image imageUrl:(NSString*)imageUrl {
    if ((self = [super initWithTitle:title image:image])) {
        _imageUrl = imageUrl;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)objectWithTitle:(NSString *)title defaultImage:(UIImage *)image imageUrl:(NSString*)imageUrl {
    return [[self alloc] initWithTitle:title defaultImage:image imageUrl:imageUrl];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)buttonViewClass
{
    return [RCUserLauncherButtonView class];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RCUserLauncherButtonView()<NINetworkImageViewDelegate>
@property (nonatomic, strong) NINetworkImageView* networkImageview;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RCUserLauncherButtonView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        
        _networkImageview = [[NINetworkImageView alloc] init];
        _networkImageview.delegate = self;
        // 不需要显示，只需要负责下载图片，实现的有点恶心，但是目前没有更简单的方法，如TTImageView
        //[self.button addSubview:_networkImageview];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)shouldUpdateViewWithObject:(RCUserLauncherViewObject *)object
{
    [super shouldUpdateViewWithObject:object];
    
    if (object.imageUrl.length) {
        // download image to set in button's imageview
        [self.networkImageview setPathToNetworkImage:object.imageUrl];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NINetworkImageViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)networkImageView:(NINetworkImageView *)imageView didLoadImage:(UIImage *)image
{
    if (image) {
        [self.button setImage:image forState:UIControlStateNormal];
        [self.button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
}

@end
