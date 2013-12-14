//
//  UIImage+nimbusImageNamed.m
//  SinaMBlogNimbus
//
//  Created by Lee jimney on 10/7/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "UIImage+nimbusImageNamed.h"

@implementation UIImage (nimbusImageNamed)

+ (UIImage*)nimbusImageNamed:(NSString*)imageName
{
    NSString* imagePath = NIPathForBundleResource(nil, imageName);
    UIImage* image = [[Nimbus imageMemoryCache] objectWithName:imagePath];
    if (nil == image) {
        image = [UIImage imageWithContentsOfFile:imagePath];
        // And then store it in memory.
        [[Nimbus imageMemoryCache] storeObject:image withName:imagePath];
    }
    return image;
}

@end
