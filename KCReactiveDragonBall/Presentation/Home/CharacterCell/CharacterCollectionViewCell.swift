//
//  CharacterCollectionViewCell.swift
//  iOS_Avanzado
//
//  Created by Aroa Miguel Garcia on 23/10/24.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CharacterCollectionViewCell"
    static var nib: UINib { UINib(nibName: "CharacterCollectionViewCell", bundle: Bundle(for: CharacterCollectionViewCell.self)) }
    
    @IBOutlet weak var characterImage: AsyncImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setImage(_ characterPhoto: String) {
        self.characterImage.setImage(characterPhoto)
    }
    
    func setName (_ name: String) {
        self.characterName.text = name
    }
}
