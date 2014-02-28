//
//  World.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/17/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "World.h"

static const float g = 0.02f;

@implementation World

-(id)initFromLevel:(NSString*)levelPath {
    if (self = [super init]) {
//        NSLog(@"world loaded");
        _atGoal = NO;
        NSString* goalPath = @"NONE";
        
        if ([levelPath isEqualToString:[[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"]]) {
            goalPath = [[NSBundle mainBundle] pathForResource:@"L2" ofType:@"txt"];
        }
        
        if ([levelPath isEqualToString:[[NSBundle mainBundle] pathForResource:@"L2" ofType:@"txt"]]) {
            goalPath = [[NSBundle mainBundle] pathForResource:@"L3" ofType:@"txt"];
        }
        
        if ([levelPath isEqualToString:[[NSBundle mainBundle] pathForResource:@"L3" ofType:@"txt"]]) {
            goalPath = [[NSBundle mainBundle] pathForResource:@"L4" ofType:@"txt"];
        }
        
        if ([levelPath isEqualToString:[[NSBundle mainBundle] pathForResource:@"L4" ofType:@"txt"]]) {
            goalPath = [[NSBundle mainBundle] pathForResource:@"L5" ofType:@"txt"];
        }
        
        if ([levelPath isEqualToString:[[NSBundle mainBundle] pathForResource:@"L5" ofType:@"txt"]]) {
            goalPath = [[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"];
        }
        
        _tm = [[TileMap alloc] initWithFile:levelPath withTileSize:32 atOrigin:CGPointMake(0.0, 0.0)];
        
        _walls = [[NSMutableArray alloc]init];
        
        for (int i = [_tm levelByLines].count-1; i>=0; i-=1) {
            NSString* line = [_tm.levelByLines objectAtIndex:i];
            
            for (int j = 0; j < line.length; j++) {
                unichar character = [line characterAtIndex:j];
                CGPoint pos = [_tm positionFromTile:CGPointMake(j, [_tm levelByLines].count-1-i)];
                
                if (character == 'w') {
                    SKSpriteNode* wall = [[SKSpriteNode alloc]initWithImageNamed:@"wall.jpg"];
                    wall.position = pos;
                    [self addChild:wall];
                    [self.walls addObject:wall];
                }
                else if (character == 's') {
                    self.player = [[Player alloc]initWithPosition:pos];
                    _player.position = pos;
                    [self addChild:_player];
                }
                else if (character == 'g') {
                    Goal* goal = [[Goal alloc]initWithPosition:pos withPathTo:goalPath];
                    _goal = goal;
                    [self addChild:goal];

                }
            }
        }
        
        _ghosts = [[NSMutableArray alloc]init];
        _ghostPaths = [[NSMutableArray alloc]init];
        NSMutableArray* path0 = [[NSMutableArray alloc]init];
        [_ghostPaths addObject:path0];
    }
    
    return self;
}

-(void)updatePlayerPosition:(Player*)player {
    CGPoint desPos = [self.player desirePositionWithGravity:g];
    player.temp.position = desPos;
    NSArray *sTiles = [_tm getTilesAroundTile:[_tm tileFromPosition:player.temp.position]];
    
    
    for (NSValue* val in sTiles){
        CGPoint tile = [val CGPointValue];
        CGPoint tilePos = [_tm positionFromTile:tile];
        
        for (SKSpriteNode* wall in _walls) {
            if (wall.position.x == tilePos.x && wall.position.y == tilePos.y) {
                [player resolveCollisionWithWall:wall];
            }
        }
        
        if (_goal.position.x == tilePos.x && _goal.position.y == tilePos.y) {
            if ([_player didPlayerReachGoal:_goal]) {
                _atGoal = YES;
            }
        }
        
    }
    
    player.position = player.temp.position;
    
    [[_ghostPaths lastObject] addObject:[NSValue valueWithCGPoint:player.position]];
}

-(void)updateGhosts {
    for (Ghost* ghost in _ghosts) {
        [ghost updateGhostToFrame:_currentFrame];
    }
}

-(void)updateWorld {
    [self updatePlayerPosition:_player];
    [self updateGhosts];
    _currentFrame += 1;
}

@end
