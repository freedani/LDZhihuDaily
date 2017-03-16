//
//  UIImageView+LDWebCache.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/3/15.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "UIImageView+LDWebCache.h"

@implementation UIImageView (LDWebCache)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)ld_setImageWithURL:(nullable NSURL *)url
{
    [self ld_setImageWithURL:url placeholderImage:nil];
}

- (void)ld_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
{
    [self ld_setImageWithURL:url placeholderImage:placeholder ld_options:0];
}


- (void)ld_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                ld_options:(LDWebImageOptions)ldOptions
{
    [self ld_setImageWithURL:url placeholderImage:placeholder ld_options:ldOptions sd_options:0];
}

- (void)ld_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                ld_options:(LDWebImageOptions)ldOptions
                sd_options:(SDWebImageOptions)sdOptions
{
    [self ld_setImageWithURL:url placeholderImage:placeholder ld_options:ldOptions sd_options:0 completed:nil];
}

- (void)ld_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                ld_options:(LDWebImageOptions)ldOptions
                sd_options:(SDWebImageOptions)sdOptions
                 completed:(nullable SDExternalCompletionBlock)completedBlock
{
    [self ld_setImageWithURL:url placeholderImage:placeholder ld_options:ldOptions sd_options:0 progress:nil completed:nil];
}

- (void)ld_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                ld_options:(LDWebImageOptions)ldOptions
                sd_options:(SDWebImageOptions)sdOptions
                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock
{
    if (ldOptions & LDWebImageForced) {
        [self sd_setImageWithURL:url placeholderImage:placeholder options:sdOptions progress:progressBlock completed:completedBlock];
    } else {
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
            UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
            self.image = lastPreviousCachedImage?:placeholder;
        } else {
            [self sd_setImageWithURL:url placeholderImage:placeholder options:sdOptions progress:progressBlock completed:completedBlock];
        }
    }
}

@end
