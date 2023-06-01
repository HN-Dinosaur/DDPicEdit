//
//  InputTextViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/18.
//

import UIKit
import Anchorage

final class InputTextViewController: DDPicBaseViewController {
    
    private let context: PhotoEditorContext
    private var options: EditorPhotoOptionsInfo { return context.options }
    private let coverImage: UIImage?
    private let data: StickerData
    private let lineHeight: CGFloat
    private let vInset: CGFloat = 8
    private let hInset: CGFloat = 12
    private var isBegin: Bool = true
    private var containerSize: CGSize = .zero
    private var toolViewConstraints: [NSLayoutConstraint] = []
    private var textCoverViewRightConstraint: [NSLayoutConstraint] = []
    private var textCoverViewHeightConstraint: [NSLayoutConstraint] = []
    
    override var prefersStatusBarHidden: Bool { true }
    
    override var shouldAutorotate: Bool { false }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch UIApplication.shared.statusBarOrientation {
        case .unknown:
            return .portrait
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        @unknown default:
            fatalError()
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    init(context: PhotoEditorContext, data: StickerData, coverImage: UIImage?) {
        self.context = context
        self.coverImage = coverImage
        self.data = data
        self.lineHeight = context.options.textFont.lineHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setupView()
        self.addNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let newSize = view.frame.size
        if containerSize != .zero, containerSize != newSize {
            view.endEditing(true)
            dismiss(animated: false, completion: nil)
            return
        }
        containerSize = newSize
        
        if isBegin {
            isBegin = false
            if !data.text.isEmpty {
                textView.text = data.text
                textViewDidChange(textView)
                updateShadow()
            }
            textView.becomeFirstResponder()
        }
    }
    
    private func setupView() {
        self.view.recursiveAddSubView(views: [
            self.coverImageView,
            self.coverView,
            self.cancelButton,
            self.doneButton,
            self.textCoverView,
            self.calculateLabel,
            self.toolView
        ])
        self.textCoverView.addSubview(self.textView)
        
        self.coverImageView.horizontalAnchors == self.view.horizontalAnchors
        self.coverImageView.centerYAnchor == self.view.centerYAnchor
        if let image = coverImage {
            let height = UIScreen.main.bounds.width * image.size.height / image.size.width
            self.coverImageView.heightAnchor == height
        } else {
            self.coverImageView.heightAnchor == 0
        }
        
        self.coverView.edgeAnchors == self.view.edgeAnchors
        
        self.cancelButton.leftAnchor == self.view.leftAnchor + 15
        if #available(iOS 11.0, *) {
            let topOffset: CGFloat = ScreenHelper.statusBarFrame.height <= 20 ? 20 : 10
            self.cancelButton.topAnchor == self.view.safeAreaLayoutGuide.topAnchor + topOffset
        } else {
            self.cancelButton.topAnchor == self.view.topAnchor + 30
        }
        
        self.doneButton.centerYAnchor == self.cancelButton.centerYAnchor
        self.doneButton.rightAnchor == self.view.rightAnchor - 15
        
        self.layoutToolView()
        
        self.textCoverView.topAnchor == self.cancelButton.bottomAnchor + 50
        self.textCoverView.leftAnchor == self.view.leftAnchor + hInset
        self.textCoverViewRightConstraint.rebatch {
            self.textCoverView.rightAnchor == self.view.rightAnchor - hInset
        }
        self.textCoverViewHeightConstraint.rebatch {
            self.textCoverView.heightAnchor == self.lineHeight + self.vInset * 2
        }
        
        self.textView.topAnchor == self.textCoverView.topAnchor + self.vInset
        self.textView.bottomAnchor == self.textCoverView.bottomAnchor
        self.textView.horizontalAnchors == self.textCoverView.horizontalAnchors + self.hInset
        
        self.calculateLabel.topAnchor == self.cancelButton.bottomAnchor + 250
        self.calculateLabel.horizontalAnchors == self.textView.horizontalAnchors
        self.calculateLabel.heightAnchor >= 55
    }
    
    private func layoutToolView(bottomOffset: CGFloat = 0) {
        self.toolViewConstraints.rebatch {
            self.toolView.horizontalAnchors == self.view.horizontalAnchors
            self.toolView.heightAnchor == 40
            if bottomOffset == 0 {
                if #available(iOS 11.0, *) {
                    self.toolView.bottomAnchor == self.view.safeAreaLayoutGuide.bottomAnchor - 20
                } else {
                    self.toolView.bottomAnchor == self.view.bottomAnchor - 40
                }
            } else {
                self.toolView.bottomAnchor == self.view.bottomAnchor + (-bottomOffset - 20)
            }
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardFrameChanged(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let offset = UIScreen.main.bounds.height - frame.origin.y
        layoutToolView(bottomOffset: offset)
        view.layoutIfNeeded()
    }
    
    deinit {
        self.removeNotification()
    }
    
    private lazy var coverImageView = UIImageView(image: self.coverImage, contentMode: .scaleAspectFill)
    private lazy var coverView = UIView(backgroundColor: .black.withAlphaComponent(0.45))
    private lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle(options.theme[string: .cancel], for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.PingFang(size: 16)
        view.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 4
        view.backgroundColor = options.theme[color: .primary]
        view.setTitle(options.theme[string: .done], for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.PingFang(size: 16)
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 10)
        view.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var toolView: EditorTextToolView = {
        let view = EditorTextToolView(frame: .zero, options: options, idx: data.colorIdx, isTextSelected: data.isTextSelected)
        view.delegate = self
        return view
    }()
    private var textLayer: CAShapeLayer?
    private lazy var textCoverView = UIView(frame: .zero)
    private lazy var textView: UITextView = {
        let view = MyUITextView()
        view.delegate = self
        view.backgroundColor = .clear
        view.keyboardAppearance = .dark
        view.returnKeyType = .done
        view.enablesReturnKeyAutomatically = true
        view.showsVerticalScrollIndicator = false
        view.font = options.textFont
        view.tintColor = options.theme[color: .primary]
        let color = options.textColors[data.colorIdx]
        view.textColor = data.isTextSelected ? color.subColor : color.color
        view.frame = CGRect(x: hInset, y: 0, width: UIScreen.main.bounds.width - hInset * 4, height: lineHeight + vInset * 2) // 预设
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    /// 仅用于计算TextView最后一行的文本
    private lazy var calculateLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.isHidden = true
        return view
    }()
}

// MARK: - Target
extension InputTextViewController {
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        context.action(.stickerCancel)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        updateTextCoverView()
        textView.resignFirstResponder()
        data.frame = .zero
        data.text = textView.text
        data.imageData = textCoverView.screenshot().pngData() ?? Data()
        context.action(.stickerDone(data))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private
extension InputTextViewController {
    
    /// 设置蒙层
    private func setupMaskLayer(_ height: CGFloat = 0) {
        let height = height == 0 ? textCoverView.bounds.height : height
        textLayer?.removeFromSuperlayer()
        guard data.isTextSelected else { return }
        let array = textView.getSeparatedLines()
        if array.isEmpty { return }
        
        updateCalculateLabel(string: array.last!)
        let lastLineWidth: CGFloat
        if options.calculateTextLastLineMask {
            lastLineWidth = calculateLabel.intrinsicContentSize.width + (hInset * 2)
        } else {
            lastLineWidth = array.count == 1 ? calculateLabel.intrinsicContentSize.width + (hInset * 2) : textCoverView.bounds.width
        }
        textLayer = createMaskLayer(CGSize(width: textCoverView.bounds.width, height: height), lastLineWidth: lastLineWidth, hasMultiLine: array.count > 1)
        textCoverView.layer.insertSublayer(textLayer!, at: 0)
    }
    
    /// 创建蒙层
    private func createMaskLayer(_ size: CGSize, lastLineWidth: CGFloat, hasMultiLine: Bool) -> CAShapeLayer {
        let radius: CGFloat = 12
        let lastLineWidth = lastLineWidth < size.width ? lastLineWidth : size.width
        let width: CGFloat = !hasMultiLine ? lastLineWidth : size.width
        let height: CGFloat = size.height
        let lastLineHeight: CGFloat = lineHeight
        
        let bezier: UIBezierPath
        if hasMultiLine && width - lastLineWidth > (hInset * 2) { // 一半的情况
            bezier = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            // 最后一行右边
            let cropBezier1 = UIBezierPath(roundedRect: CGRect(x: lastLineWidth, y: height-lastLineHeight, width: width-lastLineWidth, height: lastLineHeight), byRoundingCorners: .topLeft, cornerRadii: CGSize(width: radius, height: radius))
            bezier.append(cropBezier1)
            // 倒数第一个行右下角
            let cropBezier2 = createReversePath(CGPoint(x: lastLineWidth-radius, y: height-radius), radius: radius)
            bezier.append(cropBezier2)
            // 倒数第二行右下角
            let cropBezier3 = createReversePath(CGPoint(x: width-radius, y: height-lastLineHeight-radius), radius: radius)
            bezier.append(cropBezier3)
        } else {
            bezier = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: radius)
        }
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.path = bezier.cgPath
        layer.fillRule = .evenOdd
        layer.cornerRadius = radius
        let color = options.textColors[data.colorIdx]
        layer.fillColor = data.isTextSelected ? color.color.withAlphaComponent(0.95).cgColor : nil
        return layer
    }
    
    /// 创建反向扇形图形
    private func createReversePath(_ origin: CGPoint, radius: CGFloat) -> UIBezierPath {
        let rect = CGRect(origin: origin, size: CGSize(width: radius, height: radius))
        let cropBezier = UIBezierPath(rect: rect)
        cropBezier.move(to: origin)
        cropBezier.addArc(withCenter: origin, radius: radius, startAngle: CGFloat.pi/2, endAngle: 0, clockwise: false)
        return cropBezier.reversing()
    }
    
    /// 仅单行文本时，更新实际输出视图的宽度
    private func updateTextCoverView() {
        let array = textView.getSeparatedLines()
        if array.count == 1 {
            updateCalculateLabel(string: array.last!)
            let lastLineWidth = calculateLabel.intrinsicContentSize.width + (hInset * 2)
            let offset = textCoverView.bounds.width - lastLineWidth + hInset
            
            self.textCoverViewRightConstraint.rebatch {
                self.textCoverView.rightAnchor == self.view.rightAnchor - offset
            }
        }
    }
    
    /// 更新计算文本的内容
    private func updateCalculateLabel(string: String) {
        guard var attr = textView.attributedText else { return }
        attr = attr.attributedSubstring(from: (attr.string as NSString).range(of: string))
        calculateLabel.attributedText = attr
    }
    
    /// 设置文本阴影
    private func updateShadow() {
        if data.isTextSelected {
            textView.layer.removeSketchShadow()
        } else {
            if let shadow = options.textColors[data.colorIdx].shadow {
                textView.layer.applySketchShadow(with: shadow)
            } else {
                textView.layer.removeSketchShadow()
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension InputTextViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let line = CGFloat(textView.getSeparatedLines().count)
        let height: CGFloat = max(lineHeight * line, textView.contentSize.height) + vInset * 2
        self.textCoverViewHeightConstraint.rebatch {
            self.textCoverView.heightAnchor == height
        }
        setupMaskLayer(height)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.setContentOffset(.zero, animated: false)
        if text == "\n" {
            doneButtonTapped(doneButton)
            return false
        }
        return true
    }
}

// MARK: - EditorTextToolViewDelegate
extension InputTextViewController: EditorTextToolViewDelegate {
    
    func textToolView(_ toolView: EditorTextToolView, textButtonTapped isSelected: Bool) {
        data.isTextSelected = isSelected
        let color = options.textColors[data.colorIdx]
        textView.textColor = data.isTextSelected ? color.subColor : color.color
        setupMaskLayer()
        updateShadow()
        trackObserver?.track(event: .editorPhotoTextSwitch, userInfo: [.isOn: isSelected])
    }
    
    func textToolView(_ toolView: EditorTextToolView, colorDidChange idx: Int) {
        data.colorIdx = idx
        let color = options.textColors[data.colorIdx]
        textView.textColor = data.isTextSelected ? color.subColor : color.color
        if data.isTextSelected {
            setupMaskLayer()
        }
        updateShadow()
    }
}

private final class MyUITextView: UITextView {
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        return
    }
}
