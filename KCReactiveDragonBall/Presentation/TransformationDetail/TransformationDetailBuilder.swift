//
//  TransformationDetailBuilder.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import UIKit

final class TransformationDetailBuilder {
    let transformation: DBTransformation
    
    init(_ transformation: DBTransformation) {
        self.transformation = transformation
    }
    
    func build() -> UIViewController{
        let viewModel = TransformationDetailViewModel(transformation)
        let viewController = TransformationDetailViewController(viewModel)
        viewController.modalPresentationStyle = .fullScreen

        return viewController
    }
}
