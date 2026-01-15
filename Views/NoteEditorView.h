//
//  NoteEditorView.h
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/5/26.
//

#import <UIKit/UIKit.h>

@class Note;

@protocol NoteEditorViewDelegate <NSObject>
- (void)noteEditorDidSave:(Note *)note;
- (void)noteEditorDidCancel;
@end

@interface NoteEditorView : UIViewController

@property (nonatomic, strong) Note *note;
@property (nonatomic, weak) id<NoteEditorViewDelegate> delegate;

- (instancetype)initWithNote:(Note *)note;

@end
