//
//  Player.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/16/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "Player.h"

@implementation Player

static const float termVel = -5.0f;
static const float xTermVel = 3.0f;
static const float hThrust = 1.0f;
static const float vThrust = 17.0f;
static const float f = 0.0f;
float newXvel;
float newYvel;
BOOL onGround;
BOOL movingL;
BOOL movingR;
CGPoint desiredPosition;


-(id)initWithPosition:(CGPoint)position {
    
    if (self = [super initWithImageNamed:@"player.jpg"]) {
        _xVel = 0.0;
        _yVel = 0.0;
        onGround = NO;
        movingL = NO;
        movingR = NO;
        _temp = self;
        self.position = position;
    }
    
    return self;
}

-(void)jump {
    if (onGround) {
        _yVel = vThrust;
    }
}

-(void)moveLeft {
    movingL = YES;
    movingR = NO;
    self.position = CGPointMake(self.position.x - hThrust, self.position.y);
}

-(void)moveRight {
    movingR = YES;
    movingL = NO;
    self.position = CGPointMake(self.position.x + hThrust, self.position.y);
}

-(void)stop {
    movingL = NO;
    movingR = NO;
}

-(CGPoint)desirePositionWithGravity:(float)gravity {
    onGround = NO;
    
    if (movingL) newXvel -= hThrust;
    if (movingR) newXvel += hThrust;
    if (!movingL && !movingR) newXvel = f*_xVel;
    
    if (newXvel > xTermVel) newXvel = xTermVel;
    if (newXvel < -xTermVel) newXvel = -xTermVel;
    
    newYvel = gravity*termVel + (1-gravity)*_yVel;
    
//    NSLog(@"oldYVel:%f, newYVel:%f",_yVel,newYvel);
    
    desiredPosition = CGPointMake(self.position.x + newXvel, self.position.y + newYvel);
    _yVel = newYvel;
    _xVel = newXvel;
    
    return desiredPosition;
    
}

-(void)resolveCollisionWithWall:(SKSpriteNode *)wall {
    
//    _temp.position = desiredPosition;
    
    if (CGRectIntersectsRect(_temp.frame, wall.frame)) {
      
        CGRect intersection = CGRectIntersection(_temp.frame, wall.frame);
        
        if (intersection.size.height < intersection.size.width) {
            if (_temp.position.y >= wall.position.y) {
                _temp.position = CGPointMake(_temp.position.x, wall.position.y+(wall.size.height + _temp.size.height)/2);
                onGround = YES;
                _yVel = 0.0f;
            }
            else {
                _temp.position = CGPointMake(_temp.position.x, wall.position.y-(wall.size.height + _temp.size.height)/2);
                _yVel = 0.0f;
            }
        }
        
        else {
            if (_temp.position.x > wall.position.x) {
                _temp.position = CGPointMake(wall.position.x+(wall.size.width+_temp.size.width)/2, _temp.position.y);
                _xVel = 0.0f;
            }
            else {
                _temp.position = CGPointMake(wall.position.x-(wall.size.width+_temp.size.width)/2, _temp.position.y);
                _xVel = 0.0f;
            }
        }
    }
    
}

@end
