//
//  TileMap.h
//  Rewind
//
//  Created by PHILLIP SEO on 1/15/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TileMap : NSMutableArray

@property (nonatomic) int TS;
@property (nonatomic) CGPoint size;
@property (nonatomic) CGPoint origin;
@property (nonatomic) NSArray* levelByLines;

-(id) initWithFile:(NSString*)path withTileSize:(int) tileSize atOrigin:(CGPoint)origin;
-(CGPoint) tileFromPosition:(CGPoint)position;
-(CGPoint) positionFromTile:(CGPoint)tile;
-(NSArray*) getTilesAroundTile:(CGPoint)tile;

@end
