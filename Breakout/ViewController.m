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

@interface ViewController ()
{
    
    __weak IBOutlet PaddleView *paddleView;
    __weak IBOutlet BallView *ballView;
    __weak IBOutlet BlockView *blockView;
    
    UIDynamicAnimator *dynamicAnimator;
    UIDynamicItemBehavior *paddleDynamicBehavior;
    UIDynamicItemBehavior *ballDynamicBehavior;
    UIDynamicItemBehavior *blockDynamicBehavior;
    UIPushBehavior *pushBehavior;
    UICollisionBehavior *collisionBehavior;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[blockView]];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[paddleView, ballView, blockView]];
    collisionBehavior.collisionDelegate = self;
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 100000000;
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    blockDynamicBehavior.allowsRotation = NO;
    blockDynamicBehavior.elasticity = 0.0;
    blockDynamicBehavior.friction = 0.0;
    blockDynamicBehavior.resistance = 0.0;
    blockDynamicBehavior.density = 100000000;
    
    [dynamicAnimator addBehavior:blockDynamicBehavior];
    
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 0.9);
    pushBehavior.active = YES;
    pushBehavior.magnitude = 0.5;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    
    [dynamicAnimator addBehavior:collisionBehavior];
}

-(void)restartTurn
{
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[blockView]];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[paddleView, ballView, blockView]];
    collisionBehavior.collisionDelegate = self;
    
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 100000000;
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    blockDynamicBehavior.allowsRotation = NO;
    blockDynamicBehavior.elasticity = 0.0;
    blockDynamicBehavior.friction = 0.0;
    blockDynamicBehavior.resistance = 0.0;
    blockDynamicBehavior.density = 100000000;
    
    [dynamicAnimator addBehavior:blockDynamicBehavior];
    
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 0.9);
    pushBehavior.active = YES;
    pushBehavior.magnitude = 0.5;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
}



- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x, paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];

}



- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{

    if (ballView.center.y > 540) {
        NSLog(@"Center = %f", ballView.center.y);
        ballView.center = self.view.center;
        [dynamicAnimator updateItemUsingCurrentState:ballView];
        [self restartTurn];
        
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isKindOfClass:[BallView class]] && [item2 isKindOfClass:[BlockView class]]) {
        NSLog(@"Ball and Block Collided");
        
        
        [collisionBehavior removeItem:blockView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
