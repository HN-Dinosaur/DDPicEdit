//
//  DDPicNineGridViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/30.
//

import UIKit
import Anchorage

public class DDPicNineGridViewController: DDPicBaseViewController {
    
    private var resultPics: [UIImage] = [] {
        didSet {
            self.displayPicCollectionView.reloadData()
            self.tipsLabel.isHidden = resultPics.count > 0
            self.bottomButton.setTitle(resultPics.count > 0 ? "切换照片" : "添加照片", for: .normal)
            if #available(iOS 16.0, *) {
                self.rightBarButton.isHidden = !(resultPics.count > 0)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    private let spacing: CGFloat = 2
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
    }
    
    private func setupView() {
        self.view.recursiveAddSubView(views: [self.displayPicCollectionView, self.bottomButton])
        self.displayPicCollectionView.addSubview(self.tipsLabel)
        self.view.backgroundColor = .white
        self.bottomButton.horizontalAnchors == self.view.horizontalAnchors + 20
        self.bottomButton.bottomAnchor == self.view.bottomAnchor - 20
        self.bottomButton.heightAnchor == 56
        
        self.displayPicCollectionView.edgeAnchors == self.view.edgeAnchors
        
        self.tipsLabel.centerXAnchor == self.displayPicCollectionView.centerXAnchor
        self.tipsLabel.centerYAnchor == self.view.centerYAnchor
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = rightBarButton
        if #available(iOS 16.0, *) {
            self.rightBarButton.isHidden = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func storePhoto() {
        self.resultPics.forEach {
            UIImageWriteToSavedPhotosAlbum($0, self, nil, nil)
        }
        let alert = UIAlertController.show(title: "保存成功" ,actions: [])
        self.present(alert, animated: true)
    }
    
    
    
    private func processPhoto(_ image: UIImage) {
        var processImage: UIImage
        if image.size.height != image.size.width, let image = getSquarePic(image) {
            processImage = image
        } else {
            processImage = image
        }
        let stepY = processImage.size.width / 3
        let stepX = processImage.size.height / 3
        let resultPicSize = CGSize(width: stepX, height: stepY)
        var result = [UIImage?]()
        for y in 0...2 {
            for x in 0...2 {
                result.append(processImage.cropping(to: CGRect(origin: CGPoint(x: stepX * CGFloat(x), y: stepY * CGFloat(y)), size: resultPicSize)))
            }
        }
        self.resultPics = result.compactMap { $0 }
    }
    
    private func getSquarePic(_ image: UIImage) -> UIImage? {
        let picWidth = image.size.width
        let picHeight = image.size.height
        let picLength = min(image.size.height, image.size.width)
        let x = picWidth > picHeight ? (picWidth - picLength) / 2 : 0
        let y = picHeight > picWidth ? (picHeight - picLength) / 2 : 0
        return image.cropping(to: CGRect(x: x, y: y, width: picLength, height: picLength))
    }
    
    @objc func tapBottomButton() {
        var options = CaptureOptionsInfo()
        options.photoAspectRatio = .ratio1x1
        let captureAction = UIAlertAction(title: "相机", style: .default) { [weak self] _ in
            guard let self = self else { return }
            options.enableDebugLog = true
            let controller = ImageCaptureController(options: options, delegate: self)
            controller.trackDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        let albumAction = UIAlertAction(title: "相册", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let picker = UIImagePickerController()
            picker.delegate = self
            //打开相机
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
            //让页面出现
            self.present(picker, animated: true)
        }
        
        let alert = UIAlertController(title: "请选择图片上传方式", message: nil, preferredStyle: .actionSheet)
        alert.addAction(captureAction)
        alert.addAction(albumAction)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        self.present(alert, animated: true)
    }

    private lazy var displayPicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth: CGFloat = UIKitConstant.UIScreenWidth
        let width: CGFloat = floor((screenWidth - spacing * 2) / 3)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerCellClasses(classes: [NineGridPicCell.self])
        return collectionView
    }()
    
    private lazy var rightBarButton = UIBarButtonItem(title: "全部保存", style: .plain, target: self, action: #selector(storePhoto))
    
    private lazy var tipsLabel = UILabel(text: "请添加图片", color: .darkGray, textFont: .PingFangMedium(size: 20))
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton(title: "添加照片", font: .PingFangMedium(size: 20), edgeInset: .zero)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapBottomButton), for: .touchUpInside)
        return button
    }()
    
}

extension DDPicNineGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.resultPics.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NineGridPicCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.setImage(resultPics[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = EditorResultViewController()
        controller.imageView.image = resultPics[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension DDPicNineGridViewController: ImageCaptureControllerDelegate {
    public func imageCapture(_ capture: ImageCaptureController, didFinishCapturing result: CaptureResult) {
        switch result.type {
        case .photo:
            capture.dismiss(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                guard let data = try? Data(contentsOf: result.mediaURL) else { return }
                guard let image = UIImage(data: data) else { return }
                self.processPhoto(image)
            })
        case .photoLive, .photoGIF:
            // Not support yet
            break
        default:
            break
        }
    }
}

extension DDPicNineGridViewController: ImageKitDataTrackDelegate {
    public func dataTrack(page: AnyImagePage, state: AnyImagePageState) {
        switch state {
        case .enter:
            print("[Data Track] ENTER Page: \(page.rawValue)")
        case .leave:
            print("[Data Track] LEAVE Page: \(page.rawValue)")
        }
    }
    
    public func dataTrack(event: AnyImageEvent, userInfo: [AnyImageEventUserInfoKey: Any]) {
        print("[Data Track] EVENT: \(event.rawValue), userInfo: \(userInfo)")
    }
}

extension DDPicNineGridViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let image = info[.originalImage] as? UIImage{
              self.processPhoto(image)
          }
          picker.dismiss(animated: true, completion: nil)
      }
}
