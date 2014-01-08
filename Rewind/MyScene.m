//
//  MyScene.m
//  Rewind
//
//  Created by PHILLIP SEO on 12/27/13.
//  Copyright (c) 2013 Phillip Seo. All rights reserved.
//

#import "MyScene.h"

static const float g = 0.1f;
static const float f = 0.0f;
static const float termVel = -5.0f;
static const float hThrust = 4.0f;
static const float vThrust = 20.0f;

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) CGPoint playerVel;
@property (nonatomic) BOOL onGround;
@property (nonatomic) BOOL movingLeft;
@property (nonatomic) BOOL movingRight;
@property (nonatomic) NSMutableArray * walls;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.walls = [[NSMutableArray alloc]init];
        
        self.onGround = NO;
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //Initialize walls
        for (int i = 0; i<18; i++) {
            SKSpriteNode * wall = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            wall.position = CGPointMake((wall.size.width*i)+wall.size.width/2, (wall.size.height * 2.5f));
            [self addChild:wall];
            [self.walls addObject:wall];
        }
        
        for (int i = 0; i<7; i++) {
            SKSpriteNode * wall2 = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            SKSpriteNode * wall3 = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            wall2.position = CGPointMake(wall2.size.width/2, (wall2.size.height * 3.5f)+wall2.size.height*i);
            wall3.position = CGPointMake(560.0, (wall3.size.height * 3.5f)+wall3.size.height*i);
//            NSLog(@"(%i,%i)",(int)wall3.position.x,(int)wall3.position.y);
            [self addChild:wall2];
            [self addChild:wall3];
            [self.walls addObject:wall2];
            [self.walls addObject:wall3];
        }
        
        for (int i = 0; i<1; i++) {
            SKSpriteNode * wall = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            wall.position = CGPointMake(wall.size.width*6.5, wall.size.height*3.5+wall.size.height*i);
            [self addChild:wall];
            [self.walls addObject:wall];
        }
        
        for (int i = 0; i<3; i++) {
            SKSpriteNode * wall = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            wall.position = CGPointMake(wall.size.width*9.5+wall.size.width*i, wall.size.height*6.5);
            [self addChild:wall];
            [self.walls addObject:wall];
        }
        
        //Initialize a player
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player.jpg"];
        self.player.position = CGPointMake(self.player.size.width*1.5, self.frame.size.height*0.75f);
        self.playerVel = CGPointMake(0.0f, 0.0f);
        [self addChild:self.player];
        
//        NSLog(@"walls: %i",self.walls.count);
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (location.x <= 128) {
        self.movingLeft = YES;
        self.movingRight = NO;
        self.player.position = CGPointMake(self.player.position.x - hThrust, self.player.position.y);

    }
    
    if (location.x > 128 && location.x <= 256) {
        self.movingLeft = NO;
        self.movingRight = YES;
        self.player.position = CGPointMake(self.player.position.x + hThrust, self.player.position.y);
    }
    
    if (location.x >= 284) {
        if (self.onGround) {
            self.player.position = CGPointMake(self.player.position.x, self.player.position.y + 1.0f);
            self.playerVel = CGPointMake(self.playerVel.x, vThrust);
        }
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

-(void)updatePlayerPosition:(SKSpriteNode*)player {
    self.onGround = NO;
    
    SKSpriteNode* tempPlayer = player;
    
    //update x
    float newXvel;
    if (self.movingLeft) newXvel = -hThrust;
    if (self.movingRight) newXvel = hThrust;
    if (!self.movingLeft && !self.movingRight) newXvel = f*self.playerVel.x;
    
    //update y
    float newYvel = g*termVel + (1-g)*self.playerVel.y;
    
    tempPlayer.position = [self addCGPoint:tempPlayer.position toCGPoint:CGPointMake(newXvel, newYvel)];
    self.playerVel = CGPointMake(newXvel, newYvel);
//    NSLog(@"pos = (%i,%i)",(int)tempPlayer.position.x,(int)tempPlayer.position.y);
    
    NSArray *sTiles = [self getTilesAroundPosition:tempPlayer.position];
    
    
    for (int i = 0; i<sTiles.count; i++) {
        NSValue *val = [sTiles objectAtIndex:i];
        CGPoint tile = [val CGPointValue];
        CGPoint tilePos = [self tileMapToLocation:tile];
        
        for (int j = 0; j<self.walls.count; j++) {
            SKSpriteNode* wall = [self.walls objectAtIndex:j];
            
//            NSLog(@"tile = (%i,%i), wall = (%i,%i)",(int)tilePos.x,(int)tilePos.y,(int)wall.position.x,(int)wall.position.y);
            if (wall.position.x == tilePos.x && wall.position.y  == tilePos.y) {
//                NSLog(@"tile = (%i,%i), wall = (%i,%i)",(int)tilePos.x,(int)tilePos.y,(int)wall.position.x,(int)wall.position.y);
//                NSLog(@"checking");
                [self checkAndResolveCollisionofPlayer:tempPlayer with:wall];
            }
        }
    }
    
    player.position = tempPlayer.position;
    
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
