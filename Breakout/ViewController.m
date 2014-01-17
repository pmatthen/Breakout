//
//  ViewController.m
//  Breakout
//
//  Created by Apple on 16/01/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UICollisionBehaviorDelegate, UIAlertViewDelegate>
{
    
    __weak IBOutlet PaddleView *paddleView;
    __weak IBOutlet BallView *ballView;
    
    UIDynamicAnimator *dynamicAnimator;
    UIDynamicItemBehavior *paddleDynamicBehavior;
    UIDynamicItemBehavior *ballDynamicBehavior;
    UIDynamicItemBehavior *blockDynamicBehavior;
    UIPushBehavior *pushBehavior;
    UICollisionBehavior *collisionBehavior;
    NSMutableArray *unstruckBlocks;
    BOOL gameHasBegun;
    UIAlertView *alert;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    unstruckBlocks = [NSMutableArray array];
    [self drawBlocks];
    
    gameHasBegun = NO;
    // Set ball image
    NSString *ballImagePath = [[NSBundle mainBundle] pathForResource:@"ball" ofType:@"png" inDirectory:@"pongAssets"];
    ballView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:ballImagePath]];
    [ballView setOpaque:NO];
    
    // Set paddle image
    NSString *paddleImagePath = [[NSBundle mainBundle] pathForResource:@"paddle" ofType:@"png" inDirectory:@"pongAssets"];
    paddleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:paddleImagePath]];
    [paddleView setOpaque:NO];
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:unstruckBlocks];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:unstruckBlocks];
    collisionBehavior.collisionDelegate = self;
    [collisionBehavior addItem:paddleView];
    [collisionBehavior addItem:ballView];
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 100000000;
    paddleDynamicBehavior.elasticity = 1.0;
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    blockDynamicBehavior.allowsRotation = NO;
    blockDynamicBehavior.elasticity = 1.0;
    blockDynamicBehavior.friction = 0.0;
    blockDynamicBehavior.resistance = 0.0;
    blockDynamicBehavior.density = 100000000;
    
    [dynamicAnimator addBehavior:blockDynamicBehavior];
    
    pushBehavior.pushDirection = CGVectorMake(0.3, 0.9);
    pushBehavior.magnitude = 0.5;
    
    pushBehavior.active = NO;
    [dynamicAnimator addBehavior:pushBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
}

-(void)drawBlocks
{
    for (int x = 0; x < 6; x++) {
        for (int y = 0 ; y < 6; y++) {
            BlockView *tempBlockView = [[BlockView alloc] initWithFrame:CGRectMake( ((x * 40) + 40), ((y * 15) + 40), 40, 15)];
            tempBlockView.backgroundColor = [UIColor blueColor];
            tempBlockView.layer.borderColor = [UIColor blackColor].CGColor;
            tempBlockView.layer.borderWidth = 1.0f;
            [unstruckBlocks addObject:tempBlockView];
            [self.view addSubview:tempBlockView];
        }
    }
}

-(void)restartLife
{
    gameHasBegun = NO;
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:unstruckBlocks];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:unstruckBlocks];
    collisionBehavior.collisionDelegate = self;
    [collisionBehavior addItem:paddleView];
    [collisionBehavior addItem:ballView];
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 100000000;
    paddleDynamicBehavior.elasticity = 1.0;
    paddleDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    blockDynamicBehavior.allowsRotation = NO;
    blockDynamicBehavior.elasticity = 1.0;
    blockDynamicBehavior.friction = 0.0;
    blockDynamicBehavior.resistance = 0.0;
    blockDynamicBehavior.density = 100000000;
    
    [dynamicAnimator addBehavior:blockDynamicBehavior];
    
    pushBehavior.pushDirection = CGVectorMake(0.3, 0.9);
    pushBehavior.active = NO;
    pushBehavior.magnitude = 0.5;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
}

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    if (gameHasBegun == NO)
    {
        gameHasBegun = YES;
        pushBehavior.active = YES;
        [dynamicAnimator addBehavior:pushBehavior];
    }
    
    paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];

}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (p.y > 560)
    {
        ballView.center = self.view.center;
        [dynamicAnimator updateItemUsingCurrentState:ballView];
        [self restartLife];
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    // Check to see if items colliding are of BallView and BlockView classes
    if ([item1 isKindOfClass:[BallView class]] && [item2 isKindOfClass:[BlockView class]])
    {
        NSLog(@"Ball and Block Collided");
        
        [[unstruckBlocks objectAtIndex:[unstruckBlocks indexOfObjectIdenticalTo:item2]] removeFromSuperview];
        [collisionBehavior removeItem:[unstruckBlocks objectAtIndex:[unstruckBlocks indexOfObjectIdenticalTo:item2]]];
        [unstruckBlocks removeObjectAtIndex:[unstruckBlocks indexOfObjectIdenticalTo:item2]];
        [self shouldStartAgain:unstruckBlocks];
    }

    if ([item1 isKindOfClass:[PaddleView class]] && [item2 isKindOfClass:[BallView class]])
    {
        NSLog(@"(%f, %f)", [ballDynamicBehavior linearVelocityForItem:ballView].x, [ballDynamicBehavior linearVelocityForItem:ballView].y);
        NSLog(@"Point: (%f, %f)", p.x, p.y);
        NSLog(@"Paddle: (%f, %f)",paddleView.frame.origin.x, paddleView.frame.origin.y);
        
        float linearVelocityX = [ballDynamicBehavior linearVelocityForItem:ballView].x;
        float whereOnPaddlePercent = (p.x - paddleView.frame.origin.x - (paddleView.frame.size.width / 2)) / (paddleView.frame.size.width / 2);
        
        linearVelocityX = linearVelocityX * whereOnPaddlePercent * 2;
        [ballDynamicBehavior addLinearVelocity:CGPointMake(linearVelocityX, 0) forItem:ballView];
        
    }
}

-(BOOL)shouldStartAgain:(NSArray *)NSArray
{
    if (NSArray.count == 0)
    {
        [dynamicAnimator removeAllBehaviors];
        alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"Winner Winner Chicken Dinner!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Play Again", nil];
        [alert show];
        return YES;
    }
    return NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ballView.center = self.view.center;
        [dynamicAnimator updateItemUsingCurrentState:ballView];
        [self drawBlocks];
        [self restartLife];
    }
}

@end
