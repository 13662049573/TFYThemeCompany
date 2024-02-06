//
//  TFYThemeOneController.m
//  TFYThemeCompany
//
//  Created by 田风有 on 2024/2/5.
//

#import "TFYThemeOneController.h"
#import "TFYThemeThreeController.h"
#import "TFYThemeOneCell.h"

@interface TFYThemeOneController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (copy, nonatomic)NSArray<ThemeModel *> *dataArr;
@property (nonatomic , strong)UICollectionView *collectionView;
@end

@implementation TFYThemeOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.makeChain
    .delegate(self)
    .dataSource(self)
    .showsVerticalScrollIndicator(NO)
    .backgroundColor(UIColor.clearColor)
    .registerCellClass(TFYThemeOneCell.class, @"TFYThemeOneCell")
    .addToSuperView(self.view)
    .makeMasonry(^(MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(self.view).offset(0);
    });
    
    [self loadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(TFY_Width_W()/2-15, TFY_Width_W()/2+110);
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0,TFY_kBottomBarHeight(), 0);
    }
    return _collectionView;
}

- (void)loadData {
    
    NSDictionary *dict = [NSDictionary tfy_pathForResource:@"skineTheme" ofType:@"json"];
    
    ThemeitemsModel *data = [ThemeitemsModel yy_modelWithDictionary:dict];
    
    self.dataArr = data.items;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TFYThemeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TFYThemeOneCell" forIndexPath:indexPath];
    
    ThemeModel *model = self.dataArr[indexPath.row];
    
    cell.data = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TFYThemeThreeController *vc = TFYThemeThreeController.new;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
