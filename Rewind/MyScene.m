//
//  MyScene.m
//  Rewind
//
//  Created by PHILLIP SEO on 12/27/13.
//  Copyright (c) 2013 Phillip Seo. All rights reserved.
//

#import "MyScene.h"
#import "TileMap.h"
#import "Player.h"
#import "World.h"

static const float g = 0.1f;

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) Player * player;
@property (nonatomic) NSMutableArray * walls;
@property (nonatomic) TileMap* tm;
@property (nonatomic) World* world;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
//        self.anchorPoint = CGPointMake (0.5,0.5);
        
        NSString* L1path = [[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"];
        
        _world = [[World alloc]initFromLevel:L1path];
        
        [self addChild:_world];
        
        SKNode* camera = [SKNode node];
        
        camera.name = @"camera";
        
        [_world addChild:camera];
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        
//        NSLog(@"walls: %i",self.walls.count);
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 1 - Choose one of the touches to work with
//    UITouch * touch = [touches anyObject];
    
//    CGPoint location = [touch locationInNode:self];
//    
//    if (location.x <= 128) {
//        [_world.player moveLeft];
//
//    }
//    
//    if (location.x > 128 && location.x <= 256) {
//        [_world.player moveRight];
//    }
//    
//    if (location.x >= 284) {
//        [_world.player jump];
//    }
    
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x <= 128) {
            [_world.player moveLeft];
            
        }
        
        if (location.x > 128 && location.x <= 256) {
            [_world.player moveRight];
        }
        
        if (location.x >= 284) {
            [_world.player jump];
        }
        
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch * touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    
//    if (location.x <= 128) {
//        [_world.player moveLeft];
//    }
//    
//    if (location.x > 128 && location.x <= 256) {
//        [_world.player moveRight];
//    }
    
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x <= 128) {
            [_world.player moveLeft];
        }
        
        if (location.x > 128 && location.x <= 256) {
            [_world.player moveRight];
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch * touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    
//    if (location.x <= 128) {
//        [_world.player stop];
//    }
//    
//    if (location.x > 128 && location.x <= 256) {
//        [_world.player stop];
//    }
    
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x <= 128) {
            [_world.player stop];
        }
        
        if (location.x > 128 && location.x <= 256) {
            [_world.player stop];
        }
    }

}

-(void)updatePlayerPosition:(Player*)player {
//    NSLog(@"player: (%f,%f)",player.position.x,player.position.y);
    CGPoint desPos = [player desirePositionWithGravity:g];
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

- (void)didSimulatePhysics
{
    [_world updatePlayerPosition:_world.player];
//    NSLog(@"centering camera");
//    [self centerOnNode: [self childNodeWithName: @"//camera"]];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,                                       node.parent.position.y - cameraPositionInScene.y);
}

-(void)update:(CFTimeInterval)currentTime {
//    [_world updatePlayerPosition:_world.player];
}

@end
