//
//  MyScene.m
//  Scene_Example
//
//  Created by Sergio on 05/03/14.
//  Copyright (c) 2014 Sergio. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
@synthesize coordenadas, sonicSheet, conjunto, jaula, seleccionado;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.name = @"escena";
        self.backgroundColor = [SKColor lightGrayColor];
        
        sonicSheet = [SKTexture textureWithImageNamed:@"SuperSonic2.gif"];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *plistName = @"Lista_Sprites.plist";
        NSString *finalPath = [path stringByAppendingPathComponent:plistName];
        coordenadas = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray * animacion = [[NSArray alloc] initWithArray:[self loadFramesFromSpriteSheet:sonicSheet WithBaseFileName:@"sonic_fly" WithNumberOfFrames:4 WithCoordenadas:coordenadas]];

        //Creates 8 sonic sprites
        for(int i=0; i<=7; i++){
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:animacion[1]];
            
            [sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:animacion
                                                                             timePerFrame:0.2]]];
            
            sprite.position = CGPointMake(CGRectGetMinX(self.frame)*1, CGRectGetMinY(self.frame)+60+50*i);
            sprite.anchorPoint = CGPointMake(0, 0);
            sprite.name = @"sonic";
            [self addChild:sprite];
            
        }
        
        conjunto = [SKNode node];
        conjunto.name=@"conjunto";
        conjunto.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        SKTexture * cage = [SKTexture textureWithImageNamed:@"jaula.png"];
        jaula = [[SKSpriteNode alloc] initWithTexture:cage];
        jaula.name = @"jaula";
        jaula.zPosition = 1;
        jaula.position = CGPointMake(0,0);
        jaula.size = CGSizeMake(jaula.size.width*0.8, jaula.size.height*0.8);
        jaula.anchorPoint = CGPointMake(0.5,0.5);
        
        [self addChild:conjunto];
        [conjunto addChild:jaula];
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        SKNode *primerNodo = [self nodeAtPoint:[touch locationInNode:self]];
        
        NSArray *lista = [self nodesAtPoint:[touch locationInNode:self]];
        if(lista.count>=3 && [lista containsObject:conjunto]){
            SKNode * nodo1 = lista[1];
            SKNode * nodo2 = lista[2];
            if([nodo1.name isEqualToString:@"sonic"]){
                seleccionado = lista[1];
            }
            else if([nodo2.name isEqualToString:@"sonic"]){
                
                seleccionado = lista[2];
                [seleccionado removeFromParent];
                seleccionado.zPosition = 0;
                seleccionado.position = [self convertPoint:seleccionado.position fromNode:conjunto];
                [self addChild:seleccionado];
            }
            
        }
        else{
            if ([primerNodo.parent.name isEqualToString:@"conjunto"]) {
                
                seleccionado = primerNodo.parent;
            
            }else{
                
                seleccionado = [self nodeAtPoint:[touch locationInNode:self]];
            }
        }
        
        
        
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - Method to generate array of textures

-(NSArray *)loadFramesFromSpriteSheet:(SKTexture *)textureSpriteSheet
WithBaseFileName: (NSString *)baseFileName WithNumberOfFrames: (int)
numberOfFrames WithCoordenadas: (NSDictionary *)coordenadasSpriteSheet
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numberOfFrames
                              +1];
    for(int i = 1; i<=numberOfFrames;i++)
    {
        NSDictionary *coordenadasSprite = [coordenadasSpriteSheet objectForKey:
                                           [NSString stringWithFormat:@"%@%d", baseFileName, i]];
        NSString *x = [coordenadasSprite objectForKey:@"x"];
        NSString *y = [coordenadasSprite objectForKey:@"y"];
        NSString *width = [coordenadasSprite objectForKey:@"width"];
        NSString *height = [coordenadasSprite objectForKey:@"height"];
        SKTexture *texture = [SKTexture textureWithRect:
                              CGRectMake((CGFloat)[x floatValue]/
                                         textureSpriteSheet.size.width,
                                         (textureSpriteSheet.size.height-(CGFloat)[y floatValue]-((CGFloat)[height floatValue]))/textureSpriteSheet.size.height,(CGFloat)[width floatValue]/textureSpriteSheet.size.width,(CGFloat)[height floatValue]/
                                         textureSpriteSheet.size.height)
                        inTexture:textureSpriteSheet];
        [frames addObject:texture];
    }
    return frames;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        seleccionado.position = [touch locationInNode:self];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        if([seleccionado.name isEqualToString:@"sonic"]){
            NSArray *lista = [self nodesAtPoint:[touch locationInNode:self ]];
            if([lista containsObject:conjunto]){
                [seleccionado removeFromParent];
                seleccionado.zPosition = 0;
                seleccionado.position = [self convertPoint:seleccionado.position toNode:conjunto];
                [conjunto addChild:seleccionado];
            
            }
        }
    }
}

@end
