//
//  MMTagCollectionViewLayout.swift
//  MMTagView
//
//  Created by 马扬 on 2020/4/14.
//  Copyright © 2020 mayang. All rights reserved.
//

import UIKit

public class MMTagCollectionViewLayout: UICollectionViewFlowLayout {

    fileprivate var lastAttr : UICollectionViewLayoutAttributes?
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollDirection = .vertical
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        for x in attrs ?? [] {
            if x.representedElementKind == nil {
                x.frame = self.layoutAttributesForItem(at: x.indexPath)?.frame ?? x.frame
            }
        }
        return attrs
    }

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let att = super.layoutAttributesForItem(at: indexPath)
        if att?.indexPath.item == 0{ /** 如果是0直接返回 */
            var frame = att?.frame
            frame?.origin.x = self.sectionInset.left
            if (frame?.size.width ?? 0) > (self.collectionView?.frame.size.width ?? 0) -  self.sectionInset.left - self.sectionInset.right{
                frame?.size.width = (self.collectionView?.frame.size.width ?? 0) -  self.sectionInset.left - self.sectionInset.right
            }
            att?.frame = frame ?? .zero
            self.lastAttr = att
            return att
        }
        let lastCenter = self.lastAttr?.center ?? .zero
        if att?.center.y == lastCenter.y{ /** 在同一行 */
            var frame = att?.frame ?? .zero
            frame.origin.x = (self.lastAttr?.frame.origin.x ?? 0.0) + (self.lastAttr?.frame.size.width  ?? 0.0) + self.minimumInteritemSpacing
            if frame.size.width > (self.collectionView?.frame.size.width ?? 0) -  self.sectionInset.left - self.sectionInset.right{
                frame.size.width = (self.collectionView?.frame.size.width ?? 0) -  self.sectionInset.left - self.sectionInset.right
            }
            att?.frame = frame
            self.lastAttr = att
            return att
        }
        var frame = att?.frame ?? .zero
        frame.origin.x = self.sectionInset.left
        if frame.size.width > (self.collectionView?.frame.size.width ?? 0) -  self.sectionInset.left - self.sectionInset.right{
            frame.size.width = (self.collectionView?.frame.size.width ?? 0) -  self.sectionInset.left - self.sectionInset.right
        }
        att?.frame = frame
        self.lastAttr = att
        return att
    }
}
