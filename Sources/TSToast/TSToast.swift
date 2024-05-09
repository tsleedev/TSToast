//
//  TSToast.swift
//  TSToast
//
//  Created by TAE SU LEE on 5/9/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

public struct ToastItem {
    let text: String?
    
    public init(text: String?) {
        self.text = text
    }
}

private class Toast: UIView {
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.9)
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.layer.cornerRadius = bounds.height / 2
    }
    
    func configure(_ item: ToastItem) {
        if let text = item.text, !text.isEmpty {
            label.text = text
        } else {
            label.isHidden = true
        }
    }
}

// MARK: - Setup
private extension Toast {
    func setupViews() {
        addSubview(container)
        container.addSubview(stackView)
        stackView.addArrangedSubview(label)
    }
    
    func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24)
        ])
    }
}

public class TSToast {
    static let shared = TSToast()
    
    private init() {}
    
    private var window: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    public static func show(_ item: ToastItem) {
        guard let window = shared.window else { return }
        
        let toast = Toast()
        toast.configure(item)
        window.addSubview(toast)
        
        toast.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toast.topAnchor.constraint(equalTo: window.bottomAnchor, constant: 0),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 24),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -24)
        ])
        
        toastSpringAnimation(with: toast)
    }
}

private extension TSToast {
    static func toastSpringAnimation(with toast: Toast) {
        guard let window = shared.window else { return }
        
        let marginBottom = 10.0
        let toastDefaultHeight = 46.0
        let safeAreaInsetBottom = window.safeAreaInsets.bottom
        
        // Bound 효과와 함께 등장
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                toast.transform = CGAffineTransform(
                    translationX: 0,
                    y: -(marginBottom + toastDefaultHeight + safeAreaInsetBottom)
                )
            },
            completion: nil
        )
        
        // 지정된 시간 후 사라짐
        UIView.animate(
            withDuration: 0.2,
            delay: 2.5,
            options: .curveEaseInOut,
            animations: {
                toast.transform = CGAffineTransform(
                    translationX: 0,
                    y: marginBottom + toastDefaultHeight + safeAreaInsetBottom
                )
            },
            completion: nil
        )
    }
}

#if DEBUG
private class TSToast_PreviewController: UIViewController {
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
    TSToast_PreviewController()
})
#endif
