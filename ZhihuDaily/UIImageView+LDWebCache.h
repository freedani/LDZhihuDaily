//
//  UIImageView+LDWebCache.h
//  ZhihuDaily
//
//  Created by 李达 on 2017/3/15.
//  Copyright © 2017年 李达. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, LDWebImageOptions) {
    /**
     * By default, the image is downloaded according to network condition.
     * This flag forces downloading image.
     */
    LDWebImageForced = 1 << 0,
    
};

@interface UIImageView (LDWebCache)

- (void) ld_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
                 ld_options:(LDWebImageOptions)ldOptions
                 sd_options:(SDWebImageOptions)sdOptions
                   progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(nullable SDExternalCompletionBlock)completedBlock;

                    


@end
