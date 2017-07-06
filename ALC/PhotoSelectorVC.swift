//
//  PhotoSelectorVC.swift
//  ALC
//
//  Created by Chibi Anward on 2017-07-06.
//  Copyright © 2017 chibi.anward. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let headerCellID = "headerCellID"
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]() // 2. capture all the assets inside this array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        setupNavigationButtons()
        registerCell()
        fetchLibraryPhotos()
    }
    
    //MARK:
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleNext() {
        print("next")
        let sharePhotoController = SharePhotoController()
        //set selectedImage in sharePhotoController to the header photoHeaderImage
        sharePhotoController.selectedImage = header?.photoHeaderImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
        
        
        
    }
    
    //MARK:
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 28
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchLibraryPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        // prevent lagging
        DispatchQueue.global(qos: .background) .async {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                print(count)
                
                let imageManager = PHImageManager.default()
                // 1. Low image quality to reduce loading time
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image {
                        self.images.append(image) //reference from images array
                        self.assets.append(asset) // 3. using the assets array
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    //only reload when i'm don't fetching photos
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }// needs to get back to the main thread if using background
                    }
                    
                })
            })
            
        } //end Dispatch
        
    }
    
    //MARK:
    fileprivate func registerCell() {
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    // Add a holder reference for the header so we get access to the image. Then add self.header = header
    var header: PhotoSelectorHeaderCell?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! PhotoSelectorHeaderCell
        
        self.header = header
        
        header.photoHeaderImageView.image = selectedImage
        
        // Get the selected image
        if let selectedImage = selectedImage {
            // get rid of the int
            if let index = self.images.index(of: selectedImage) {
                let selectedAsset = self.assets[index]
                
                // 3. and then perform another request to get a lager image for the header
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 500, height: 500)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    
                    header.photoHeaderImageView.image = image
                })
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
}

// = = =
class PhotoSelectorHeaderCell: BaseCollectionCell {
    let photoHeaderImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    override func setupViews() {
        super.setupViews()
        //backgroundColor = UIColor.white
        addSubview(photoHeaderImageView)
        photoHeaderImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

// = = =
class PhotoSelectorCell: BaseCollectionCell {
    
    let photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
