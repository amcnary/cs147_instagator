//
//  SelectImageViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/19/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol SelectImageViewControllerDelegate {
    func selectImageViewController(selectImageViewController: SelectImageViewController, imageSelected: UIImage)
}

class SelectImageViewController: UICollectionViewController {
    
    // MARK: constants
    
    private static let images = [
        UIImage(named: "Amanda"),
        UIImage(named: "CanadaImage"),
        UIImage(named: "Hiking"),
        UIImage(named: "Moose"),
        UIImage(named: "Mountains"),
        UIImage(named: "Tanner")
    ]

    var delegate: SelectImageViewControllerDelegate?
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SelectImageCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? SelectImageCollectionViewCell {
                
                cell.imageView.image = SelectImageViewController.images[indexPath.item]
                return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SelectImageViewController.images.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let image = SelectImageViewController.images[indexPath.item] {
            delegate?.selectImageViewController(self, imageSelected: image)
        }
    }
}