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
   
	



