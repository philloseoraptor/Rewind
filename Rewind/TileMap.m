//
//  TileMap.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/8/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "TileMap.h"

NSArray *stringRepByLines;

@implementation TileMap

-(id)initMapFromFilePath:(NSString*)path withPosition:(CGPoint)position tileSize:(int) TS {
    if (self = [super init]) {
        NSString *stringRepresentation = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        stringRepByLines = [stringRepresentation componentsSeparatedByString:@"b"];
        
        [self arrayByAddingObjectsFromArray:stringRepByLines];
        
        self.position = position;
        self.TS = TS;
    }
    return self;
}

-(NSString*)objectAtIndex:(CGPoint)tile {
    
    if (tile.x < stringRepByLines.count) {
        if (tile.y < [[stringRepByLines objectAtIndex:tile.x] length]) {
            unichar characterAtIndex = [[stringRepByLines objectAtIndex:tile.x] characterAtIndex:tile.y];
            
            if (characterAtIndex == ' ') return @"empty";
            else if (characterAtIndex == 's') return @"start";
            else if (characterAtIndex == 'w') return @"wall";
            else if (characterAtIndex == 'g') return @"goal";
            else return @"NA";
            
        }
    }
    
    return @"NA";
    
}

-(CGPoint)tileFromLocation:(CGPoint)location {
    CGPoint normalizedPos = CGPointMake(location.x-self.position.x, location.y-self.position.y);
    
    return CGPointMake(floor((float)normalizedPos.x/self.TS), floor((float)normalizedPos.y/self.TS));
    
}

-(CGPoint)locationFromTile:(CGPoint)tile {
    
    return CGPointMake(((float)(tile.x)*self.TS)+(self.TS/2)+self.position.x, ((float)(tile.y)*self.TS)+(self.TS/2) + self.position.y);

}

-(NSArray*)getTilesAroundTile:(CGPoint)tile {
    
    NSMutableArray *surroundingTiles = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j<=1; j++) {
            if (i != 0 && j != 0) {
                [surroundingTiles addObject:[NSValue valueWithCGPoint:CGPointMake(tile.x+i, tile.y+j)]];
            }
        }
    }
    
    return surroundingTiles;
}

@end
