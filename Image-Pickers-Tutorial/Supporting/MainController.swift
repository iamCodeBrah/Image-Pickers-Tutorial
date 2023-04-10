//
//  ViewController.swift
//  Image-Pickers-Tutorial
//
//  Created by YouTube on 2023-04-10.
//

import UIKit

class MainController: UIViewController {
    
    // MARK: - UI Components
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .label
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(didTapPhotoButton))
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width*0.8),
            imageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    // MARK: - Selectors
    @objc internal func didTapPhotoButton() {
        fatalError("Must inplement didTapPhotoButton")
    }
}

