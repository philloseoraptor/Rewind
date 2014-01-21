//
//  World.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/17/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "World.h"

static const float g = 0.1f;

@implementation World

-(id)initFromLevel:(NSString*)levelPath {
    if (self = [super init]) {
//        NSLog(@"world loaded");
        
        _tm = [[TileMap alloc] initWithFile:levelPath withTileSize:32 atOrigin:CGPointMake(0.0, 0.0)];
        
        _walls = [[NSMutableArray alloc]init];
        
        for (int i = [_tm levelByLines].count-1; i>=0; i-=1) {
            NSString* line = [_tm.levelByLines objectAtIndex:i];
            for (int j = 0; j < line.length; j++) {
                unichar character = [line characterAtIndex:j];
                //                NSLog(@"%c",character);
                if (character == 'w') {
                    SKSpriteNode* wall = [[SKSpriteNode alloc]initWithImageNamed:@"wall.jpg"];
                    wall.position = [_tm positionFromTile:CGPointMake(j, [_tm levelByLines].count-1-i)];
                    [self addChild:wall];
                    [self.walls addObject:wall];
                }
                else if (character == 's') {
                    CGPoint pos = [_tm positionFromTile:CGPointMake(j, [_tm levelByLines].count-1-i)];
//                    NSLog(@"player (%f,%f)",pos.x,pos.y);
                    self.player = [[Player alloc]initWithPosition:pos];
                    _player.position = pos;
                    [self addChild:_player];
                }
            }
        }
        
    }
    
    return self;
}

-(void)updatePlayerPosition:(Player*)player {
    //    NSLog(@"player: (%f,%f)",player.position.x,player.position.y);
    CGPoint desPos = [self.player desirePositionWithGravity:g];
    //    NSLog(@"desPos:(%f,%f)",desPos.x,desPos.y);
    player.temp.position = desPos;
    NSArray *sTiles = [_tm getTilesAroundTile:[_tm tileFromPosition:player.temp.position]];
    
    
    for (NSValue* val in sTiles){
        CGPoint tile = [val CGPointValue];
        CGPoint tilePos = [_tm positionFromTile:tile];
        
        for (SKSpriteNode* wall in _walls) {
            if (wall.position.x == tilePos.x && wall.position.y == tilePos.y) {
                //                NSLog(@"collision!");
                [player resolveCollisionWithWall:wall];
            }
        }
    }
    
    player.position = player.temp.position;
}

@end
