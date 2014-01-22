//
//  World.h
//  Rewind
//
//  Created by PHILLIP SEO on 1/17/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TileMap.h"
#import "Player.h"
#import "Goal.h"

@interface World : SKNode

@property (nonatomic) TileMap* tm;
@property (nonatomic) Player* player;
@property (nonatomic) NSMutableArray* walls;
@property (nonatomic) Goal* goal;
@property (nonatomic) BOOL atGoal;

-(id)initFromLevel:(NSString*)levelPath;

-(void)updatePlayerPosition:(Player*)player;

@end
