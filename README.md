**Yuninfo 内部分享文档 陈伟鹏 **

#Transfrom Demo
##类和函数说明
###ZBTransformViewController
主要演示的知识点是 显式创建动画 和 并行动画。看-(void)loadView
	
	eg：'line 83' the example to create  explicit animation
	ZBGridLayer *layer3 = [[[ZBGridLayer alloc] init] autorelease];
	layer3.frame = CGRectMake(20.0, 260.0, 100.0, 100.0);
	layer3.image = [UIImage imageNamed:@"bike3.jpg"];
	[self.view.layer addSublayer:layer3];

	CABasicAnimation *a3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	a3.fromValue = [NSNumber numberWithFloat:0.0];
	a3.toValue = [NSNumber numberWithFloat:M_PI * 2];
	a3.autoreverses = YES;
	a3.repeatCount = NSUIntegerMax;
	a3.duration = 2.0;
	[layer3 addAnimation:a3 forKey:@"z"];
	
	eg:
	[layer5 addAnimation:a2 forKey:@"y"];
	[layer5 addAnimation:a3 forKey:@"z"];
	
	

#Path Demo
##知识点说明
建立非线性动画意味着自己建立动画的值系列,它可以是一些值的数组，如果这些值的类型都是CGPoint，那么就可以指定path。在大多数情况下，使用NSValue去封装CGRect以及CATransform3D，使用NSNumber去封装CGFloat等，至于CGColorRef，则需将其转换成id类型。

##类和函数说明
###ZBPathViewController
在ZBPathViewController中使用被增强的viewZBPathView来替换掉原来的 view
    
    - (void)loadView 
    {
	ZBPathView *pathView = [[ZBPathView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	pathView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view = [pathView autorelease];
    }
    
###ZBPathView
   它引用了一个具有填充颜色的CALayer的子类。**ZBLayoutLayer *spot;
**  
   非线性的动画意味着自己建立动画的值，先用以下代码建立position的值数组，根据框架的特性，可以直接使用path属性
   
    path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 20.0, 40.0);
	for (NSUInteger i = 0; i < 10; i++) {
		CGFloat x = (i % 2) ? 20.0 : self.bounds.size.width - 20.0;
		CGFloat y = 40.0 + 30.0 * (i + 1);
    //  CGPathAddLineToPoint(path, NULL, x, y);
		CGPathAddArcToPoint(path, NULL, x, y, x, y + 20.0, 10.0);
	}
	。。。
	animation.path = path;
   
   接着使用**CAKeyframeAnimation**，由于不指定
   
   	
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	animation.duration = 5.0;
	animation.path = path;
	animation.repeatCount = NSUIntegerMax;
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[spot addAnimation:animation forKey:@"move"];
   
#Table view Demo
##知识点说明
  Animation Group。。并行动画组管理
  
    //CATransaction 让layer的属性更改以底层事务的方式更新到render tree. 
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	transitionLayer.opacity = 1.0;
	transitionLayer.contents = (id)aCell.imageView.image.CGImage;
	transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:aCell.imageView.bounds fromView:aCell.imageView];
	[[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
	[CATransaction commit];

##ZBAnimateTableViewController

	很简单，CATransaction在这里不是必须的，但是如果要有必须马上更新到render tree的情况，使用CATransaction。
     - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	transitionLayer.opacity = 1.0;
	transitionLayer.contents = (id)aCell.imageView.image.CGImage;
	transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:aCell.imageView.bounds fromView:aCell.imageView];
	[[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
	[CATransaction commit];
	
	CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:transitionLayer.position];
	positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];

	CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:transitionLayer.bounds];
	boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectZero];

	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	opacityAnimation.toValue = [NSNumber numberWithFloat:0.5];	
	
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
	rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];	
	
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.beginTime = CACurrentMediaTime() + 0.25;
	group.duration = 0.5;
	group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, opacityAnimation, rotateAnimation, nil];
	group.delegate = self;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	
	[transitionLayer addAnimation:group forKey:@"move"];
    }
	
#firework Demo
##知识点
3.6动画结束后。。
 1）setCompletionBlock: 
 2）使用 animationDidStart: andanimationDidStop:finished: delegate methods.
 
5.3景深
  sublayerTransform 便利的矩阵，适用于所有子类
  zPosition,只有在父layer设定了视口的位置之后，才会产生景深。设定视口是这样子设的
CATransform3D perspective = CATransform3DIdentity;
perspective.m34 = -1.0/eyePosition;
 
// Apply the transform to a parent layer.
myParentLayer.sublayerTransform = perspective;


##类和函数描述
这个Demo首先是用子类化的圆圈layer，进行move动画（位置移动），然后爆炸动画是一个组合的动画explode（由position和opacity合成）

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	self.position = inFrom;
	[CATransaction commit];
	[inSuperlayer addSublayer:self];
	
	//先制定了delegate
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.duration = 0.5;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.fromValue = [NSValue valueWithCGPoint:inFrom];
	animation.toValue = [NSValue valueWithCGPoint:inTo];
	animation.delegate = self;
	[self addAnimation:animation forKey:@"move"];
	
	在这里继续接着组合的动画explode（由position和opacity合成）
	- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{。。。}

   
关于知识点景深，是我自己添加的。
     
    首先在是在laySubviews里面，调整视口
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/(random()%2+1);
    NSLog(@"%f",perspective.m34 );
    // Apply the transform to a parent layer.
    self.layer.sublayerTransform = perspective;
    
    
    在产生和设置layer时设置aLyaer的zPosition就可以啦
    - (void)tap:(UIGestureRecognizer *)r
    {
	CGPoint location = [r locationInView:self];
	CGFloat hue = [NSDate timeIntervalSinceReferenceDate] - floor([NSDate timeIntervalSinceReferenceDate]);
	ZBFireworkLayer *aLayer = [[[ZBFireworkLayer alloc] initWithHue:hue] autorelease];
	CGPoint from = CGPointMake(location.x, self.bounds.size.height - 50.0);
	CGPoint to = CGPointMake(location.x, (self.bounds.size.height - 100.0) * (random() % 100 / (CGFloat) 100));
	
    aLayer.zPosition = random() % 100 / 100.0f;
	[aLayer animateInLayer:self.layer from:from to:to];
    }

#Banana Demo
##主要类和函数说明
###ZBBananaLayer
   计时器timer导致的图片tiff切换，以及动画，给人一种复杂动画的感觉
   
##知识点
    

	-(void)pauseAndResume
	{
    if (bananaLayer.speed == 0)
    {
        [self resumeLayer:bananaLayer];
    }
    else
    {
        [self pauseLayer:bananaLayer];
    }
	}

	-(void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
	}

	-(void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
	}


   
