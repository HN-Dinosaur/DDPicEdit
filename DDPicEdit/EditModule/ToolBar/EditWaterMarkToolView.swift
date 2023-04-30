//
//  EditWaterMarkToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/22.
//

import UIKit
import Anchorage

public enum WaterMarkLocation: Int, CaseIterable, Codable, Equatable {
    case centerBottom = 0
    case rightBottom
    case center
    case none
    
    var title: String {
        switch self {
        case .centerBottom:
            return "CenterBottom"
        case .rightBottom:
            return "RightBottom"
        case .center:
            return "Center"
        case .none:
            return "None"
        }
    }
}

protocol EditWaterMarkToolViewDelegate: AnyObject {
    
    func selectWaterMarkToolLocation(_ waterMarkView: EditWaterMarkToolView, _ location: WaterMarkLocation)
}

final class EditWaterMarkToolView: DDPicBaseView {
    
    weak var delegate: EditWaterMarkToolViewDelegate?
    private var waterMarkLocationBtns: [UIButton] = []
    private var options: EditorPhotoOptionsInfo
    private var currentSelectLocation: WaterMarkLocation
    
    init(options: EditorPhotoOptionsInfo) {
        self.options = options
        self.currentSelectLocation = options.defaultWaterMarkSelect
        super.init(frame: .zero)
        self.setupWaterMarkView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.waterMarkLocationBtns.forEach {
            $0.isSelected = self.currentSelectLocation.rawValue == $0.tag
            $0.layer.borderColor = $0.isSelected ? UIColor.green.cgColor : UIColor.white.cgColor
        }
    }
    
    private func setupWaterMarkView() {
        WaterMarkLocation.allCases.forEach {
            self.waterMarkLocationBtns.append(createWaterMarkButton($0))
        }
        
        let stackView = UIStackView(arrangedSubviews: self.waterMarkLocationBtns, distribution: .fillEqually, spacing: 10)
        self.addSubview(stackView)
        stackView.horizontalAnchors == self.horizontalAnchors
        stackView.centerYAnchor == self.centerYAnchor
        stackView.heightAnchor == 34
    }
    
    private func createWaterMarkButton(_ location: WaterMarkLocation) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(location.title, for: .normal)
        button.tag = location.rawValue
        button.tintColor = .white
        button.titleLabel?.font = UIFont.PingFang(size: 14)
        button.backgroundColor = .clear
        button.setTitleColor(.green, for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(locationButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func locationButtonTapped(_ sender: UIButton) {
        guard self.currentSelectLocation.rawValue != sender.tag else { return }
        self.currentSelectLocation = WaterMarkLocation(rawValue: sender.tag) ?? .none
        layoutSubviews()
        self.delegate?.selectWaterMarkToolLocation(self, currentSelectLocation)
    }
}
