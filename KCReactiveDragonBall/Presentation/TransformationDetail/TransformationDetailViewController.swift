//
//  TransformationDetailViewController.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import UIKit

class TransformationDetailViewController: UIViewController {

    @IBOutlet weak var transformationImage: AsyncImageView!
    @IBOutlet weak var transformationName: UILabel!
    @IBOutlet weak var transformaitonDescription: UILabel!
    
    let viewModel: TransformationDetailViewModel
    
    init(_ viewModel: TransformationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
    }
    
    func loadInfo(){
        transformationName.text = viewModel.transformation.name
        transformationImage.setImage(viewModel.transformation.photo)
        transformaitonDescription.text = viewModel.transformation.description
    }
}
