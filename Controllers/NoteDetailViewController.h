//
//  NoteDetailViewController.h
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/14/26.
//

#import <UIKit/UIKit.h>
#include <objc/objc.h>
@class Note;

@protocol NoteDetailViewControllerDelegate <NSObject>

- (void)noteDetailViewControllerDidSaveNote:(Note *)note;
@optional
- (void)noteDetailViewControllerDidCancel;

@end

@interface NoteDetailViewController : UIViewController

- (instancetype)initWithNote:(Note *)note;
@property (nonatomic, strong) Note *note;
@property (nonatomic, weak) id<NoteDetailViewControllerDelegate> delegate;

@end
