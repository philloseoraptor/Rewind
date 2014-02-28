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
        
        _timeData = [[NSMutableArray alloc]initWithCapacity:1200];
        for (int i = 0; i < _timeData.count; i++) {
            NSMutableArray* frameData = [[NSMutableArray alloc]init];
            NSMutableArray* ghostsInFrame = [[NSMutableArray alloc]init];
            [frameData addObject:ghostsInFrame];
            [_timeData insertObject:frameData atIndex:i];
        }
        
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
        
        _currentFrame = 0;
    }
    
    return self;
}

-(BOOL)isVal:(NSValue*)value inMutArray:(NSMutableArray*)array {
    for (NSValue* val in array) {
        if (![value isEqualToValue:value]) {
            return NO;
        }
    }
    
    return YES;
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
}

-(void)updateTimeData {
    
    [[[_timeData objectAtIndex:_currentFrame] objectAtIndex:0] addObject:[NSValue valueWithCGPoint:_player.position]];
    
    if (_currentFrame > 0) {
        if ([[[_timeData objectAtIndex:_currentFrame-1]objectAtIndex:0]count] > [[[_timeData objectAtIndex:_currentFrame]objectAtIndex:0]count]) {
            for (NSValue* val in [[_timeData objectAtIndex:_currentFrame-1]objectAtIndex:0]) {
                if (![self isVal:val inMutArray:[[_timeData objectAtIndex:_currentFrame]objectAtIndex:0]]) {
                    <#statements#>
                }
            }
        }
    }
    
    _currentFrame += _currentFrame;
    
}

@end
