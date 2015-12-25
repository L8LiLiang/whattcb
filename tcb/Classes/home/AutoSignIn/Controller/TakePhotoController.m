//
//  TakePhotoController.m
//  tcb
//
//  Created by Chuanxun on 15/11/25.
//  Copyright © 2015年 Jax. All rights reserved.
//


#import "TakePhotoController.h"
#import "TakePhotoCell.h"
#import <UIImageView+WebCache.h>
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import <UIButton+WebCache.h>
#import "ELPhoto.h"
#import "ELDispatchOrder.h"
#import "GTMBase64.h"
#import "ServiceURLConstant.h"



static UIEdgeInsets const PHOTO_INSET = {8,8,8,8};




@interface TakePhotoController () <MWPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TakePhotoCellDelegate>

//model
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *smallPhotos;

//local album
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableDictionary *assetToSelectDict;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@property (nonatomic, strong) MWPhotoBrowser *browserForNetworkImage;
@property (nonatomic, strong) MWPhotoBrowser *browserForLocalAlbum;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (strong, nonatomic) ELDispatchOrderItem *item;

@property (strong, nonatomic) ELPhoto *photoForAddButton;

@property (strong, nonatomic) dispatch_queue_t queueForDataProcess;

@property (assign, nonatomic) BOOL albumHasLoaded;

@end

@implementation TakePhotoController

static NSString * const reuseIdentifier = @"TakePhotoCollectionCell";


-(instancetype)initWithPhotoUrls:(NSArray *)urls smallPhotoUrls:(NSArray *)smallPhotoUrls dispOrderItem:(ELDispatchOrderItem *)item
{
    self = [self init];
    for (int i = 0; i < urls.count; i++) {
        NSString *pId = urls[i];
        NSString *urlStr = [IMAGE_URL stringByAppendingPathComponent:pId];
        NSURL *url = [NSURL URLWithString:urlStr];
        ELPhoto *photo = [[ELPhoto alloc] initWithUrl:url photoId:pId synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
        [self.photos addObject:photo];
    }
    for (int i = 0; i < smallPhotoUrls.count; i++) {
        NSString *pId = urls[i];
        NSString *urlStr = [IMAGE_URL stringByAppendingPathComponent:pId];
        NSURL *url = [NSURL URLWithString:urlStr];
        ELPhoto *photo = [[ELPhoto alloc] initWithUrl:url photoId:pId synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
        [self.smallPhotos addObject:photo];
    }
    self.item = item;
    
    self.photoForAddButton = [[ELPhoto alloc] initWithUrl:nil photoId:nil synchronizedWithServer:NO status:PHOTO_STATUS_NORMAL];
    self.photoForAddButton.photoID = @"-1";//表示特殊用途
    
    self.queueForDataProcess = dispatch_queue_create("Queue_For_Photo_Data_Process", DISPATCH_QUEUE_SERIAL);
    
    return self;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = (SCREEN_WIDTH - (PHOTO_COLUMN_COUNT + 1) * PHOTO_ITEM_SPACING) / PHOTO_COLUMN_COUNT;
    flowLayout.minimumInteritemSpacing = PHOTO_ITEM_SPACING;
    flowLayout.minimumLineSpacing = PHOTO_ITEM_SPACING;
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.headerReferenceSize = CGSizeMake(0, 8);
    flowLayout.sectionInset = PHOTO_INSET;
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    self.albumHasLoaded = NO;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[TakePhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TakePhotoCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    NSString *title = NSLocalizedString(@"Photos", @"监装拍照");
    self.navigationItem.title = title;

    title = NSLocalizedString(@"SyncPhotos", @"同步图片");
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(syncPhotoToServer:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

static void *ProgressObserverContext = &ProgressObserverContext;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == ProgressObserverContext) {
        NSProgress *progress = object;
        self.hud.labelText = progress.localizedAdditionalDescription;
        if (progress.fractionCompleted == 1.0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progress removeObserver:self forKeyPath:@"fractionCompleted"];
                [self.hud hide:YES];
            });
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Load Assets

- (void)loadAssets {
    
    //只加载一次
    if (self.albumHasLoaded) {
        [self showAlbumContentNow];
        return;
    }
    
    self.albumHasLoaded = YES;
    
    if (NSClassFromString(@"PHAsset")) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        }else if (status == PHAuthorizationStatusAuthorized)
        {
            [self performLoadAssets];
        }
    }else {
        // 获取当前应用对照片的访问授权状态
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
            [self showAuthorizationErronMsg];
        }else if(authorizationStatus == ALAuthorizationStatusAuthorized){
            [self performLoadAssets];
        }
    }
}

- (NSNumber *)indexNumberWithAsset:(id)asset
{
    return [NSNumber numberWithInteger:[_assets indexOfObject:asset]];
}

- (void)performLoadAssets {
    
    NSString *title = NSLocalizedString(@"CatchingPhotoFromAlbum", @"正在获取图片");
    [SVProgressHUD showWithStatus:title maskType:SVProgressHUDMaskTypeGradient];
    
    _assets = [NSMutableArray new];

    if (NSClassFromString(@"PHAsset")) {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_assets addObject:obj];
                static int i = 0;
                NSLog(@"%d",i++);
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                for (PHAsset* asset in _assets) {
                    [self.assetToSelectDict setObject:@0 forKey:[self indexNumberWithAsset:asset]];
                }
                [self showAlbumContentNow];
                [SVProgressHUD dismiss];
            });
        //});
    }else {
        
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        __block NSInteger assetCount = 0;
        __block NSInteger processedAssetCount = 0;
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
 
            void (^assetEnumerator)(ALAsset *,NSUInteger, BOOL *) = ^(ALAsset *result,NSUInteger index,BOOL *stop){
                
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                            @synchronized(self) {
                                processedAssetCount++;
                            }
                            if (asset) {
                                 @synchronized(_assets) {
                                    [_assets addObject:asset];
                                 }
                                if (processedAssetCount >= assetCount) {
                                    [queue cancelAllOperations];
                                    *stop = YES;
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        for (ALAsset *asset in _assets) {
                                            [self.assetToSelectDict setObject:@0 forKey:[self indexNumberWithAsset:asset]];

                                        }
                                        [self showAlbumContentNow];
                                        [SVProgressHUD dismiss];
                                    });
                                }
                            }

                        } failureBlock:^(NSError *error) {
                             NSLog(@"operation was not successfull!");
                        }];
                    }else {
                        @synchronized(self) {
                            processedAssetCount++;
                        }
                    }
                }
//                else {
//                    @synchronized(self) {
//                        processedAssetCount++;
//                    }
//                }
            };
            
            
            //用于在获取所有asset之后，再showAlbumContentNow
            __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [queue addOperationWithBlock:^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }];
            
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [queue addOperationWithBlock:^{
                        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    }];
                    assetCount += group.numberOfAssets;
                }else {
                    dispatch_semaphore_signal(semaphore);
                }
            };
            
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
                NSLog(@"There is an error");
            }];
        //});
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.smallPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if(indexPath.row < self.smallPhotos.count) {
        
        cell.photo = self.smallPhotos[indexPath.row];
    }else {
        cell.photo = self.photoForAddButton;
    }
    
    return cell;
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if(photoBrowser == self.browserForNetworkImage) {
        
        return self.smallPhotos.count;
    }else {
        @synchronized(_assets) {
            NSLog(@"numberOfPhotosInPhotoBrowser %zd",self.assets.count);
            return self.assets.count;
        }
    }
        
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (photoBrowser == self.browserForNetworkImage) {
        if (index < _photos.count) {
            ELPhoto *photo = self.photos[index];
            MWPhoto *mwPhoto;
            if (photo.photoUrl) {
                mwPhoto = [MWPhoto photoWithURL:photo.photoUrl];
            }else{
                UIImage *image = [photo bigImage];
                mwPhoto = [MWPhoto photoWithImage:image];
            }
            return mwPhoto;
        }
        return nil;
    }else {
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
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (photoBrowser == self.browserForNetworkImage) {
        if (index < _photos.count) {
            ELPhoto *photo = self.smallPhotos[index];
            MWPhoto *mwPhoto;
            if (photo.photoUrl) {
                mwPhoto = [MWPhoto photoWithURL:photo.photoUrl];
            }else{
                UIImage *image = [photo thumbnail];
                mwPhoto = [MWPhoto photoWithImage:image];
            }
            return mwPhoto;
        }
        return nil;
    }else {
        @synchronized(_assets) {
            if (index < self.assets.count) {
                if (NSClassFromString(@"PHAsset")) {
                    // Photos library
                    UIScreen *screen = [UIScreen mainScreen];
                    CGFloat scale = screen.scale;
                    // Sizing is very rough... more thought required in a real implementation
                    CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
                    CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
                    PHAsset *asset = self.assets[index];
                    return [MWPhoto photoWithAsset:asset targetSize:thumbTargetSize];
                } else {
                    // Assets library
                    ALAsset *asset = self.assets[index];
                    MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]];
                    return photo;
                }
            }
            return nil;
        }
    }
}

- (void)addAlbumPhotoAtIndexToCollectionView:(NSInteger)index image:(UIImage *)image
{
    BOOL alreadyExistInPhotos = NO;
    for (NSInteger i = self.photos.count - 1; i >= 0; i--) {
        ELPhoto *photo = self.photos[i];
        if (photo.indexInAsset == index) {
            alreadyExistInPhotos = YES;
            break;
        }
    }
    
    if (!alreadyExistInPhotos) {
        ELPhoto *photo = [[ELPhoto alloc] initWithUrl:nil photoId:nil synchronizedWithServer:NO status:PHOTO_STATUS_ADD];
        photo.asset = self.assets[index];
//        photo.image = image;
        photo.selected = YES;
        photo.indexInAsset = index;
        
        ELPhoto *smallPhoto = [[ELPhoto alloc] initWithUrl:nil photoId:nil synchronizedWithServer:NO status:PHOTO_STATUS_ADD];
        //                                         smallPhoto.image = [ConfigTool compressImage:result toMaxFileSize:100 * 1024];
//        smallPhoto.image = image;
        smallPhoto.asset = self.assets[index];
        smallPhoto.selected = YES;
        smallPhoto.indexInAsset = index;
        
        [self.photos addObject:photo];
        [self.smallPhotos addObject:smallPhoto];
    }

    [self.assetToSelectDict setObject:@1 forKey:[NSNumber numberWithInteger:index]];
}

- (void)deleteAlbumPhotoAtIndexFromCollectionView:(NSInteger)index
{
    //从photos和smallPhotos中删除
    for (NSInteger i = self.photos.count - 1; i >= 0; i --) {
        ELPhoto *photo = self.photos[i];
        if (photo.indexInAsset == index) {
            [self.photos removeObjectAtIndex:i];
            [self.smallPhotos removeObjectAtIndex:i];
            break;
        }
    }
    //修改选中状态
    [self.assetToSelectDict setObject:@0 forKey:[NSNumber numberWithInteger:index]];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    
    if (photoBrowser == self.browserForNetworkImage) {
        ELPhoto *photo = self.smallPhotos[index];
        photo.selected = selected;
        photo = self.photos[index];
        photo.selected = selected;
    }else {
        if (selected) {
            if (NSClassFromString(@"PHAsset")) {
//                PHAsset *asset = self.assets[index];
//                PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
//                [imageManager requestImageForAsset:asset
//                                        targetSize:CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH)
//                                       contentMode:PHImageContentModeAspectFill
//                                           options:nil
//                                     resultHandler:^(UIImage *result, NSDictionary *info) {
//                                         
//                                         [self addAlbumPhotoAtIndexToCollectionView:index image:result];
//                                         
//                                     }];
                [self addAlbumPhotoAtIndexToCollectionView:index image:nil];
            }else {
//                ALAsset *asset = self.assets[index];
//                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
//                UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
                [self addAlbumPhotoAtIndexToCollectionView:index image:nil];
                
            }
        }else {
            [self deleteAlbumPhotoAtIndexFromCollectionView:index];
        }
    }
}

-(BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    if (photoBrowser == self.browserForNetworkImage) {
        ELPhoto *photo = self.smallPhotos[index];
        return photo.selected;
    }else {
        NSNumber *number = [self.assetToSelectDict objectForKey:[NSNumber numberWithInteger:index]];
        return number.intValue == 1;
    }

}

-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (photoBrowser == self.browserForLocalAlbum) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
    self.browserForLocalAlbum = nil;
    self.browserForNetworkImage = nil;
}

#pragma mark - TakePhotoCellDelegate

-(void)cellBackgroundBtnClicked:(TakePhotoCell *)cell
{
    ELPhoto *photo = cell.photo;
    if (![self.smallPhotos containsObject:photo]) {
        NSString *title = NSLocalizedString(@"Add Photos", @"添加图片");
        NSString *strTakePhoto = NSLocalizedString(@"TakePhoto", @"拍照");
        NSString *strSelectPhoto = NSLocalizedString(@"SelectPhotosFromAlbum", @"从相册选择");
        NSString *strCancel = NSLocalizedString(@"Cancel", @"取消");
        if (NSClassFromString(@"UIAlertController")) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *takPhoto = [UIAlertAction actionWithTitle:strTakePhoto style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [alertVC addAction:takPhoto];
            
            UIAlertAction *selectPhoto = [UIAlertAction actionWithTitle:strSelectPhoto style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showAlbum];
            }];
            [alertVC addAction:selectPhoto];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:strCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"cancel");
            }];
            [alertVC addAction:cancel];
            
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:strCancel destructiveButtonTitle:nil otherButtonTitles:strTakePhoto,strSelectPhoto, nil];
            [actionSheet showInView:self.collectionView];
        }
        
    }else {
        
        NSInteger index = [self.smallPhotos indexOfObject:photo];

        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
        self.browserForNetworkImage = browser;
        browser.delegate = self;
        browser.displayActionButton = NO;
        browser.displayNavArrows = YES;
        browser.alwaysShowControls = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.enableSwipeToDismiss = YES;
        browser.autoPlayOnAppear = NO;
        browser.displaySelectionButtons = YES;
        browser.startOnGrid = NO;
        
        //browser.customImageSelectedIconName = @"ImageSelectedOn.png";
        //browser.customImageSelectedSmallIconName = @"ImageSelectedSmallOn.png";
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        [browser setCurrentPhotoIndex:index];
        
//        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }

}


-(void)cellPhotoSelectedStatusChanged:(TakePhotoCell *)cell
{
    if (cell.photo.selected) {
        [self.assetToSelectDict setObject:@1 forKey:[NSNumber numberWithInteger:cell.photo.indexInAsset]];
    }else {
        [self.assetToSelectDict setObject:@0 forKey:[NSNumber numberWithInteger:cell.photo.indexInAsset]];
    }
}

#pragma mark - Functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self showAlbum];
            break;
        case 2:
            NSLog(@"Cancel");
            break;
        default:
            NSLog(@"default");
            break;
    }
}

- (void)showAlbum
{
    if (NSClassFromString(@"PHAsset")) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self showAlbumContentNow];
                }
            }];
        }else if (status == PHAuthorizationStatusAuthorized)
        {
            [self loadAssets];
        }else {
            [self showAuthorizationErronMsg];
        }
    }else {
        // 获取当前应用对照片的访问授权状态
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
            [self showAuthorizationErronMsg];
        }else {
            [self loadAssets];
        }
    }
    
}

- (void)showAuthorizationErronMsg
{

    NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
    [SVProgressHUD showErrorWithStatus:tipTextWhenNoPhotosAuthorization];
}

- (void)showAlbumContentNow
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
    browser.navigationItem.title = @"选择图片";
    self.browserForLocalAlbum = browser;
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
    
    //browser.customImageSelectedIconName = @"ImageSelectedOn.png";
    //browser.customImageSelectedSmallIconName = @"ImageSelectedSmallOn.png";
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    browser.displaySelectionButtons = YES;
    [browser setCurrentPhotoIndex:0];
}

- (void)takePhoto
{

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)syncPhotoToServer:(id)sender
{
    NSInteger photoNum = 0;
    for (ELPhoto *photo in self.smallPhotos) {
        if (photo.selected) {
            photoNum = photoNum + 1;
        }
    }
    
    if (photoNum == 0) {
        return;
    }
    
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:photoNum];
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:ProgressObserverContext];
    
    MBProgressHUD *progressInfo = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:progressInfo];
    progressInfo.dimBackground = YES;
    progressInfo.mode = MBProgressHUDModeIndeterminate;
    progressInfo.labelText = progress.localizedAdditionalDescription;
    progressInfo.labelFont = [UIFont systemFontOfSize:14];
    progressInfo.removeFromSuperViewOnHide = YES;
    self.hud = progressInfo;
    [progressInfo show:YES];
    
    
    dispatch_async(self.queueForDataProcess, ^{
        for (ELPhoto *photo in self.smallPhotos) {
            if (photo.selected && !photo.synchronizedWithServer) {
                [self addPhoto:photo progress:progress];
            }else if(photo.selected && photo.synchronizedWithServer) {
                [self deletePhoto:photo progress:progress];
            }
        }
    });
}

- (void)deletePhotosWithProgress:(NSProgress *)progress
{
    for (ELPhoto *photo in self.smallPhotos) {
        if (photo.selected && photo.synchronizedWithServer) {
            [self deletePhoto:photo progress:progress];
        }
    }
}

- (void)deletePhoto:(ELPhoto *)photo progress:(NSProgress *)progress
{
//    NSURL *url = photo.photoUrl;
    NSString *imageId = photo.photoID;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"cmd":@"DeleteDispatchOrderImage",
                                                                                 @"data":@{@"dispCode":self.item.DispCode,@"imageId":imageId}}];
    [APIClientTool deleteDispatchOrderImageWithParam:param success:^(NSDictionary *dict) {
        dispatch_async(self.queueForDataProcess, ^{
            NSInteger index = [self.smallPhotos indexOfObject:photo];
            [self.photos removeObjectAtIndex:index];
            [self.smallPhotos removeObjectAtIndex:index];
            
            NSInteger assetIndex = photo.indexInAsset;
            if (assetIndex != -1) {
                [self.assetToSelectDict setObject:@0 forKey:[NSNumber numberWithInteger:assetIndex]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
        progress.completedUnitCount++;

    } failed:^{
        progress.completedUnitCount++;
    }];
    
}

- (void)addAllPhotosWihtProgress:(NSProgress *)progress
{
    for (ELPhoto *photo in self.smallPhotos) {
        if (photo.selected && !photo.synchronizedWithServer) {
            [self addPhoto:photo progress:progress];
        }
    }
}

- (void)addPhoto:(ELPhoto *)photo progress:(NSProgress *)progress
{
    
    UIImage *image = [photo bigImage];
    
    UIImage *thumImage = [ConfigTool compressImage:image toMaxFileSize:100 * 1024];
//    image = nil;
    NSData *data = UIImageJPEGRepresentation(thumImage, 1);
    NSString *strData = [data base64EncodedStringWithOptions:0];
    //    NSString *strData = [GTMBase64 stringByEncodingData:data];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"cmd":@"UploadPicBase64",@"data":@{@"data":strData}}];
    [APIClientTool uploadImageWithParam:dict success:^(NSDictionary *dict) {
        NSString *path = [dict valueForKey:@"data"];
        photo.photoID = path;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"cmd":@"SaveDispatchOrderImage",
                                                                                     @"data":@{@"dispCode":self.item.DispCode,@"imageId":path}}];
        [APIClientTool saveDispatchOrderImageWithParam:param success:^(NSDictionary *dict) {
            photo.synchronizedWithServer = YES;
            photo.selected = NO;
            NSInteger index = [self.smallPhotos indexOfObject:photo];
            ELPhoto *bigPhoto = self.photos[index];
            bigPhoto.synchronizedWithServer = YES;
            bigPhoto.selected = NO;
            
            NSInteger assetIndex = photo.indexInAsset;
            if (assetIndex != -1) {
                [self.assetToSelectDict setObject:@0 forKey:[NSNumber numberWithInteger:assetIndex]];
            }
            
            
            progress.completedUnitCount++;
        } failed:^{
            progress.completedUnitCount++;
        }];
        
    } failed:^{
        progress.completedUnitCount++;
    }];
}



#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil)
//        {
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(image);
//        }
        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        ELPhoto *photo = [[ELPhoto alloc] initWithUrl:nil photoId:nil synchronizedWithServer:NO status:PHOTO_STATUS_ADD];
        photo.image = image;
        photo.selected = YES;
        ELPhoto *smallPhoto = [[ELPhoto alloc] initWithUrl:nil photoId:nil synchronizedWithServer:NO status:PHOTO_STATUS_ADD];
        smallPhoto.image = [ConfigTool compressImage:image toMaxFileSize:100 * 1024];
        smallPhoto.selected = YES;
        [self.photos addObject:photo];
        [self.smallPhotos addObject:smallPhoto];
        
        [self.collectionView reloadData];
    } 
    
}

#pragma  mark - lazy load

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray new];
//        NSURL *url1 = [NSURL URLWithString:@"http://img2.3lian.com/img2007/19/33/005.jpg"];
//        NSURL *url2 = [NSURL URLWithString:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
//
//        ELPhoto *photo1 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo1];
//        ELPhoto *photo2 = [[ELPhoto alloc] initWithUrl:url2 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo2];
//        ELPhoto *photo3 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo3];
//        ELPhoto *photo4 = [[ELPhoto alloc] initWithUrl:url2 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo4];
//        ELPhoto *photo5 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo5];
//        ELPhoto *photo6 = [[ELPhoto alloc] initWithUrl:url2 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo6];
//        ELPhoto *photo7 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo7];
//        ELPhoto *photo8 = [[ELPhoto alloc] initWithUrl:url2 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo8];
//        ELPhoto *photo9 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo9];
//        ELPhoto *photo10 = [[ELPhoto alloc] initWithUrl:url2 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo10];
//        ELPhoto *photo11 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo11];
//        ELPhoto *photo12 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo12];
//        ELPhoto *photo13 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo13];
//        ELPhoto *photo14 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo14];
//        ELPhoto *photo15 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo15];
//        ELPhoto *photo16 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo16];
//        ELPhoto *photo17 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo17];
//        ELPhoto *photo18 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo18];
//        ELPhoto *photo19 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo19];
//        ELPhoto *photo20 = [[ELPhoto alloc] initWithUrl:url1 synchronizedWithServer:YES status:PHOTO_STATUS_NORMAL];
//        [_photos addObject:photo20];

    }
    return _photos;
}
-(NSMutableArray *)smallPhotos
{
    if (!_smallPhotos) {
        _smallPhotos = [NSMutableArray new];
    }
    return _smallPhotos;
}

-(NSMutableDictionary *)assetToSelectDict
{
    if (!_assetToSelectDict) {
        _assetToSelectDict = [NSMutableDictionary new];
    }
    return _assetToSelectDict;
}

@end
