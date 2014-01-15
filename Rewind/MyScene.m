//
//  MyScene.m
//  Rewind
//
//  Created by PHILLIP SEO on 12/27/13.
//  Copyright (c) 2013 Phillip Seo. All rights reserved.
//

#import "MyScene.h"
#import "Player.h"
#import "TileMap.h"

static const float g = 0.1f;
static const float f = 0.0f;
static const float termVel = -5.0f;
static const float hThrust = 4.0f;
static const float vThrust = 20.0f;

@interface MyScene () <SKPhysicsContactDelegate>
//@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) CGPoint playerVel;
@property (nonatomic) BOOL onGround;
@property (nonatomic) BOOL movingLeft;
@property (nonatomic) BOOL movingRight;
@property (nonatomic) NSMutableArray * walls;
@property (nonatomic) TileMap* tm;
@property (nonatomic) Player * player;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        NSString* tmPath = [[NSBundle mainBundle] pathForResource:@"lvl_1" ofType:@"txt"];
        self.tm = [[TileMap alloc]initMapFromFilePath:tmPath withPosition:CGPointMake(0.0, 0.0) tileSize:32];
        self.player = [[Player alloc]init];
        
        self.walls = [[NSMutableArray alloc]init];
        
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        for (int i = 0; i<self.tm.dimensions.x; i++) {
            for (int j = 0; j<self.tm.dimensions.y; j++) {
                if ([[self.tm objectAtIndex:CGPointMake(i, j)] isEqualToString:@"wall"]) {
                    SKSpriteNode* wall = [[SKSpriteNode alloc]initWithImageNamed:@"wall.jpg"];
                    wall.position = [self.tm locationFromTile:CGPointMake(i, j)];
                    [self addChild:wall];
                    [self.walls addObject:wall];
                }
                if ([[self.tm objectAtIndex:CGPointMake(i, j)] isEqualToString:@"start"]) {
                    self.player.position = [self.tm locationFromTile:CGPointMake(i, j)];
                    [self addChild:self.player];
                }
            }
        }
        
        
        }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        [self.player moveLeft];

    }
    
    if (location.x > 128 && location.x <= 256) {
        [self.player moveRight];
    }
    
    if (location.x >= 284) {
        [self.player jump];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        if (!self.movingLeft) {
            self.movingLeft = YES;
            self.movingRight = NO;
        }
    }
    
    if (location.x > 128 && location.x <= 256) {
        if (!self.movingRight) {
            self.movingLeft = NO;
            self.movingRight = YES;
        }
    }
    if (location.x >= 284) {
        self.movingRight = NO;
        self.movingLeft = NO;
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        self.movingLeft = NO;
        self.movingRight = NO;
    }
    
    if (location.x > 128 && location.x <= 256) {
        self.movingLeft = NO;
        self.movingRight = NO;
    }

}

-(BOOL)isBody:(SKSpriteNode *)a above:(SKSpriteNode *)b {
    if (ABS(a.position.x - b.position.x) < (a.size.width+b.size.width)/2 &&
        a.position.y >= b.position.y + (b.size.height+a.size.height)/2) {
        return YES;
    }
    return NO;
}

-(BOOL)isBody:(SKSpriteNode *)a levelWith:(SKSpriteNode *)b {
    if (ABS(a.position.y - b.position.y) < (a.size.height+b.size.height)/2) {
        return YES;
    }
    return NO;
}

//KEEP
-(void)checkWallCollisionsInTiles:(NSArray*)tiles{
    for (NSValue *tileObject in tiles) {
        CGPoint tile = [tileObject CGPointValue];
        CGPoint tilePos = [self.tm locationFromTile:tile];
        
        for (SKSpriteNode* wall in self.walls) {
            if (wall.position.x == tilePos.x && wall.position.y == tilePos.y) {
                [self.player checkAndResolveCollisionWith:wall];
            }
        }
    }
    
}

-(CGPoint) addCGPoint:(CGPoint) p1 toCGPoint:(CGPoint) p2
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}


-(void)update:(CFTimeInterval)currentTime {
    [self.player desirePositionWithGravity:g];
    [self checkWallCollisionsInTiles:[self.tm getTilesAroundTile:[self.tm tileFromLocation:self.player.desiredPosition]]];
}

@end
