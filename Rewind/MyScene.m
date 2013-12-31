//
//  MyScene.m
//  Rewind
//
//  Created by PHILLIP SEO on 12/27/13.
//  Copyright (c) 2013 Phillip Seo. All rights reserved.
//

#import "MyScene.h"

static const uint32_t playerCategory   = 0x1 <<0;
static const uint32_t wallCategory     = 0x1 <<1;
static const uint32_t goalCategory     = 0x1 <<2;

static const float g = 0.1f;
static const float f = 0.0f;
static const float termVel = -5.0f;
static const float hThrust = 5.0f;
static const float vThrust = 10.0f;

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
            wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
            wall.physicsBody.dynamic = NO;
            wall.physicsBody.categoryBitMask = wallCategory;
            wall.physicsBody.contactTestBitMask = playerCategory;
        }
        
        for (int i = 1; i<18; i++) {
            SKSpriteNode * wall = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            SKSpriteNode * wall2 = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            wall.position = CGPointMake(wall.size.width/2, (wall.size.height * 2.5f)+wall.size.height*i);
            wall2.position = CGPointMake(size.width-wall.size.width/2, (wall.size.height * 2.5f)+wall.size.height*i);
            [self addChild:wall];
            [self.walls addObject:wall];
            wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
            wall.physicsBody.dynamic = NO;
            wall.physicsBody.categoryBitMask = wallCategory;
            wall.physicsBody.contactTestBitMask = playerCategory;
            
            [self addChild:wall2];
            [self.walls addObject:wall2];
            wall2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
            wall2.physicsBody.dynamic = NO;
            wall2.physicsBody.categoryBitMask = wallCategory;
            wall2.physicsBody.contactTestBitMask = playerCategory;
        }
        
        SKSpriteNode * wall = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
        wall.position = CGPointMake(wall.size.width*9.5, wall.size.height*3.5);
        [self addChild:wall];
        [self.walls addObject:wall];
        wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.size];
        wall.physicsBody.dynamic = NO;
        wall.physicsBody.categoryBitMask = wallCategory;
        wall.physicsBody.contactTestBitMask = playerCategory;

        
        //Initialize a player
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player.jpg"];
        self.player.position = CGPointMake(self.player.size.width*1.5, self.frame.size.height*0.75f);
        self.playerVel = CGPointMake(0.0f, 0.0f);
        [self addChild:self.player];
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.dynamic = NO;
        self.player.physicsBody.allowsRotation = NO;
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.contactTestBitMask = wallCategory;
        
//        int count = self.walls.count;
//        NSLog(@"number of walls: %i", count);
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
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


-(void)update:(CFTimeInterval)currentTime {
    self.onGround = NO;
    //update x
    float newXvel;
    if (self.movingLeft) {
        newXvel = -hThrust;
    }
    if (self.movingRight) {
        newXvel = hThrust;
    }
    if (!self.movingLeft && !self.movingRight) {
        newXvel = f*self.playerVel.x;
    }
    
    self.playerVel = CGPointMake(newXvel, self.playerVel.y);
    
    for (int j = 0; j<self.walls.count; j++) {
        
        SKSpriteNode * wall = [self.walls objectAtIndex:j];
        
        if ([self isBody:self.player levelWith:wall]) {
            
            //check if player is to left of wall
            if (self.player.position.x < wall.position.x) {
                
                //check if overshoot
                if (self.player.position.x + newXvel > wall.position.x - (self.player.size.width + wall.size.width)/2) {
                    self.player.position = CGPointMake(wall.position.x - (self.player.size.width + wall.size.width)/2, self.player.position.y);
                    self.playerVel = CGPointMake(0.0f, self.playerVel.y);
                }
            }
            //check if player is to right of wall
            else if (self.player.position.x > wall.position.x) {
                
                //check if overshoot
                if (self.player.position.x + newXvel < wall.position.x + (self.player.size.width + wall.size.width)/2) {
                    self.player.position = CGPointMake(wall.position.x + (self.player.size.width + wall.size.width)/2, self.player.position.y);
                    self.playerVel = CGPointMake(0.0f, self.playerVel.y);
                }
            }
            
            else {
                self.player.position = CGPointMake(self.player.position.x + newXvel, self.player.position.y);
            }
        }
    }
    
    
    self.player.position = CGPointMake(self.player.position.x + newXvel, self.player.position.y);
    
    //update y
    float newYvel = g*termVel + (1-g)*self.playerVel.y;
    self.playerVel = CGPointMake(self.playerVel.x, newYvel);
    
    for (int j = 0; j<self.walls.count; j++) {
        
        SKSpriteNode * wall = [self.walls objectAtIndex:j];
        
        //check if player is above  wall section
        if ([self isBody:self.player above:wall]) {
            
            //check if player will overshoot a wall, then correct for overshoot.
            if (self.player.position.y + newYvel <= self.player.size.height/2 + wall.position.y + wall.size.height/2) {
                self.player.position = CGPointMake(self.player.position.x, wall.position.y + wall.size.height/2 +self.player.size.height/2);
                self.onGround = YES;
                self.playerVel = CGPointMake(self.playerVel.x, 0.0f);
            }
            
            //if player isn't going to land, just have the player fall
            else {
                self.player.position = CGPointMake(self.player.position.x, self.player.position.y+newYvel);
            }
        }
    }
    
}

@end
