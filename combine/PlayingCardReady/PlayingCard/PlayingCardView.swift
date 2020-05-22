//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Ko-Chih Wang on 2020/4/7.
//  Copyright © 2020 Ko-Chih Wang. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    @IBInspectable
    var rank: Int = 13 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suit: String = "❤️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize{
        didSet{
            setNeedsDisplay()
        }
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString( string: string, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, .font: font])
    }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
        switch recognizer.state{
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    private var cornerString: NSAttributedString{
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }

    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?){
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x:bounds.maxX, y: bounds.maxY)
        .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        
    }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp == true {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for:self.classForCoder), compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            }else {
                drawPips()
            }
        } else{
            if let cardBackImge = UIImage(named: "NTNULogo", in: Bundle(for:self.classForCoder), compatibleWith: traitCollection) {
                cardBackImge.draw(in: CGRect(x: bounds.minX, y: bounds.minY + bounds.height*0.3*0.5, width: bounds.width, height: bounds.height*0.7  ) )
            }
        }
    }

    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

}


extension PlayingCardView{
    private struct SizeRatio{
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String{
        switch rank{
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint{
        return CGPoint(x: x+dx, y: y+dy)
    }
}


extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
