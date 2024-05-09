//
//  ViewController.swift
//  TSToastUIKitDemo
//
//  Created by TAE SU LEE on 5/9/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import TSToast
import UIKit

class ViewController: UIViewController {
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("토스트", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureUI()
    }
    
    func setupViews() {
        view.addSubview(button)
    }
    
    func setupConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configureUI() {
        button.addTarget(self, action: #selector(clickToast(_:)), for: .touchUpInside)
    }
    
    @objc func clickToast(_ sender: UIButton) {
        let item = ToastItem(text: "토스트 메시지입니다.")
        TSToast.show(item)
    }
}

@available(iOS 17.0, *)
#Preview(traits: .defaultLayout, body: {
    ViewController()
})
