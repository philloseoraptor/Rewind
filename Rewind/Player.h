//
//  Player.h
//  Rewind
//
//  Created by PHILLIP SEO on 1/16/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ghost.h"

@interface Player : SKSpriteNode

@property (nonatomic) float xVel;
@property (nonatomic) float yVel;
@property (nonatomic) SKSpriteNode* temp;

-(id)initWithPosition:(CGPoint)position;
-(void)jump;
-(void)moveLeft;
-(void)moveRight;
-(void)stop;
-(CGPoint)desirePositionWithGravity:(float) gravity;
-(void)resolveCollisionWithWall:(SKSpriteNode*)object;
-(BOOL)didPlayerReachGoal:(SKSpriteNode*)goal;
-(void)resolveCollisionWithGhost:(Ghost*)ghost;

@end
