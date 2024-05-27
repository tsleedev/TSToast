//
//  ViewController.swift
//  TSToastUIKitDemo
//
//  Created by TAE SU LEE on 5/9/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import TSToast
import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultStyle()
    }
    
    private func setupDefaultStyle() {
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.textColor = .white
        self.numberOfLines = 0
    }
}

class CustomToast: Toast {
    override init() {
        let label = CustomLabel()
        super.init(label: label)
        setBackgroundColor(.red.withAlphaComponent(0.9))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    let defaultButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기본 토스트", for: .normal)
        return button
    }()
    let customClassButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("커스텀 클래스 토스트", for: .normal)
        return button
    }()
    let customButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("커스텀 토스트", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureUI()
    }
    
    func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(defaultButton)
        stackView.addArrangedSubview(customClassButton)
        stackView.addArrangedSubview(customButton)
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configureUI() {
        defaultButton.addTarget(self, action: #selector(clickDefaultToast(_:)), for: .touchUpInside)
        customClassButton.addTarget(self, action: #selector(clickClassCustomToast(_:)), for: .touchUpInside)
        customButton.addTarget(self, action: #selector(clickCustomToast(_:)), for: .touchUpInside)
    }
    
    @objc func clickDefaultToast(_ sender: UIButton) {
        // 기본 스타일 설정
        TSToast.toastClass = Toast.self
        
        TSToast.DefaultStyle.backgroundColor = .blue.withAlphaComponent(0.8)
        TSToast.DefaultStyle.textColor = .yellow
        TSToast.DefaultStyle.font = UIFont.boldSystemFont(ofSize: 18)
        
        let item = ToastItem(text: "기본 토스트 메시지입니다.")
        TSToast.show(item)
    }
    
    @objc func clickClassCustomToast(_ sender: UIButton) {
        TSToast.toastClass = CustomToast.self
        
        let item = ToastItem(text: "커스텀 클래스 토스트 메시지입니다.")
        TSToast.show(item)
    }
    
    @objc func clickCustomToast(_ sender: UIButton) {
        let item = ToastItem(text: "커스텀 토스트 메시지입니다.")
        TSToast.show(item, backgroundColor: .purple.withAlphaComponent(0.9), textColor: .white, font: UIFont.italicSystemFont(ofSize: 16))
    }
}

@available(iOS 17.0, *)
#Preview(traits: .defaultLayout, body: {
    ViewController()
})
