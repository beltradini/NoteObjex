//
//  ViewController.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/2/26.
//

#import "ViewController.h"
#import "NotesStore.h"
#import "Note.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];

    self.title = @"Notes";
    self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
       UIBarButtonSystemItemAdd
       target:self
       action:@selector(addNote)];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[[NotesStore sharedStore] allNotes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"Cell"];
    }

    Note *note =
      [[NotesStore sharedStore] allNotes][indexPath.row];

    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = note.content;

    return cell;
}

- (void)addNote {
    Note *note = [[Note alloc] initWithTitle:@"New Note"
                                     content:@""];
    [[NotesStore sharedStore] addNote:note];
    [self.tableView reloadData];
}

@end
