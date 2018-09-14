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

@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet NewsTableView *newsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *catagoryScrollView;
@property (nonatomic) NSURL *apiURL;
@property (atomic) BOOL networkPresent;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsTableView.rowHeight = 70;
    self.apiURL = [NSURL URLWithString:@"https://newsapi.org/v2/top-headlines?country=in&apiKey=e12b38aab6f546b78700191506122030"];
    [self moniterNetworkPresenceAndFetchNews];
}

- (void) moniterNetworkPresenceAndFetchNews {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
            NSLog(@"Internet not found");
            [self displayNoNetworkToast];
            self.networkPresent = NO;
        } else {
            NSLog(@"Internet found");
            self.networkPresent = YES;
        }
        [self fetchNews];
    }];
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
    if (!self.networkPresent) {
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
        //[self saveIntoCoreData: successJsonModel.articles];
    } else {
        NSLog(@"Fetch Unsuccessful.");
    }
}

- (void) fetchNewsFromCoreData {
    
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
                    NSString *url = self.newsTableView.newsArray[indexPath.row][@"url"];
                    [self prepareWebViewController:segue.destinationViewController toDisplayURL:url];
                }
            }
        }
    }
}


//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

//- (void) saveIntoCoreData:(NSArray *)articleArray {
//    NSManagedObjectContext *context = [self managedObjectContext];
//
//    NSManagedObject *data = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:context];
//    [data setValue:articleArray.description forKey:@"data"];
//
//    NSError *error = nil;
//    // Save the object to persistent store
//    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//    }
//}

@end
