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

@interface World : SKNode

@property (nonatomic) TileMap* tm;
@property (nonatomic) Player* player;
@property (nonatomic) NSMutableArray* walls;

-(id)initFromLevel:(NSString*)levelPath;

-(void)updatePlayerPosition:(Player*)player;

@end
