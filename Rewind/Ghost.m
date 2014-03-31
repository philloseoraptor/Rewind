//
//  Ghost.m
//  Rewind
//
//  Created by PHILLIP SEO on 2/28/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "Ghost.h"
#import "Player.h"

@implementation Ghost


-(id)initWithPath:(NSMutableArray*)path startFrame:(int)startFrame {
    
    if (self = [super initWithImageNamed:@"ghost.tif"]) {
        _path = path;
        _startFrame = startFrame;
        self.position = [[_path firstObject]CGPointValue];
    }
    return self;
}

-(void)updateGhostToFrame:(int)frame {
    
    if (frame - _startFrame < _path.count && frame - _startFrame >= 0) {
        self.position = [[_path objectAtIndex:frame - _startFrame]CGPointValue];
    }
    
    else if (frame - _startFrame >= _path.count) {
        self.position = [[_path lastObject]CGPointValue];
    }
    
    else if (frame - _startFrame < 0) {
        self.position = CGPointMake(100000, 100000);
    }
    
}

@end
