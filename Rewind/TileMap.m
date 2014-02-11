//
//  TileMap.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/15/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "TileMap.h"
#import "MyScene.h"

@implementation TileMap



-(id) initWithFile:(NSString*)path withTileSize:(int)tileSize atOrigin:(CGPoint)origin {
    if (self = [super init]) {
        _TS = tileSize;
        NSString* level = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        _levelByLines = [level componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
    }
    return self;
    }

-(CGPoint) tileFromPosition:(CGPoint)position {
    CGPoint tile;
    CGPoint adjustedPos = CGPointMake(position.x - self.origin.x, position.y-self.origin.y);
    
    tile = CGPointMake(floor(adjustedPos.x/_TS), floor(adjustedPos.y/_TS));
    
    return tile;
}


-(CGPoint) positionFromTile:(CGPoint)tile {
    CGPoint pos;
    pos = CGPointMake(tile.x*_TS + _TS/2 + _origin.x, tile.y*_TS + _TS/2 + _origin.y);
    
    return pos;
}

-(NSArray*)getTilesAroundTile:(CGPoint)tile {
    
    NSMutableArray *surroundingTiles = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = -1; i<= 1; i++) {
        for (int j = -1; j<=1; j++) {
            if (i!=0 || j!=0) {
                [surroundingTiles addObject:[NSValue valueWithCGPoint:CGPointMake(tile.x+i, tile.y+j)]];
            }
        }
    }
    
    [surroundingTiles exchangeObjectAtIndex:0 withObjectAtIndex:3];
    [surroundingTiles exchangeObjectAtIndex:2 withObjectAtIndex:4];
    [surroundingTiles exchangeObjectAtIndex:3 withObjectAtIndex:6];
    
    return surroundingTiles;
    
}

@end
