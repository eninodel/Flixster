//
//  GridViewController.m
//  Flixter
//
//  Created by Edwin Delgado on 6/16/22.
//

#import "GridViewController.h"
#import "MovieCollectionViewCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (strong, nonatomic) NSArray *myArray;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moviesCollectionView.delegate = self;
    self.moviesCollectionView.dataSource = self;

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
               [self.moviesCollectionView  reloadData];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    
    [task resume];

    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    NSIndexPath *indexOfSender = [self.moviesCollectionView indexPathForCell: sender];
    NSDictionary *dataToPass = self.myArray[indexOfSender.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.dataDict = dataToPass;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500/";
    NSString *imageUrl = self.myArray[indexPath.row][@"poster_path"];
    NSString *fullUrl = [baseUrl stringByAppendingString:imageUrl];
    NSURL *posterImageUrl = [NSURL URLWithString:fullUrl];
    [cell.posterImage setImageWithURL:posterImageUrl];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger size = self.myArray.count;
    return size;
}



@end
