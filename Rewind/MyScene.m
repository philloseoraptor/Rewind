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

static const float g = 0.1f;
static const float f = 0.0f;
static const float termVel = -5.0f;
static const float hThrust = 4.0f;
static const float vThrust = 15.0f;

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) Player * player;
@property (nonatomic) CGPoint playerVel;
@property (nonatomic) BOOL onGround;
@property (nonatomic) BOOL movingLeft;
@property (nonatomic) BOOL movingRight;
@property (nonatomic) NSMutableArray * walls;
@property (nonatomic) TileMap* tm;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSString* L1path = [[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"];
        
        self.tm = [[TileMap alloc] initWithFile:L1path withTileSize:32 atOrigin:CGPointMake(0.0, 0.0)];
        
        
        self.walls = [[NSMutableArray alloc]init];
        
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
                else if (character == 'p') {
                    CGPoint pos = [_tm positionFromTile:CGPointMake(j, [_tm levelByLines].count-1-i)];
                    NSLog(@"player (%f,%f)",pos.x,pos.y);
                    self.player = [[Player alloc]initWithPosition:pos];
                    _player.position = pos;
                    [self addChild:_player];
                }
            }
        }
        
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        
//        NSLog(@"walls: %i",self.walls.count);
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        [_player moveLeft];

    }
    
    if (location.x > 128 && location.x <= 256) {
        [_player moveRight];
    }
    
    if (location.x >= 284) {
        [_player jump];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        [_player moveLeft];
    }
    
    if (location.x > 128 && location.x <= 256) {
        [_player moveRight];    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        [_player stop];
    }
    
    if (location.x > 128 && location.x <= 256) {
        [_player stop];
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

-(void)update:(CFTimeInterval)currentTime {
    [self updatePlayerPosition:self.player];
}

@end
