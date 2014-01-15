//
//  Player.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/3/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "Player.h"

static const float f = 1.0f;
static const float termVel = -5.0f;
static const float hThrust = 4.0f;
static const float vThrust = 20.0f;

@implementation Player

-(id)init {
    if (self = [super initWithImageNamed:@"player.jpg"]) {
        self.movingR = NO;
        self.movingL = NO;
        self.onGround = NO;
        self.xVel = 0.0;
        self.yVel = 0.0;
    }
    return self;
}

-(void)jump {
    if (self.onGround) {
        self.yVel = vThrust;
    }
}

-(void)moveLeft {
    self.movingL = YES;
    self.movingR = NO;
}

-(void)moveRight {
    self.movingR = YES;
    self.movingL = NO;
}

-(CGPoint)desirePositionWithGravity:(float) g {
    self.onGround = NO;
    
    float newXvel;
    if (self.movingL) newXvel = -hThrust;
    if (self.movingR) newXvel = hThrust;
    if (!self.movingR && !self.movingL) newXvel = (1-f)*self.xVel;
    
    float newYvel = g*termVel + (1-g)*self.yVel;
    
    self.desiredPosition = CGPointMake(self.position.x + newXvel, self.position.y+newYvel);
    self.xVel = newXvel;
    self.yVel = newYvel;
    
    return self.desiredPosition;
}

-(void)checkAndResolveCollisionWith:(SKSpriteNode*)object {
    
    SKSpriteNode* tempPlayer = self;
    tempPlayer.position = self.desiredPosition;
    
    if (CGRectIntersectsRect(tempPlayer.frame, object.frame)) {
        if (CGRectIntersection(tempPlayer.frame, object.frame).size.height <= CGRectIntersection(tempPlayer.frame, object.frame).size.width) {
            if (tempPlayer.position.y >= object.position.y) {
                tempPlayer.position = CGPointMake(tempPlayer.position.x, object.position.y + (object.size.height + self.size.height)/2);
                self.onGround = YES;
                self.yVel = 0.0f;
            }
            else {
                tempPlayer.position = CGPointMake(tempPlayer.position.x, object.position.y - (object.size.height + self.size.height)/2);
                self.yVel = 0.0f;
            }
        }
        else {
            if (tempPlayer.position.x >= object.position.x) {
                tempPlayer.position = CGPointMake(object.position.x+(object.size.width+self.size.width)/2, tempPlayer.position.y);
                self.xVel = 0.0f;
            }
            else {
                tempPlayer.position = CGPointMake(object.position.x-(object.size.width+self.size.width)/2, tempPlayer.position.y);
                self.xVel = 0.0f;
            }
        }
    }
    
    self.position = tempPlayer.position;
    
}

@end

