//
//  ViewController.swift
//  ExCALayer_2
//
//  Created by 김종권 on 2023/02/07.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slantView = SlantView(firstImage: .init(named: "1"), secondImage: .init(named: "2"), ratio: 0.5)
        view.addSubview(slantView)
        slantView.snp.makeConstraints {
            $0.size.equalTo(350)
            $0.center.equalToSuperview()
        }
    }
}

final class SlantView: UIView {
    private let ratio: Double
    private let firstImageView: UIImageView
    private let secondImageView: UIImageView
    
    init(firstImage: UIImage?, secondImage: UIImage?, ratio: Double) {
        self.ratio = ratio
        self.firstImageView = UIImageView(image: firstImage)
        self.secondImageView = UIImageView(image: secondImage)
        
        super.init(frame: .zero)
        
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mask()
    }
    
    private func setUp() {
        backgroundColor = .clear
        
        firstImageView.contentMode = .scaleAspectFill
        secondImageView.contentMode = .scaleAspectFill
        
        addSubview(firstImageView)
        addSubview(secondImageView)
        
        firstImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        secondImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func mask() {
        // 1. path 인스턴스로 경로 정보 획득
        let firstPath = getFirstImagePath()
        let secondPath = getSecondImagePath()
        
        // 2. shapeLayer.path에 위 path 인스턴스 대입
        let firstShapeLayer = CAShapeLayer()
        firstShapeLayer.path = firstPath.cgPath
        
        let secondShapeLayer = CAShapeLayer()
        secondShapeLayer.path = secondPath.cgPath
        
        // 3. layer.mask에 shapeLayer를 대입
        firstImageView.layer.mask = firstShapeLayer
        secondImageView.layer.mask = secondShapeLayer
    }
    
    private func getFirstImagePath() -> UIBezierPath {
        let path = UIBezierPath()
        let bs = firstImageView.bounds
        path.move(to: bs.origin)
        path.addLine(to: .init(x: bs.maxX * ratio, y: bs.minY))
        path.addLine(to: .init(x: bs.minX + bs.width * (1 - ratio), y: bs.maxY))
        path.addLine(to: .init(x: bs.minX, y: bs.maxY))
        path.close()
        return path
    }

    private func getSecondImagePath() -> UIBezierPath {
        let path = UIBezierPath()
        let bs = secondImageView.bounds
        path.move(to: .init(x: bs.minX + bs.width * ratio, y: bs.minY))
        path.addLine(to: .init(x: bs.maxX, y: bs.minY))
        path.addLine(to: .init(x: bs.maxX, y: bs.maxY))
        path.addLine(to: .init(x: bs.minX + bs.width * (1 - ratio), y: bs.maxY))
        path.close()
        return path
    }
}
