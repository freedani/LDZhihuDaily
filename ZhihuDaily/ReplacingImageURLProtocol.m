//
//  ReplacingImageURLProtocol.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/3/22.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "ReplacingImageURLProtocol.h"

static NSString* const FilteredKey = @"FilteredKey";

@implementation ReplacingImageURLProtocol

+ (BOOL)isImage:(NSString *)extension {
    return [@[@"png", @"jpeg", @"gif", @"jpg"] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [extension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }] != NSNotFound;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSString *extension = request.URL.pathExtension;
    BOOL isImage = [self isImage:extension];
    if ([NSURLProtocol propertyForKey:FilteredKey inRequest:request] == nil && isImage && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        return true;
    }
    return false;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest* request = self.request.mutableCopy;
    [NSURLProtocol setProperty:@YES forKey:FilteredKey inRequest:request];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[request.URL absoluteString]];
    NSData *data;
    if (image) {
        data = UIImagePNGRepresentation(image);
    }
    if (!data) {
        data = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder"]);
    }
    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
    
}

@end
