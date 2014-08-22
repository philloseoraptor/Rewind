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
            goalPath = [[NSBundle mainBundle] pathForResource:@"L6" ofType:@"txt"];
        }
        
        if ([levelPath isEqualToString:[[NSBundle mainBundle] pathForResource:@"L6" ofType:@"txt"]]) {
            goalPath = [[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"];
        }
        
        _tm = [[TileMap alloc] initWithFile:levelPath withTileSize:32 atOrigin:CGPointMake(0.0, 0.0)];
        
        SKSpriteNode* lButton = [[SKSpriteNode alloc] initWithImageNamed:@"LeftButton.tif"];
        SKSpriteNode* rButton = [[SKSpriteNode alloc] initWithImageNamed:@"RightButton.tif"];
        SKSpriteNode* rewButton = [[SKSpriteNode alloc] initWithImageNamed:@"RewindButton.tif"];
        SKSpriteNode* jButton = [[SKSpriteNode alloc] initWithImageNamed:@"JumpButton.tif"];
        
        lButton.name = @"lButton";
        rButton.name = @"rButton";
        rewButton.name = @"rewButton";
        jButton.name = @"jButton";
        
        [self addChild:lButton];
        [self addChild:rButton];
        [self addChild:rewButton];
        [self addChild:jButton];
        
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
                    _startPos = pos;
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
        
        _rewinding = NO;
        _currentFrame = 0;
        
        _ghosts = [[NSMutableArray alloc]init];
        _ghostPaths = [[NSMutableArray alloc]init];
        NSMutableArray* path0 = [[NSMutableArray alloc]init];
        [path0 addObject:[NSNumber numberWithInt:_currentFrame]];
        [_ghostPaths addObject:path0];
        
        _pPath = [[NSMutableArray alloc]init];
        
    }
    
    return self;
}

-(BOOL)isPlayeronGhost:(Ghost*)ghost {
    if (_player.position.x <= ghost.position.x+ghost.size.width &&
        _player.position.x >= ghost.position.x-ghost.size.width &&
        _player.position.y <= ghost.position.y+ghost.size.height+0.1 &&
        _player.position.y >= ghost.position.y+ghost.size.height-0.1) {
        return YES;
    }
    return NO;
}

-(void)updateGhosts {
    for (Ghost* ghost in _ghosts) {
        if (![self isPlayeronGhost:ghost]) {
            [ghost updateGhostToFrame:_currentFrame];
        }
        if ([self isPlayeronGhost:ghost]) {
            CGPoint oldPos = ghost.position;
            int gFrame = _currentFrame;
            
            if (_currentFrame >= ghost.path.count) {
                gFrame = ghost.path.count-1;
            }
            
            CGPoint newPos = [[ghost.path objectAtIndex:gFrame]CGPointValue];
            CGPoint dif = CGPointMake(newPos.x-oldPos.x, newPos.y-oldPos.y);
            
            _player.position = CGPointMake(_player.position.x+dif.x, _player.position.y+dif.y);
            [ghost updateGhostToFrame:_currentFrame];
            
            _player.temp.position = _player.position;
            
        }
    }
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
    
    for (Ghost* ghost in _ghosts) {
        [_player resolveCollisionWithGhost:ghost];
    }
    
    player.position = player.temp.position;
    
    [[_ghostPaths lastObject] addObject:[NSValue valueWithCGPoint:player.position]];
}

-(void)updateWorld {
    
//    NSLog(@"%i",_currentFrame);
    if (!_rewinding) {
        if (_resuming) {
            NSLog(@"RESUME");
            int startFrame = [[[_ghostPaths lastObject] firstObject] integerValue];
            
            [[_ghostPaths lastObject]removeObjectAtIndex:0];
            
            Ghost* newGhost = [[Ghost alloc]initWithPath:[_ghostPaths lastObject] startFrame:startFrame];
            NSMutableArray* newPath = [[NSMutableArray alloc]init];
            [newPath addObject:[NSNumber numberWithInt:_currentFrame]];
            
            [self addChild:newGhost];
            [_ghosts addObject:newGhost];
            [_ghostPaths addObject:newPath];

            NSMutableArray* newpPath = [[NSMutableArray alloc]init];
            for (int i = 0; i < _currentFrame; i++) {
                [newpPath addObject:[_pPath objectAtIndex:i]];
            }
            _pPath = newpPath;
            _resuming = NO;
        }
        else {
            [self updateGhosts];
            [self updatePlayerPosition:_player];
            [_pPath addObject:[NSValue valueWithCGPoint:_player.position]];
            _currentFrame += 1;
            _rwFrame = 2*_currentFrame;
        }
    }
    
    else if (_rewinding) {
        if (_currentFrame > 0) {
            _rwFrame -= 1;
            int newFrame = (int)ceilf((float)_rwFrame/2);
//            NSLog(@"%i", newFrame);
            _currentFrame = newFrame;
            
            for (Ghost* ghost in _ghosts) {
                [ghost updateGhostToFrame:_currentFrame];
            }
            
            int playerFrame;
            if (_currentFrame >= [_pPath count]) {
                playerFrame = [_pPath count]-1;
            }
            else {
                playerFrame = _currentFrame;
            }
            
            _player.position = [[_pPath objectAtIndex:playerFrame]CGPointValue];
            _player.xVel = 0.0f;
            _player.yVel = 0.0f;
        }
    }
    
//    NSLog(@"%i, %i", _currentFrame, _pPath.count);
    
}

-(void)startRewind {
    
    _rewinding = YES;
    NSLog(@"REWIND");
    
}

-(void)endRewind {
    
    _rewinding = NO;
    _resuming = YES;
}

-(void)simpleRewind {
    
    _player.position = _startPos;
    _player.xVel = 0.0f;
    _player.yVel = 0.0f;
    
    for (Ghost* ghost in _ghosts) {
        [ghost updateGhostToFrame:0];
    }
    
    int startFrame = [[[_ghostPaths lastObject] firstObject] integerValue];
    
    [[_ghostPaths lastObject]removeObjectAtIndex:0];
    
    _currentFrame = 0;
    
    Ghost* newGhost = [[Ghost alloc]initWithPath:[_ghostPaths lastObject] startFrame:startFrame];
    NSMutableArray* newPath = [[NSMutableArray alloc]init];
    [newPath addObject:[NSNumber numberWithInt:_currentFrame]];
    
    [self addChild:newGhost];
    [_ghosts addObject:newGhost];
    [_ghostPaths addObject:newPath];
    
    
    
    NSLog(@"REWIND!");
    
}

@end
