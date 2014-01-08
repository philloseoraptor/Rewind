//
//  TileMap.m
//  Rewind
//
//  Created by PHILLIP SEO on 1/8/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import "TileMap.h"

@implementation TileMap

-(id)initMapFromFilePath:(NSString*)path {
    if (self = [super init]) {
        NSString *stringRepresentation = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *stringRepByLines = [stringRepresentation componentsSeparatedByString:@"b"];
        
        for (int i = 0; i<stringRepByLines.count; i++) {
            NSString* line = [stringRepByLines objectAtIndex:i];
            for (int j = 0; j<[line length]; j++) {
                unichar letter =[[stringRepByLines objectAtIndex:i]characterAtIndex:j];
                if (letter == 'w') {
                    
                }
            }
        }
    }
    return self;
}

@end
