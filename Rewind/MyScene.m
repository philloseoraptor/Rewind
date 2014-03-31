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
#import "World.h"

@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) World* world;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        NSString* Lpath = [[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"];
        
        _world = [[World alloc]initFromLevel:Lpath];
        
        [self addChild:_world];
        
        SKNode* camera = [SKNode node];
        
        camera.name = @"camera";
        
        [_world addChild:camera];
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x <= 128) {
            [_world.player moveLeft];
        }
        
        if (location.x > 128 && location.x <= 256) {
            [_world.player moveRight];
        }
        
        if (location.x > 256 && location.x <= 384) {
            [_world startRewind];
        }
        
        if (location.x > 384) {
            [_world.player jump];
        }
        
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x <= 128) {
            [_world.player moveLeft];
        }
        
        if (location.x > 128 && location.x <= 256) {
            [_world.player moveRight];
        }
        
//        if (location.x > 256) {
//            [_world.player stop];
//        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x <= 128) {
            [_world.player stop];
        }
        
        if (location.x > 128 && location.x <= 256) {
            [_world.player stop];
        }
        
        if (location.x > 256 && location.x <= 384) {
            [_world endRewind];
        }
    }

}

- (void)didSimulatePhysics
{
//    if (_world.currentFrame == 300) {
//        [_world simpleRewind];
//    }
    [_world updateWorld];
    
    [self updateCameraPosition:[_world childNodeWithName:@"//camera"]];
    [self centerOnNode: [self childNodeWithName: @"//camera"]];
    
    if (_world.atGoal) {
        NSString* newLPath = _world.goal.toPath;
        [_world removeFromParent];
        _world = [[World alloc]initFromLevel:newLPath];
        [self addChild:_world];
        SKNode* camera = [SKNode node];
        camera.name = @"camera";
        [_world addChild:camera];
    }
}





- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,
                                       node.parent.position.y - cameraPositionInScene.y);
}

-(void) updateCameraPosition:(SKNode*)camera {
    
    
    float Rbound = _world.player.position.x - 1.5*_world.tm.TS-self.size.width/2;
    float Lbound = _world.player.position.x + 1.5*_world.tm.TS-self.size.width/2;
    float Ubound = _world.player.position.y - 0.5*_world.tm.TS-self.size.height/2;
    float Dbound = _world.player.position.y + 0.5*_world.tm.TS-self.size.height/2;
    
    if (_world.player.yVel == 0) {
        if (camera.position.y < Dbound) {
            camera.position = CGPointMake(camera.position.x, camera.position.y + 0.02*(Dbound-camera.position.y));
        }
    }
    
    if (_world.player.xVel == 0) {
        float midscreenX = _world.player.position.x - self.size.width/2;
        if (camera.position.x < midscreenX) {
            camera.position = CGPointMake(camera.position.x + 0.01*(midscreenX-camera.position.x), camera.position.y);
        }
        else if (camera.position.x > midscreenX) {
            camera.position = CGPointMake(camera.position.x - 0.01*(camera.position.x-midscreenX), camera.position.y);
        }
    }
    
    if (camera.position.x < Rbound) {
        camera.position = CGPointMake(camera.position.x + 0.05*(Rbound-camera.position.x), camera.position.y);
    }
    if (camera.position.x > Lbound) {
        camera.position = CGPointMake(camera.position.x - 0.05*(camera.position.x-Lbound), camera.position.y);
    }
    
    if (camera.position.y < Ubound || _world.player.yVel < 0) {
        camera.position = CGPointMake(camera.position.x, camera.position.y + 0.01*(Ubound-camera.position.y));
    }
    if (camera.position.y > Dbound) {
        camera.position = CGPointMake(camera.position.x, camera.position.y - 0.01*(camera.position.y-Dbound));
    }
    
    
    
    
}





-(void)update:(CFTimeInterval)currentTime {

}

@end
