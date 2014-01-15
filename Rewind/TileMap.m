//
//  TileMap.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/8/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "TileMap.h"



@implementation TileMap

-(id)initMapFromFilePath:(NSString*)path withPosition:(CGPoint)position tileSize:(int) TS {
    if (self = [super init]) {
        NSString *stringRepresentation = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.stringRepByLines = [stringRepresentation componentsSeparatedByString:@"b"];
        
        for (NSString* line in self.stringRepByLines) NSLog(line);
        
//        [self arrayByAddingObjectsFromArray:self.stringRepByLines];
        
        int width = 0;
        
        for (NSString* line in self.stringRepByLines) {
            NSLog(@"%i",line.length);
            unichar character = [line characterAtIndex:0];
            NSLog(@"%c", character);
            if (width < line.length) {
                width = line.length;
            }
        }
        self.dimensions = CGPointMake((int)self.stringRepByLines.count,(int)width);
        NSLog(@"%f,%f",self.dimensions.x,self.dimensions.y);
        self.position = position;
        self.TS = TS;
    }
    return self;
}

-(NSString*)objectAtIndex:(CGPoint)tile {
    
    if (tile.x < self.dimensions.x) {
        if (tile.y < self.dimensions.y) {
            unichar characterAtIndex = [[self.stringRepByLines objectAtIndex:tile.x] characterAtIndex:tile.y];
            
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
    
    return CGPointMake(((tile.y-1)*self.TS)+(self.TS/2)+self.position.x, ((tile.x)*self.TS)+(self.TS/2) + self.position.y);

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
    
    [surroundingTiles exchangeObjectAtIndex:0 withObjectAtIndex:3];
    [surroundingTiles exchangeObjectAtIndex:2 withObjectAtIndex:4];
    [surroundingTiles exchangeObjectAtIndex:3 withObjectAtIndex:6];
    
    return surroundingTiles;
}

@end
