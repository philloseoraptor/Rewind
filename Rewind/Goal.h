//
//  Goal.h
//  Rewind
//
//  Created by PHILLIP SEO on 1/22/14.
//  Copyright (c) 2014 Phillip Seo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Goal : SKSpriteNode

@property (nonatomic) NSString* toPath;

-(id) initWithPosition:(CGPoint)position withPathTo:(NSString*)path;

@end
