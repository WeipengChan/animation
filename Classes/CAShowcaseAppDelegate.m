#import "CAShowcaseAppDelegate.h"
#import "RootViewController.h"


@implementation CAShowcaseAppDelegate

- (void)dealloc 
{
	[navigationController release];
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    self.window = [[UIWindow alloc] initWithFrame:[ [UIScreen mainScreen]bounds]];
	
   // CGRect rect = self.window.frame;
    RootViewController *controller = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	
    
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    navigationController.view.frame = [UIScreen mainScreen].bounds;
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
}
- (void)applicationDidEnterBackground:(UIApplication *)application 
{
}
- (void)applicationWillEnterForeground:(UIApplication *)application 
{
}
- (void)applicationDidBecomeActive:(UIApplication *)application 
{
}
- (void)applicationWillTerminate:(UIApplication *)application 
{
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
}


@synthesize window;
@synthesize navigationController;


@end

