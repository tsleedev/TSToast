//
//  TSToast.swift
//  TSToast
//
//  Created by TAE SU LEE on 5/9/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

public struct ToastItem {
    public let text: String?
    
    public init(text: String?) {
        self.text = text
    }
}

public protocol ToastDisplayable: UIView {
    func configure(_ item: ToastItem)
    func setBackgroundColor(_ color: UIColor)
    func setTextColor(_ color: UIColor)
    func setFont(_ font: UIFont)
}

open class Toast: UIView, ToastDisplayable {
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = TSToast.DefaultStyle.backgroundColor
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
    
    public var label: UILabel
    
    public init() {
        let label = {
            let label = UILabel()
            label.font = TSToast.DefaultStyle.font
            label.textColor = TSToast.DefaultStyle.textColor
            label.numberOfLines = 0
            return label
        }()
        self.label = label
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    public init(label: UILabel) {
        self.label = label
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        container.layer.cornerRadius = bounds.height / 2
    }
    
    public func configure(_ item: ToastItem) {
        if let text = item.text, !text.isEmpty {
            label.text = text
        } else {
            label.isHidden = true
        }
    }
    
    public func setBackgroundColor(_ color: UIColor) {
        container.backgroundColor = color
    }
    
    public func setTextColor(_ color: UIColor) {
        label.textColor = color
    }
    
    public func setFont(_ font: UIFont) {
        label.font = font
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
    private init() {}
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
    
    public static var toastClass: ToastDisplayable.Type = Toast.self
    
    public struct DefaultStyle {
        public static var backgroundColor: UIColor = .black.withAlphaComponent(0.9)
        public static var textColor: UIColor = .white
        public static var font: UIFont = UIFont.systemFont(ofSize: 16)
    }
    
    public static func show(_ item: ToastItem, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, font: UIFont? = nil) {
        guard let window = window else { return }
        
        let toast = toastClass.init()
        toast.configure(item)
        
        if let backgroundColor = backgroundColor {
            toast.setBackgroundColor(backgroundColor)
        }
        if let textColor = textColor {
            toast.setTextColor(textColor)
        }
        if let font = font {
            toast.setFont(font)
        }
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
    static func toastSpringAnimation(with toast: ToastDisplayable) {
        guard let window = window else { return }
        
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
            completion: { _ in
                toast.removeFromSuperview()
            }
        )
    }
}

#if DEBUG
private class CustomLabel: UILabel {
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

private class CustomToast: Toast {
    override init() {
        let customLabel = CustomLabel()
        super.init(label: customLabel)
        setBackgroundColor(.red.withAlphaComponent(0.9))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class CustomProtocolToast: UIView, ToastDisplayable {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.9)
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
    
    func configure(_ item: ToastItem) {
        if let text = item.text, !text.isEmpty {
            label.text = text
        } else {
            label.isHidden = true
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {}
    func setTextColor(_ color: UIColor) {}
    func setFont(_ font: UIFont) {}
    
    // MARK: - Setup
    func setupViews() {
        addSubview(label)
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

private class TSToast_PreviewController: UIViewController {
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
    let customProtocolButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("커스텀 프로토콜 토스트", for: .normal)
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
        stackView.addArrangedSubview(customProtocolButton)
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
        customProtocolButton.addTarget(self, action: #selector(clickProtocolCustomToast(_:)), for: .touchUpInside)
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
    
    @objc func clickProtocolCustomToast(_ sender: UIButton) {
        TSToast.toastClass = CustomProtocolToast.self
        
        let item = ToastItem(text: "커스텀 프로토콜 토스트 메시지입니다.")
        TSToast.show(item)
    }
    
    @objc func clickCustomToast(_ sender: UIButton) {
        let item = ToastItem(text: "커스텀 토스트 메시지입니다.")
        TSToast.show(item, backgroundColor: .purple.withAlphaComponent(0.9), textColor: .white, font: UIFont.italicSystemFont(ofSize: 16))
    }
}

@available(iOS 17.0, *)
#Preview(traits: .defaultLayout, body: {
    TSToast_PreviewController()
})
#endif
