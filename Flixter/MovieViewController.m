//
//  MovieViewController.m
//  Flixter
//
//  Created by Edwin Delgado on 6/15/22.
//

#import "MovieViewController.h"
#import "TableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *myArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MovieTableView.dataSource = self;
    self.MovieTableView.delegate = self;
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=2776775714d19037afd0ba0f10c5052d"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//               NSLog(@"%@", dataDictionary);
               
               self.myArray = dataDictionary[@"results"];
               [self.tableView reloadData];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.activityIndicator stopAnimating];
           }
       }];
    
    [task resume];
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    NSIndexPath *indexOfSender = [self.tableView indexPathForCell: sender];
    NSDictionary *dataToPass = self.myArray[indexOfSender.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.dataDict = dataToPass;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500/";
    NSString *imageUrl = self.myArray[indexPath.row][@"poster_path"];
    NSString *fullUrl = [baseUrl stringByAppendingString:imageUrl];
    NSURL *posterImageUrl = [NSURL URLWithString:fullUrl];
    cell.titleLabel.text = self.myArray[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.myArray[indexPath.row][@"overview"];
    [cell.posterImage setImageWithURL:posterImageUrl];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger size = self.myArray.count;
    return size;
}

@end
