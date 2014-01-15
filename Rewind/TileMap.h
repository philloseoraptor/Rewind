//
//  TileMap.h
//  Rewind
//
//  Created by PHILLIP SEO on 1/8/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TileMap : NSMutableArray

@property (nonatomic) CGPoint position;
@property (nonatomic) int TS;
@property (nonatomic) NSArray *stringRepByLines;
@property (nonatomic) CGPoint dimensions;

-(id)initMapFromFilePath:(NSString*)path withPosition:(CGPoint)position tileSize:(int) TS;
-(NSString*)objectAtIndex:(CGPoint)tile;
-(CGPoint)tileFromLocation:(CGPoint)location;
-(CGPoint)locationFromTile:(CGPoint)tile;
-(NSArray*)getTilesAroundTile:(CGPoint)tile;

@end
