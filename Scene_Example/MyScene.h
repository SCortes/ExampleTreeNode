//
//  MyScene.h
//  Scene_Example
//

//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property(strong, nonatomic) SKTexture *sonicSheet;
@property(strong, nonatomic) SKNode * conjunto;
@property(strong, nonatomic) SKSpriteNode * jaula;
@property(strong, nonatomic) NSDictionary * coordenadas;
@property(strong, nonatomic) SKNode * seleccionado;


@end
