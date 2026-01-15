//
//  SceneDelegate.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/2/26.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
options:(UISceneConnectionOptions *)connectionOptions {

    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    ViewController *notesVC = [[ViewController alloc] init];
    UINavigationController *nav =
        [[UINavigationController alloc] initWithRootViewController:notesVC];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
