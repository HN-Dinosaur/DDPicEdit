////
////  EditWaterMarkToolView.swift
////  DDPicEdit
////
////  Created by LongDengYu on 2023/4/22.
////
//
//import UIKit
//import Anchorage
//
//enum WaterMarkLocation: Int, CaseIterable {
//    case centerBottom = 0
//    case rightBottom
//    case center
//    
//    var title: String {
//        switch self {
//        case .centerBottom:
//            return "CenterBottom"
//        case .rightBottom:
//            return "RightBottom"
//        case .center:
//            return "Center"
//        }
//    }
//}
//
//protocol EditWaterMarkToolViewDelegate: AnyObject {
//    
//    func selectWaterMarkToolLocation(_ waterMarkView: EditWaterMarkToolView, _ location: WaterMarkLocation)
//}
//
//final class EditWaterMarkToolView: DDPicBaseView {
//    
//    weak var delegate: EditWaterMarkToolViewDelegate?
//    private var waterMarkLocationBtns: [UIButton] = []
//    
//    init() {
//        super.init(frame: .zero)
//        self.setupWaterMarkView()
//    }
//    
//    private func setupWaterMarkView() {
//        WaterMarkLocation.allCases.forEach {
//            self.waterMarkLocationBtns.append(createWaterMarkButton($0))
//        }
//        
//        let stackView = UIStackView(arrangedSubviews: self.waterMarkLocationBtns, distribution: .fillEqually, spacing: 10)
//        self.addSubview(stackView)
//        stackView.horizontalAnchors == self.horizontalAnchors
//        stackView.centerYAnchor == self.centerYAnchor
//        stackView.heightAnchor == 34
//    }
//    
//    private func createWaterMarkButton(_ location: WaterMarkLocation) -> UIButton {
//        let button = UIButton(type: .custom)
//        button.setTitle(location.title, for: .normal)
//        button.tag = location.rawValue
//        button.tintColor = .white
//        button.titleLabel?.font = UIFont.PingFang(size: 14)
//        button.backgroundColor = .clear
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 1
//        button.addTarget(self, action: #selector(locationButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }
//    
//    @objc private func locationButtonTapped(_ sender: UIButton) {
//        self.delegate?.selectWaterMarkToolLocation(self, WaterMarkLocation(rawValue: sender.tag) ?? .rightBottom)
//    }
//}
