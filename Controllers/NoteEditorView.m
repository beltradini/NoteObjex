//
//  NoteEditorView.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/5/26.
//

#import "NoteEditorView.h"
#import "Note.h"

@interface NoteEditorView ()
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextView *contentView;
@end

@implementation NoteEditorView

- (instancetype)initWithNote:(Note *)note {
    self = [super init];
    if (self) {
        _note = note;
    }
    return self;
}

@end
