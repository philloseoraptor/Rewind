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
        
        NSString* L1path = [[NSBundle mainBundle] pathForResource:@"L1" ofType:@"txt"];
        
        _world = [[World alloc]initFromLevel:L1path];
        
        [self addChild:_world];
        
        SKNode* camera = [SKNode node];
        
        camera.name = @"camera";
        
        [_world addChild:camera];
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
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
        
        if (location.x >= 284) {
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
    }

}

- (void)didSimulatePhysics
{
    [_world updatePlayerPosition:_world.player];
    [_world childNodeWithName:@"//camera"].position = CGPointMake(_world.player.position.x-self.size.width/2, _world.player.position.y-self.size.height/2);
    [self centerOnNode: [self childNodeWithName: @"//camera"]];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,
                                       node.parent.position.y - cameraPositionInScene.y);
}

-(void)update:(CFTimeInterval)currentTime {

}

@end
