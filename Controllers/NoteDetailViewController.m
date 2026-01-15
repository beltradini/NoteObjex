//
//  NoteDetailViewController.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/14/26.
//

#import "NoteDetailViewController.h"
#import "Note.h"

@interface NoteDetailViewController ()
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextView *contentView;
@end

@implementation NoteDetailViewController

- (instancetype)initWithNote:(Note *)note {
    self = [super init];
    if (self) {
        _note = note;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Note";
    
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width-40, 40)];
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.text = self.note.title;
    self.titleField.placeholder = @"Title";
    [self.view addSubview:self.titleField];
    
    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width-40, 200)];
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.cornerRadius = 8.0;
    self.contentView.text = self.note.content;
    [self.view addSubview:self.contentView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
}

- (void)saveNote {
    self.note.title = self.titleField.text;
    self.note.content = self.contentView.text;
    self.note.updatedAt = [NSDate date];
    if ([self.delegate respondsToSelector:@selector(noteDetailViewControllerDidSaveNote:)]) {
        [self.delegate noteDetailViewControllerDidSaveNote:self.note];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
