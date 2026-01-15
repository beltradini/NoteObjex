//
//  ViewController.m
//  NoteObjex
//
//  Created by Alejandro Beltrán on 1/2/26.
//

#import "ViewController.h"
#import "NotesStore.h"
#import "Note.h"
#import "NoteDetailViewController.h"

typedef NS_ENUM(NSInteger, NotesSortType) {
    NotesSortTypeCreationDate = 0,
    NotesSortTypeUpdateDate,
    NotesSortTypeTitle
};

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NoteDetailViewControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSArray<Note *> *filteredNotes;
@property (nonatomic, assign) BOOL isFiltering;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, assign) NotesSortType sortType;
@property (nonatomic, strong) UISegmentedControl *sortControl;

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
    
    self.filteredNotes = @[];
    self.isFiltering = NO;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = (id<UISearchResultsUpdating>)self;
    self.searchController.searchBar.placeholder = @"Buscar notas";
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.sortType = NotesSortTypeCreationDate;
    self.sortControl = [[UISegmentedControl alloc] initWithItems:@[@"Creación", @"Modificada", @"Título"]];
    self.sortControl.selectedSegmentIndex = self.sortType;
    [self.sortControl addTarget:self action:@selector(sortChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.sortControl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self displayedNotes].count;
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

    Note *note = [self displayedNotes][indexPath.row];

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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note = [[NotesStore sharedStore] allNotes]
        [indexPath.row];
        [[NotesStore sharedStore] deleteNote:note];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *selectedNote = [self displayedNotes][indexPath.row];
    NoteDetailViewController *detailVC = [[NoteDetailViewController alloc]initWithNote:selectedNote];
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)noteDetailViewControllerDidSaveNote:(Note *)note {
    [[NotesStore sharedStore] save];
    self.isFiltering = NO;
    self.searchController.searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text.lowercaseString;
    if (searchText.length == 0) {
        self.isFiltering = NO;
        [self.tableView reloadData];
        return;
    }
    NSArray *allNotes = [[NotesStore sharedStore] allNotes];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Note *note, NSDictionary *bindings) {
        return [note.title.lowercaseString containsString:searchText] ||
               [note.content.lowercaseString containsString:searchText];
    }];
    self.filteredNotes = [allNotes filteredArrayUsingPredicate:predicate];
    self.isFiltering = YES;
    [self.tableView reloadData];
}

- (void)sortChanged:(UISegmentedControl *)sender {
    self.sortType = (NotesSortType)sender.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (NSArray<Note *> *)displayedNotes {
    NSArray *notes = self.isFiltering ? self.filteredNotes : [[NotesStore sharedStore] allNotes];
    if (self.sortType == NotesSortTypeCreationDate) {
        notes = [notes sortedArrayUsingComparator:^NSComparisonResult(Note *a, Note *b) {
            return [b.createdAt compare:a.createdAt];
        }];
    } else if (self.sortType == NotesSortTypeUpdateDate) {
        notes = [notes sortedArrayUsingComparator:^NSComparisonResult(Note *a, Note *b) {
            return [b.updatedAt compare:a.updatedAt];
        }];
    } else if (self.sortType == NotesSortTypeTitle) {
        notes = [notes sortedArrayUsingComparator:^NSComparisonResult(Note *a, Note *b) {
            return [a.title.lowercaseString compare:b.title.lowercaseString];
        }];
    }
    return notes;
}

@end
