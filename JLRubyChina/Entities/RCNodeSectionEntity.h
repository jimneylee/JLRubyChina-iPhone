//
//  RCNodeSectionEntity.h
//  JLRubyChina
//
//  Created by Ken_lu on 12/26/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface RCNodeSectionEntity : JLNimbusEntity

@property (nonatomic, assign) NSUInteger sectionId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSMutableArray* nodesArray;

@end
