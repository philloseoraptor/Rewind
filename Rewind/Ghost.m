//
//  Ghost.m
//  Rewind
//
//  Created by PHILLIP SEO on 2/28/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "Ghost.h"

@implementation Ghost


-(id)initWithPath:(NSMutableArray*)path {
    
    if (self = [super initWithImageNamed:@"player.jpg"]) {
        _path = path;
        self.position = [[_path firstObject]CGPointValue];
    }
    return self;
}

-(void)updateGhostToFrame:(int)frame {
    self.position = [[_path objectAtIndex:frame]CGPointValue];
}

@end
