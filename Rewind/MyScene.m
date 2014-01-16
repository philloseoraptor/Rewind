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
        
        self.onGround = NO;
        
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
//        self.movingLeft = YES;
//        self.movingRight = NO;
//        self.player.position = CGPointMake(self.player.position.x - hThrust, self.player.position.y);
        [_player moveLeft];

    }
    
    if (location.x > 128 && location.x <= 256) {
//        self.movingLeft = NO;
//        self.movingRight = YES;
//        self.player.position = CGPointMake(self.player.position.x + hThrust, self.player.position.y);
        [_player moveRight];
    }
    
    if (location.x >= 284) {
//        if (self.onGround) {
//            self.player.position = CGPointMake(self.player.position.x, self.player.position.y + 1.0f);
//            self.playerVel = CGPointMake(self.playerVel.x, vThrust);
//        }
        [_player jump];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
//        if (!self.movingLeft) {
//            self.movingLeft = YES;
//            self.movingRight = NO;
//        }
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

-(CGPoint)locationToTilemap:(CGPoint)location {
    
    return CGPointMake(floor((float)location.x/32.0), floor((float)location.y/32.0));
}

-(CGPoint)tileMapToLocation:(CGPoint)mapcoord {
    
//    NSLog(@"mc: (%i,%i) | tp: (%i,%i)",(int)mapcoord.x,(int)mapcoord.y,(int)((mapcoord.x*32.0)+16.0),(int)((mapcoord.y*32.0)/16.0));
    return CGPointMake(((float)(mapcoord.x)*32.0)+16.0, ((float)(mapcoord.y)*32.0)+16.0);
}

-(NSArray*)getTilesAroundTile:(CGPoint)mapcoord {
    
    NSMutableArray *surroundingTiles = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j<=1; j++) {
            if (i != 0 && j != 0) {
                [surroundingTiles addObject:[NSValue valueWithCGPoint:CGPointMake(mapcoord.x+i, mapcoord.y+j)]];
            }
        }
    }
    
    return surroundingTiles;
}

-(NSArray*)getTilesAroundPosition:(CGPoint)position {
    
    CGPoint mapcoord = [self locationToTilemap:position];
//    NSLog(@"tilePos = (%i,%i)",(int)mapcoord.x,(int)mapcoord.y);
    
    NSMutableArray *surroundingTiles = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j<=1; j++) {
            if (i != 0 || j != 0) {
                [surroundingTiles addObject:[NSValue valueWithCGPoint:CGPointMake(mapcoord.x+i, mapcoord.y+j)]];
            }
        }
    }
    
    [surroundingTiles exchangeObjectAtIndex:0 withObjectAtIndex:3];
    [surroundingTiles exchangeObjectAtIndex:2 withObjectAtIndex:4];
    [surroundingTiles exchangeObjectAtIndex:3 withObjectAtIndex:6];
    
    return surroundingTiles;
}

-(CGPoint) addCGPoint:(CGPoint) p1 toCGPoint:(CGPoint) p2
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

//-(void)updatePlayerPosition:(SKSpriteNode*)player {
//    self.onGround = NO;
//    
//    SKSpriteNode* tempPlayer = player;
//    
//    //update x
//    float newXvel;
//    if (self.movingLeft) newXvel = -hThrust;
//    if (self.movingRight) newXvel = hThrust;
//    if (!self.movingLeft && !self.movingRight) newXvel = f*self.playerVel.x;
//    
//    //update y
//    float newYvel = g*termVel + (1-g)*self.playerVel.y;
//    
//    tempPlayer.position = [self addCGPoint:tempPlayer.position toCGPoint:CGPointMake(newXvel, newYvel)];
//    self.playerVel = CGPointMake(newXvel, newYvel);
////    NSLog(@"pos = (%i,%i)",(int)tempPlayer.position.x,(int)tempPlayer.position.y);
//    
//    NSArray *sTiles = [self getTilesAroundPosition:tempPlayer.position];
//    
//    
//    for (int i = 0; i<sTiles.count; i++) {
//        NSValue *val = [sTiles objectAtIndex:i];
//        CGPoint tile = [val CGPointValue];
//        CGPoint tilePos = [self tileMapToLocation:tile];
//        
//        for (int j = 0; j<self.walls.count; j++) {
//            SKSpriteNode* wall = [self.walls objectAtIndex:j];
//            
////            NSLog(@"tile = (%i,%i), wall = (%i,%i)",(int)tilePos.x,(int)tilePos.y,(int)wall.position.x,(int)wall.position.y);
//            if (wall.position.x == tilePos.x && wall.position.y  == tilePos.y) {
////                NSLog(@"tile = (%i,%i), wall = (%i,%i)",(int)tilePos.x,(int)tilePos.y,(int)wall.position.x,(int)wall.position.y);
////                NSLog(@"checking");
//                [self checkAndResolveCollisionofPlayer:tempPlayer with:wall];
//            }
//        }
//    }
//    
//    player.position = tempPlayer.position;
//    
//}

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

-(void)checkAndResolveCollisionofPlayer:(SKSpriteNode*)P with:(SKSpriteNode*)B {
    if (CGRectIntersectsRect(P.frame, B.frame)) {
        //check order of resolution (x or y first)
        
        //y first
        if (CGRectIntersection(P.frame, B.frame).size.height <= CGRectIntersection(P.frame, B.frame).size.width) {
            if (P.position.y >= B.position.y) {
                P.position = CGPointMake(P.position.x, B.position.y+(B.size.height + P.size.height)/2);
                self.onGround = YES;
                self.playerVel = CGPointMake(self.playerVel.x, 0.0f);
            }
            else {
                P.position = CGPointMake(P.position.x, B.position.y-(B.size.height + P.size.height)/2);
                self.playerVel = CGPointMake(self.playerVel.x, 0.0f);
            }
        }
        
        //x first
        else {
            if (P.position.x >= B.position.x) {
                P.position = CGPointMake(B.position.x+(B.size.width+P.size.width)/2, P.position.y);
                self.playerVel = CGPointMake(0.0f, self.playerVel.y);
            }
            else {
                P.position = CGPointMake(B.position.x-(B.size.width+P.size.width)/2, P.position.y);
                self.playerVel = CGPointMake(0.0f, self.playerVel.y);
            }
            
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [self updatePlayerPosition:self.player];
}

@end
