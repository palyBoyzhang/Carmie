#import "CAREXQImage.h"

#import <SSZipArchive/SSZipArchive.h>

@implementation CAREXQImage

+ (UIImage *)imageNamed:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }

    static NSCache<NSString *, UIImage *> *crxImageCache = nil;
    static dispatch_once_t crxCacheOnceToken;
    dispatch_once(&crxCacheOnceToken, ^{
        crxImageCache = [[NSCache alloc] init];
        crxImageCache.name = @"CAREXQImage.cache";
    });

    NSString *crxCacheKey = [NSString stringWithFormat:@"%@|%.0f", imageName, UIScreen.mainScreen.scale];
    UIImage *crxCachedImage = [crxImageCache objectForKey:crxCacheKey];
    if (crxCachedImage != nil) {
        return crxCachedImage;
    }

    [self crx_prepareImagesIfNeeded];

    UIImage *crxDiskImage = [self crx_imageFromExtractedDirectory:imageName];
    if (crxDiskImage != nil) {
        [crxImageCache setObject:crxDiskImage forKey:crxCacheKey];
        return crxDiskImage;
    }

    return nil;
}

+ (void)crx_prepareImagesIfNeeded {
    static dispatch_once_t crxUnzipOnceToken;
    dispatch_once(&crxUnzipOnceToken, ^{
        NSString *crxZipPath = [[NSBundle mainBundle] pathForResource:@"CAREXQImage" ofType:@"zip"];
        if (crxZipPath.length == 0) {
            return;
        }

        NSString *crxDestinationPath = [self crx_extractedRootPath];
        NSString *crxMarkerPath = [crxDestinationPath stringByAppendingPathComponent:@".carexq_unzip_done"];
        NSFileManager *crxFileManager = NSFileManager.defaultManager;

        if ([crxFileManager fileExistsAtPath:crxMarkerPath]) {
            return;
        }

        NSError *crxDirectoryError = nil;
        [crxFileManager createDirectoryAtPath:crxDestinationPath
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&crxDirectoryError];
        if (crxDirectoryError != nil) {
            return;
        }

        NSError *crxUnzipError = nil;
        BOOL crxDidUnzip = [SSZipArchive unzipFileAtPath:crxZipPath
                                          toDestination:crxDestinationPath
                                              overwrite:YES
                                               password:@"111111"
                                                  error:&crxUnzipError];
        if (!crxDidUnzip || crxUnzipError != nil) {
            return;
        }

        [@"ok" writeToFile:crxMarkerPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
}

+ (NSString *)crx_extractedRootPath {
    NSArray<NSString *> *crxCachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *crxBasePath = crxCachePaths.firstObject ?: NSTemporaryDirectory();
    return [crxBasePath stringByAppendingPathComponent:@"CAREXQImage"];
}

+ (UIImage *)crx_imageFromExtractedDirectory:(NSString *)imageName {
    NSString *crxNameWithoutExtension = imageName.stringByDeletingPathExtension;
    NSString *crxExtension = imageName.pathExtension.lowercaseString;

    NSArray<NSString *> *crxExtensions = crxExtension.length > 0 ? @[crxExtension] : @[@"png", @"jpg", @"jpeg", @"webp", @"gif", @"heic"];
    NSArray<NSString *> *crxDirectories = @[
        [[self crx_extractedRootPath] stringByAppendingPathComponent:@"CoreImage"],
        [[self crx_extractedRootPath] stringByAppendingPathComponent:@"CarmieRes"]
    ];

    NSMutableArray<NSString *> *crxCandidateNames = [NSMutableArray array];
    BOOL crxHasScaleSuffix = [crxNameWithoutExtension hasSuffix:@"@2x"] || [crxNameWithoutExtension hasSuffix:@"@3x"];
    if (crxHasScaleSuffix) {
        [crxCandidateNames addObject:crxNameWithoutExtension];
    } else {
        CGFloat crxScreenScale = UIScreen.mainScreen.scale;
        if (crxScreenScale >= 3.0) {
            [crxCandidateNames addObjectsFromArray:@[
                [crxNameWithoutExtension stringByAppendingString:@"@3x"],
                [crxNameWithoutExtension stringByAppendingString:@"@2x"],
                crxNameWithoutExtension
            ]];
        } else {
            [crxCandidateNames addObjectsFromArray:@[
                [crxNameWithoutExtension stringByAppendingString:@"@2x"],
                [crxNameWithoutExtension stringByAppendingString:@"@3x"],
                crxNameWithoutExtension
            ]];
        }
    }

    for (NSString *crxDirectoryPath in crxDirectories) {
        for (NSString *crxCandidateName in crxCandidateNames) {
            for (NSString *crxCandidateExtension in crxExtensions) {
                NSString *crxFileName = [NSString stringWithFormat:@"%@.%@", crxCandidateName, crxCandidateExtension];
                NSString *crxFilePath = [crxDirectoryPath stringByAppendingPathComponent:crxFileName];
                if (![NSFileManager.defaultManager fileExistsAtPath:crxFilePath]) {
                    continue;
                }

                NSData *crxImageData = [NSData dataWithContentsOfFile:crxFilePath];
                if (crxImageData.length == 0) {
                    continue;
                }

                CGFloat crxScale = 1.0;
                if ([crxCandidateName hasSuffix:@"@3x"]) {
                    crxScale = 3.0;
                } else if ([crxCandidateName hasSuffix:@"@2x"]) {
                    crxScale = 2.0;
                }

                UIImage *crxImage = [UIImage imageWithData:crxImageData scale:crxScale];
                if (crxImage != nil) {
                    return crxImage;
                }
            }
        }
    }

    return nil;
}

@end
