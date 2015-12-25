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

#define PHOTO_COLUMN_COUNT 4
#define PHOTO_ITEM_SPACING 8
#define PHOTO_WIDTH ((SCREEN_WIDTH) - ((PHOTO_COLUMN_COUNT) + 1) * (PHOTO_ITEM_SPACING)) / PHOTO_COLUMN_COUNT

static UIEdgeInsets const PHOTO_INSET = {8,8,8,8};




@interface TakePhotoController () <MWPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//model
@property (strong, nonatomic) NSMutableArray *photos;

//local album
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@property (nonatomic, strong) MWPhotoBrowser *browserForNetworkImage;
@property (nonatomic, strong) MWPhotoBrowser *browserForLocalAlbum;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation TakePhotoController

static NSString * const reuseIdentifier = @"TakePhotoCollectionCell";


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
    
    [self loadAssets];
}


#pragma mark - Load Assets

- (void)loadAssets {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    NSString *title = NSLocalizedString(@"CatchingPhotoFromAlbum", @"正在获取图片");
    hud.labelText = title;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.dimBackground = YES;
    self.hud = hud;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    
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
        }else {
            [self.hud hide:YES];
        }
    }else {
        // 获取当前应用对照片的访问授权状态
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
            [self showAuthorizationErronMsg];
        }else {
            [self performLoadAssets];
        }
    }
}


- (void)performLoadAssets {
    _assets = [NSMutableArray new];

    if (NSClassFromString(@"PHAsset")) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_assets addObject:obj];
                NSLog(@"%zd",_assets.count);
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
            });
        });
    }else {
        
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
 

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
 
            void (^assetEnumerator)(ALAsset *,NSUInteger, BOOL *) = ^(ALAsset *result,NSUInteger index,BOOL *stop){
                
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                            if (asset) {
                                 @synchronized(_assets) {
                                    [_assets addObject:asset];
//                                    if (self.browserForLocalAlbum)
//                                        [self.browserForLocalAlbum performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                 }
                            }

                        } failureBlock:^(NSError *error) {
                             NSLog(@"operation was not successfull!");
                        }];
                    }
                }
            };
            
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.hud hide:YES];
                    });
                }
            };
            
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
                NSLog(@"There is an error");
            }];
            
        });
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell

    if(indexPath.row < self.photos.count) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[indexPath.row]]];
    }else {
        cell.imageView.image = self.selectedImage;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == self.photos.count) {
        NSString *title = NSLocalizedString(@"Select Photos", @"选择图片");
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
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
        self.browserForNetworkImage = browser;
        browser.delegate = self;
        browser.displayActionButton = NO;
        browser.displayNavArrows = YES;
        browser.alwaysShowControls = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = NO;
        browser.displaySelectionButtons = NO;
        browser.startOnGrid = NO;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        [browser setCurrentPhotoIndex:indexPath.row];
        
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"collectionView performAction");
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if(photoBrowser == self.browserForNetworkImage) {
        
        return self.photos.count;
    }else {
//        @synchronized(_assets) {
            return self.assets.count;
//        }
    }
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (photoBrowser == self.browserForNetworkImage) {
        if (index < _photos.count) {
            NSURL *url = [NSURL URLWithString:self.photos[index]];
            MWPhoto *photo = [MWPhoto photoWithURL:url];
            return photo;
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
            NSURL *url = [NSURL URLWithString:self.photos[index]];
            MWPhoto *photo = [MWPhoto photoWithURL:url];
            return photo;
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

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    
    if (selected) {
        if (NSClassFromString(@"PHAsset")) {
            PHAsset *asset = self.assets[index];
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            [imageManager requestImageForAsset:asset
                                    targetSize:CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH)
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     
                                     self.selectedImage = result;
                                     [self.collectionView reloadData];
                                     
                                 }];
        }else {
            ALAsset *asset = self.assets[index];
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            self.selectedImage = image;
            [self.collectionView reloadData];
        }
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
            [self showAlbumContentNow];
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
            [self showAlbumContentNow];
        }
    }
    
}

- (void)showAuthorizationErronMsg
{
    MBProgressHUD *alert = [[MBProgressHUD alloc] initWithView:self.collectionView];
    [self.collectionView addSubview:alert];
    NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
    alert.mode = MBProgressHUDModeText;
    alert.labelText = tipTextWhenNoPhotosAuthorization;
    alert.labelFont = [UIFont systemFontOfSize:10];
    [alert show:YES];
    [alert hide:YES afterDelay:1.5];
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
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    browser.displaySelectionButtons = YES;
    browser.startOnGrid = YES;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
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
        self.selectedImage = image;
        [self.collectionView reloadData];
    } 
    
}

#pragma  mark - lazy load

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray new];
        [_photos addObject:@"http://img2.3lian.com/img2007/19/33/005.jpg"];
        [_photos addObject:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
        [_photos addObject:@"http://img2.3lian.com/img2007/19/33/005.jpg"];
        [_photos addObject:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
        [_photos addObject:@"http://img2.3lian.com/img2007/19/33/005.jpg"];
        [_photos addObject:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
    }
    return _photos;
}

@end
