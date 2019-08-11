//
//  filterView.m
//  视频功能开发
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 cc. All rights reserved.
//

#import "filterView.h"

@interface filterView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* filterTitles;

@end

@implementation filterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.filterTitles = @[@"原图",@"素描",@"美颜",@"伽马线",@"反色",@"怀旧",@"灰度",@"色彩直方图",@"RGB颜色",@"单色",@"边缘检测1",@"边缘检测2",@"漫画",@"监控"];
        [self addSubview:self.collectionView];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.filterTitles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    UILabel* label = [[UILabel alloc]initWithFrame:cell.bounds];
    cell.backgroundColor = [UIColor redColor];
    [cell addSubview:label];
    label.text = self.filterTitles[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.frame.size.width/2 - 2, self.frame.size.width/2 - 2);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.collectionViewLayout = layout;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


@end
