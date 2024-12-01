//
//  TransformationsCollectionViewCell.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import UIKit

class TransformationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var transformationImage: AsyncImageView!
    @IBOutlet weak var transformationName: UILabel!
    static let reuseIdentifier = "TransformationsCollectionViewCell"
    static var nib: UINib { UINib(nibName: "TransformationsCollectionViewCell", bundle: Bundle(for: TransformationsCollectionViewCell.self)) }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setImage(_ characterPhoto: String) {
        self.transformationImage.setImage(characterPhoto)
    }
    
    func setName (_ name: String) {
        self.transformationName.text = name
    }
}
