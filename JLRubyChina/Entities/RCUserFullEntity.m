//
//  RCUserEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCUserFullEntity.h"
#import "NSString+stringFromValue.h"

//"user":
//"location": "鍖椾含",
//"company": "",
//"twitter": "chloerei",
//"website": "http://chloerei.com",
//"bio": "Twitter @chloerei\r\n\r\n鎴戝啓浜嗚繖浜涚綉绔欙細\r\n\r\nhttp://writings.io\r\nhttp://codecampo.com ",
//"tagline": "涓笅姘村钩 Rails 绋嬪簭鍛�",
//"github_url": "https://github.com/chloerei",
//"email": "chloerei@gmail.com",
//"gravatar_hash": "5aec84cd0b5479a0d1d89b6ffa2a9a20",
//"avatar_url": "http://ruby-china.org/avatar/5aec84cd0b5479a0d1d89b6ffa2a9a20.png?s=120",
@implementation RCUserFullEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.name = [NSString stringFromValue:dic[@"name"]];
        self.location = [NSString stringFromValue:dic[@"location"]];
        self.company = [NSString stringFromValue:dic[@"company"]];
        self.twitter = [NSString stringFromValue:dic[@"twitter"]];
        self.website = [NSString stringFromValue:dic[@"website"]];
        self.introduce = [NSString stringFromValue:dic[@"bio"]];
        self.tagline = [NSString stringFromValue:dic[@"tagline"]];
        self.githubUrl = [NSString stringFromValue:dic[@"github_url"]];
        self.email = [NSString stringFromValue:dic[@"email"]];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCUserFullEntity* entity = [[RCUserFullEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
