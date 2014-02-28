//
//  Ghost.h
//  Rewind
//
//  Created by PHILLIP SEO on 2/28/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ghost : SKSpriteNode

@property (nonatomic) NSMutableArray* path;

-(id)initWithPath:(NSMutableArray*)path;
-(void)updateGhostToFrame:(int)frame;

@end