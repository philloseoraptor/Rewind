//
//  Goal.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/22/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "Goal.h"

@implementation Goal

-(id) initWithPosition:(CGPoint)position withPathTo:(NSString*)path {
    
    if (self = [super initWithImageNamed:@"goal.tif"]) {
        self.position = position;
        self.toPath = path;
    }
    
    return self;
}

@end
