//
//  Player.h
//  Rewind
//
//  Created by PHILLIP SEO on 1/3/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode
@property (nonatomic) BOOL movingL;
@property (nonatomic) BOOL movingR;
@property (nonatomic) BOOL onGround;
@property (nonatomic) float xVel;
@property (nonatomic) float yVel;
@property (nonatomic) CGPoint desiredPosition;

-(void)jump;
-(void)moveLeft;
-(void)moveRight;
-(CGPoint)desirePositionWithGravity:(float) g;
@end
