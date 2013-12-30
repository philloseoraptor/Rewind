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
        for (int i = 0; i<36; i++) {
            SKSpriteNode * wall = [SKSpriteNode spriteNodeWithImageNamed:@"wall.jpg"];
            wall.position = CGPointMake((wall.size.width*i)+wall.size.width/2, (wall.size.height * 2.5f));
            [self addChild:wall];
            [self.walls addObject:wall];
            wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wall.frame.size];
            wall.physicsBody.dynamic = NO;
            wall.physicsBody.affectedByGravity = NO;
            wall.physicsBody.restitution = 0.0;
//            wall.physicsBody.mass = 1000.0;
            wall.physicsBody.categoryBitMask = wallCategory;
//            wall.physicsBody.contactTestBitMask = playerCategory;
//            wall.physicsBody.collisionBitMask = playerCategory;
        }
        
        //Initialize a player
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player.jpg"];
        self.player.position = CGPointMake(self.player.size.width, self.frame.size.height*0.75f);
        self.playerVel = CGPointMake(0.0f, 0.0f);
        [self addChild:self.player];
        
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.frame.size];
        self.player.physicsBody.dynamic = YES;
        self.player.physicsBody.affectedByGravity = YES;
        self.player.physicsBody.allowsRotation = NO;
        self.player.physicsBody.restitution = 0.0;
        self.player.physicsBody.mass = 1.0  ;
        self.player.physicsBody.categoryBitMask = playerCategory;
        self.player.physicsBody.contactTestBitMask = wallCategory;
        self.player.physicsBody.collisionBitMask = wallCategory;
        self.player.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        self.physicsWorld.gravity = CGVectorMake(0,-10.0);
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}


-(void)update:(CFTimeInterval)currentTime {

    
}

@end
