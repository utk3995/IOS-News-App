//
//  HomePageViewController.m
//  MyStore
//
//  Created by utkarsh.sri on 04/09/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "HomePageViewController.h"
#import "WebViewController.h"
#import "NewsStatusResponseModel.h"
#import "NewsSuccessModel.h"
#import "NewsTableView.h"
#import <AFNetworkReachabilityManager.h>
#import <CoreData/CoreData.h>
#import "News.h"
#import "NewsArticleModel.h"

@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet NewsTableView *newsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *catagoryScrollView;
@property (nonatomic) NSURL *apiURL;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsTableView.rowHeight = 70;
    self.apiURL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=in&apiKey=e12b38aab6f546b78700191506122030"];
    [self moniterNetworkPresence];
    [self fetchNews];
}

- (void) moniterNetworkPresence {
    NSLog(@"Started monitering");
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        [self fetchNews];
    }];
    [manager startMonitoring];
}

- (IBAction)searchAction:(UIButton *)sender {
    NSString *query = self.searchField.text;
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
    NSLog(@"%@", query);
    if (query) {
        self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&sortBy=publishedAt&sources=the-hindu&apiKey=e12b38aab6f546b78700191506122030",query]];
        [self fetchNews];
    }
}

- (BOOL) getCurrentState {
    BOOL networkState = [AFNetworkReachabilityManager sharedManager].reachable;
    NSLog(@"lala %d",networkState);
    return networkState;
}

- (IBAction)selectCatagory:(UIButton *)sender {
    NSLog(@"Button pressed : %ld",(long)sender.tag);
    switch (sender.tag) {
        case 1:
            self.apiURL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=in&apiKey=e12b38aab6f546b78700191506122030"];
            break;
        case 2:
            self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?sources=new-scientist&sortBy=publishedAt&apiKey=e12b38aab6f546b78700191506122030"]];
            break;
        case 3:
            self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?sources=financial-times&sortBy=publishedAt&apiKey=e12b38aab6f546b78700191506122030"]];
            break;
        case 4:
            self.apiURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://newsapi.org/v2/top-headlines?sources=espn&sortBy=publishedAt&apiKey=e12b38aab6f546b78700191506122030"]];
            break;
    }
    [self fetchNews];
}

-(void) displayNoNetworkToast {
    NSString *message = @"There seems to be a problem with the Network connectivity. Displaying last fetched headlines.";
    NSString *title = @"No Network!!!";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    int duration = 3; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void) fetchNews {
    if (![self getCurrentState]) {
        NSLog(@"Internet not found");
        [self fetchNewsFromCoreData];
    } else {
        NSLog(@"Internet found");
        [self fetchNewsFromAPI];
    }
}

- (void) fetchNewsFromAPI {
    NSURL *url = self.apiURL;
    NSData *jsonResultsForNews = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonDictionaryForNews = [NSJSONSerialization JSONObjectWithData:jsonResultsForNews options:0 error:NULL];
    if ([self checkForSuccessInDictionary:jsonDictionaryForNews]) {
        NSLog(@"Fetch successful");
        NewsSuccessModel *successJsonModel = [MTLJSONAdapter modelOfClass:[NewsSuccessModel class] fromJSONDictionary:jsonDictionaryForNews error:nil];
        self.newsTableView.newsArray = successJsonModel.articles;
        [self deleteOldNewsFromCoreData];
        [self saveIntoCoreData: successJsonModel.articles];
    } else {
        NSLog(@"Fetch Unsuccessful.");
    }
}

- (void) fetchNewsFromCoreData {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"News"];
    NSArray *storedNews = [managedObjectContext executeFetchRequest:request error:nil];
    self.newsTableView.newsArray = storedNews;
}



- (BOOL) checkForSuccessInDictionary: (NSDictionary *) jsonDictionary {
    NewsStatusResponseModel *statusJsonModel = [MTLJSONAdapter modelOfClass:[NewsStatusResponseModel class] fromJSONDictionary:jsonDictionary error:nil];
    if ([statusJsonModel.status isEqualToString:@"ok"])
         return YES;
    return NO;
}

- (void)prepareWebViewController:(WebViewController *)wvc toDisplayURL:(NSString *)url {
    wvc.newsURL = url;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.newsTableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display News"]) {
                if ([segue.destinationViewController isKindOfClass:[WebViewController class]]) {
                    NewsArticleModel *nsm = self.newsTableView.newsArray[indexPath.row];
                    NSString *url = nsm.url;
                    NSLog(@"%@",url);
                    [self prepareWebViewController:segue.destinationViewController toDisplayURL:url];
                }
            }
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void) deleteOldNewsFromCoreData {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"News"];
    NSArray *storedNews = [managedObjectContext executeFetchRequest:request error:nil];
    for (News *nam in storedNews) {
        [managedObjectContext deleteObject:nam];
    }
    NSError *error = nil;
    if (![managedObjectContext save:&error])
        NSLog(@"Cant delete old data");
}

- (void) saveIntoCoreData:(NSArray *)articleArray {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (NewsArticleModel *nsm in articleArray) {
        News *newsElement = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:context];
        newsElement.title = nsm.title;
        newsElement.publishedAt = nsm.publishedAt;
        newsElement.url = nsm.url;
        newsElement.urlToImage = nil;
        NSError *error = nil;
        if (![context save:&error])
            NSLog(@"Cant save");
    }
}

@end
