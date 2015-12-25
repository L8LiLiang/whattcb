//
//  SelectedImgFromAlbumController.m
//  tcb
//
//  Created by Jax on 15/11/30.
//  Copyright © 2015年 Jax. All rights reserved.
//

#import "SelectedImgFromAlbumController.h"
#import "SelectePhotoCell.h"
#import "UIBarButtonItem+Extension.h"
#import "MWPhotoBrowser.h"
/* AssetsLibrary早期用于图片操作，但是比较坑,出现各种警告，并且在iOS9彻底废弃 */
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
/* 于是ios8.0开始，就有了Photos */
#import <Photos/Photos.h>
#import "MyPhoto.h"
#import "GTMBase64.h"
#import "UpLoadImageResultModel.h"



#define kNumOfColumn 4
#define kItemSpace 3
#define kPhotoWidth ((SCREEN_WIDTH - ((kNumOfColumn + 1) * kItemSpace)) / kNumOfColumn)


@interface SelectedImgFromAlbumController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MWPhotoBrowserDelegate, SelectePhotoCellDelegate>

@property (nonatomic, strong) NSMutableArray   *assets;
@property (nonatomic, strong) NSMutableArray   *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ALAssetsLibrary  *ALAssetsLibrary;
@property (nonatomic, strong) MWPhotoBrowser   *MWBrowserForLocalAlbum;

@property (nonatomic, strong) UIImage          *selectedImage;
@property (nonatomic, strong) MyPhoto          *selectedPhoto;
@property (nonatomic, strong) NSMutableArray<MyPhoto *> *selectPhotoArray;

@property (nonatomic, strong) UIButton *finishButton;

@end

@implementation SelectedImgFromAlbumController

#pragma mark - 懒加载
- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor              = [UIColor whiteColor];
    self.title                             = @"所有照片";

//    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithImageName:@"" target:self action:@selector(back:) title:@"返回" titleColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"" target:self action:@selector(cancel:) title:@"取消" titleColor:[UIColor blackColor]];

    [self setUpCollectionView];
    [self setUpBottomView];

    /* 获取所有照片 */
    [self loadAllphotos];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing          = kItemSpace;
    flowLayout.minimumInteritemSpacing     = kItemSpace;
    flowLayout.itemSize                    = CGSizeMake(kPhotoWidth, kPhotoWidth + 15);
    flowLayout.sectionInset                = UIEdgeInsetsMake(kItemSpace, kItemSpace, kItemSpace, kItemSpace);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView                    = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor    = [UIColor whiteColor];
    self.collectionView.delegate           = self;
    self.collectionView.dataSource         = self;
    [self.collectionView registerClass:[SelectePhotoCell class] forCellWithReuseIdentifier:@"SelectePhotoCell"];
    [self.view addSubview:self.collectionView];
}

- (void)setUpBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.bottom).offset(0);
        make.left.right.bottom.equalTo(0);
    }];
    
    UIButton *finishButton = [[UIButton alloc] init];
    [bottomView addSubview:finishButton];
    [finishButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(0);
        make.width.equalTo(80);
    }];
    self.finishButton = finishButton;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:kDefaultBarButtonItemColor forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    finishButton.enabled = NO;
    [finishButton addTarget:self action:@selector(finishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finishButtonClicked:(UIButton *)sender {
    UIImage *compressImage = [ConfigTool compressImage:self.selectedImage toMaxFileSize:100 * 1024];
    NSData *imageData = UIImagePNGRepresentation(compressImage);
    NSString *imageBase64Data = [GTMBase64 stringByEncodingData:imageData];
    
    //  上传图片
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"UploadPicBase64" forKey:@"cmd"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:imageBase64Data forKey:@"data"];
    [param setValue:data forKey:@"data"];
    
    [APIClientTool uploadImageWithParam:param success:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        UpLoadImageResultModel *upLoadImageResultModel = [UpLoadImageResultModel mj_objectWithKeyValues:dict];
        if (upLoadImageResultModel.ret == 0) {
            self.passValue(@"已上传照片");
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
    } failed:^{
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];

}

//- (void)back:(UIBarButtonItem *)sender {
//    
//}

- (void)cancel:(UIBarButtonItem *)sender {
  [self dismissViewControllerAnimated:YES completion:^{
      
  }];
}

#pragma mark - 获取所有照片
- (void)loadAllphotos {
    //  判断状态
    if (NSClassFromString(@"PHAsset")) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self getAllPhotos];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self getAllPhotos];
        }
    } else {
        [self getAllPhotos];
    }
    
}

- (void)getAllPhotos {
    if (NSClassFromString(@"PHAsset")) {
        /*  Photos >= 8.0 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 检索照片实体选项 配合PHAsset, PHCollection, PHAssetCollection, and PHCollectionList classes方法使用*/
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            /* Supported Keys : creationDate 更多见文档*/
            options.sortDescriptors = @[
                                        [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]
                                        ];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:options];
            [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.assets addObject:obj];
            }];

            if (fetchResult.count > 0) {
                
                if (NSClassFromString(@"PHAsset")) {
                    PHCachingImageManager *imageManger = [[PHCachingImageManager alloc] init];
                    [self.assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [imageManger requestImageForAsset:obj targetSize:CGSizeMake(kPhotoWidth, kPhotoWidth) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                            MyPhoto *myPhoto = [[MyPhoto alloc] initWithMyPhotoWithImage:result myPhotoStatusType:MyPhotoStatusTypeNone];
                            [self.photos addObject:myPhoto];
                        }];
                    }];
                } else {
                    [self.assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        UIImage *image = [UIImage imageWithCGImage:[obj thumbnail]];
                        MyPhoto *myPhoto = [[MyPhoto alloc] initWithMyPhotoWithImage:image myPhotoStatusType:MyPhotoStatusTypeNone];
                        [self.photos addObject:myPhoto];
                    }];
                }
                [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        });
    } else {
        /* AssetsLibrary < 8.0 */
        self.ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        /* 后台异步获取图片从相册 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [NSMutableArray array];
            NSMutableArray *assetURLDictionaries = [NSMutableArray array];
            
            /* Process ALAsset:代表一个资源文件 */
            void (^ assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [self.ALAssetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                            if (asset) {
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showWithStatus:@"获取相册图片中" maskType:SVProgressHUDMaskTypeBlack];
                                });
                                @synchronized(_assets) {
                                    [self.assets addObject:asset];
                                    CGImageRef  ref = [asset thumbnail];
                                    UIImage *image = [[UIImage alloc]initWithCGImage:ref];
                                    MyPhoto *myPhoto = [[MyPhoto alloc] initWithMyPhotoWithImage:image myPhotoStatusType:MyPhotoStatusTypeNone];
                                    [self.photos addObject:myPhoto];
                                }
                                [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                });
                            }
                            
                        } failureBlock:^(NSError *error) {

                        }];
                    }
                }
            };
            
            /* Process ALAssetsGroup:每个资源文件的详细信息 */
            void (^ assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            /* Process */
            [self.ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
                
            }];
            
        });
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"self.assets.count == %zd", self.assets.count);
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectePhotoCell *selectePhotoCell = [SelectePhotoCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    selectePhotoCell.tag = indexPath.row;
    selectePhotoCell.selectePhotoCellDelegate = self;
    selectePhotoCell.backgroundColor   = [UIColor redColor];
    
    if(indexPath.row < self.photos.count) {
        selectePhotoCell.myPhoto = self.photos[indexPath.row];
    }
    
    if (NSClassFromString(@"PHAsset")) {
        PHAsset *asset = self.assets[indexPath.row];
        PHCachingImageManager *imageManger = [[PHCachingImageManager alloc] init];
        [imageManger requestImageForAsset:asset targetSize:CGSizeMake(kPhotoWidth, kPhotoWidth) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            selectePhotoCell.imgView.image = result;
        }];
    } else {
        ALAsset *asset = self.assets[indexPath.row];
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        selectePhotoCell.imgView.image = image;
    }
   
    return selectePhotoCell;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.assets.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    @synchronized(_assets) {
        if (index < self.assets.count) {
            if (NSClassFromString(@"PHAsset")) {
                // Photos library
                UIScreen *screen = [UIScreen mainScreen];
                CGFloat scale = screen.scale;
                // Sizing is very rough... more thought required in a real implementation
                CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
                CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
                PHAsset *asset = self.assets[index];
                return [MWPhoto photoWithAsset:asset targetSize:imageTargetSize];
            } else {
                // Assets library
                ALAsset *asset = self.assets[index];
                MWPhoto *photo = [MWPhoto photoWithURL:asset.defaultRepresentation.url];
                return photo;
            }
        }
        return nil;
    }

}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    MyPhoto *myphoto = self.photos[index];
    [myphoto changeStatus];
    [self.photos replaceObjectAtIndex:index withObject:myphoto];
    
    for (int i = 0; i < self.photos.count; i ++) {
        if (i != index) {
            MyPhoto *myPhoto = self.photos[i];
            if (myPhoto.myPhotoStatusType == MyPhotoStatusTypeSelected) {
                myPhoto.myPhotoStatusType = MyPhotoStatusTypeNone;
                myPhoto.selected = MyPhotoStatusTypeNone;
            }
        }
    }
    
    if (selected) {
        if (NSClassFromString(@"PHAsset")) {
            PHAsset *asset = self.assets[index];
            PHCachingImageManager *imageManger = [[PHCachingImageManager alloc] init];
            [imageManger requestImageForAsset:asset targetSize:CGSizeMake(kPhotoWidth, kPhotoWidth) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                self.selectedImage = result;
            }];
        } else {
            ALAsset *asset = self.assets[index];
            self.selectedImage = [UIImage imageWithCGImage:[asset thumbnail]];
        }
        self.finishButton.enabled = YES;
    } else {
        self.selectedImage = nil;
        self.finishButton.enabled = NO;
    }

}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    MyPhoto *myPhoto = self.photos[index];
    return myPhoto.selected;
}

#pragma mark - SelectePhotoCellDelegate
- (void)tapImageViewOnSelectePhotoCell:(SelectePhotoCell *)selectePhotoCell {

    MyPhoto *photo = selectePhotoCell.myPhoto;
    NSInteger index = [self.photos indexOfObject:photo];

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
    browser.navigationItem.title = @"选择图片";
    self.MWBrowserForLocalAlbum = browser;
    browser.delegate = self;
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = NO;
    browser.displaySelectionButtons = YES;
    browser.startOnGrid = YES;
    
    [self.navigationController pushViewController:browser animated:YES];
    [browser setCurrentPhotoIndex:index];
   
}

- (void)clickImageHandleButtonOnSelectePhotoCell:(SelectePhotoCell *)selectePhotoCell {
    
    for (int i = 0; i < self.photos.count; i ++) {
        if (i != selectePhotoCell.tag) {
            MyPhoto *myPhoto = self.photos[i];
            if (myPhoto.myPhotoStatusType == MyPhotoStatusTypeSelected) {
                myPhoto.myPhotoStatusType = MyPhotoStatusTypeNone;
                myPhoto.selected = MyPhotoStatusTypeNone;
            }
        }
    }
    
    if (selectePhotoCell.selected) {
        if (NSClassFromString(@"PHAsset")) {
            PHAsset *asset = self.assets[selectePhotoCell.tag];
            PHCachingImageManager *imageManger = [[PHCachingImageManager alloc] init];
            [imageManger requestImageForAsset:asset targetSize:CGSizeMake(kPhotoWidth, kPhotoWidth) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                self.selectedImage = result;
            }];
        } else {
            ALAsset *asset = self.assets[selectePhotoCell.tag];
            self.selectedImage = [UIImage imageWithCGImage:[asset thumbnail]];
        }
        self.finishButton.enabled = YES;
    } else {
        self.selectedImage = nil;
        self.finishButton.enabled = NO;
    }
}

@end
