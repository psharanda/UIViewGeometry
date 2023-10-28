//
//  Created by Pavel Sharanda on 27/10/2023.
//

import UIKit

class GeometryViewController: UIViewController {
    // MARK: - state

    private struct State {
        var bounds: CGRect
        var center: CGPoint
        var anchorPoint: CGPoint
        var scale: CGFloat
        var rotation: CGFloat
    }

    private var state = State(bounds: CGRect(x: 0, y: 0, width: 150, height: 150),
                              center: CGPoint(x: 150, y: 150),
                              anchorPoint: CGPoint(x: 0.5, y: 0.5),
                              scale: 1,
                              rotation: 0)
    {
        didSet {
            updateValueLabels()
            updateTargetViewGeometry()
        }
    }

    // MARK: - constants

    private enum Colors {
        enum Background {
            static let view = UIColor.systemBlue
            static let superview = UIColor.systemRed.withAlphaComponent(0.1)
            static let subview = UIColor.systemYellow
            static let frame = UIColor.systemMint.withAlphaComponent(0.1)
            static let anchorPoint = UIColor.white
        }

        enum Border {
            static let line = UIColor.systemRed
            static let anchorPoint = UIColor.systemRed
            static let superview = UIColor.systemRed
        }
    }

    // MARK: - views

    private lazy var frameView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Background.frame
        return v
    }()

    // This the view we experiment with, the view for which we change bounds, center, anchorPoint, transform
    private lazy var targetView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Background.view
        return v
    }()

    private lazy var xCenterLine: CAShapeLayer = {
        let v = CAShapeLayer()
        v.strokeColor = Colors.Border.line.cgColor
        v.lineDashPattern = [5, 5]
        v.lineWidth = 2

        return v
    }()

    private lazy var yCenterLine: CAShapeLayer = {
        let v = CAShapeLayer()
        v.strokeColor = Colors.Border.line.cgColor
        v.lineDashPattern = [5, 5]
        v.lineWidth = 2
        return v
    }()

    private lazy var anchorPointCircle: CAShapeLayer = {
        let v = CAShapeLayer()
        v.fillColor = Colors.Background.anchorPoint.cgColor
        v.strokeColor = Colors.Border.anchorPoint.cgColor
        v.lineWidth = 2
        return v
    }()

    private var boundsXValueLabel: UILabel?
    private var boundsYValueLabel: UILabel?
    private var boundsWidthValueLabel: UILabel?
    private var boundsHeightValueLabel: UILabel?
    private var centerXValueLabel: UILabel?
    private var centerYValueLabel: UILabel?
    private var anchorPointXValueLabel: UILabel?
    private var anchorPointYValueLabel: UILabel?
    private var scaleValueLabel: UILabel?
    private var rotationValueLabel: UILabel?

    // MARK: - overrides

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // content

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        let superView = UIView()
        superView.translatesAutoresizingMaskIntoConstraints = false
        superView.clipsToBounds = true
        superView.layer.borderWidth = 1
        superView.layer.borderColor = Colors.Border.superview.cgColor
        superView.backgroundColor = Colors.Background.superview
        contentView.addSubview(superView)

        superView.addSubview(frameView)
        superView.addSubview(targetView)
        superView.layer.addSublayer(xCenterLine)
        superView.layer.addSublayer(yCenterLine)
        superView.layer.addSublayer(anchorPointCircle)

        let subview = UIView()
        subview.backgroundColor = Colors.Background.subview
        subview.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        targetView.addSubview(subview)

        // legend

        let legendView = UIStackView()
        legendView.alignment = .center
        legendView.axis = .horizontal
        legendView.distribution = .equalSpacing
        legendView.spacing = 5
        legendView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(legendView)

        let legendFont = UIFont.systemFont(ofSize: 9)
        let legendViewSize = CGSize(width: 25, height: 18)

        let viewLegend = UIView()
        viewLegend.translatesAutoresizingMaskIntoConstraints = false
        viewLegend.widthAnchor.constraint(equalToConstant: legendViewSize.width).isActive = true
        viewLegend.heightAnchor.constraint(equalToConstant: legendViewSize.height).isActive = true
        viewLegend.backgroundColor = Colors.Background.view
        legendView.addArrangedSubview(viewLegend)

        let viewLegendLabel = UILabel()
        viewLegendLabel.translatesAutoresizingMaskIntoConstraints = false
        viewLegendLabel.font = legendFont
        viewLegendLabel.text = "View"
        legendView.addArrangedSubview(viewLegendLabel)

        let superviewLegend = UIView()
        superviewLegend.translatesAutoresizingMaskIntoConstraints = false
        superviewLegend.widthAnchor.constraint(equalToConstant: legendViewSize.width).isActive = true
        superviewLegend.heightAnchor.constraint(equalToConstant: legendViewSize.height).isActive = true
        superviewLegend.layer.borderWidth = 1
        superviewLegend.layer.borderColor = Colors.Border.superview.cgColor
        superviewLegend.backgroundColor = Colors.Background.superview
        legendView.addArrangedSubview(superviewLegend)

        let superviewLegendLabel = UILabel()
        superviewLegendLabel.translatesAutoresizingMaskIntoConstraints = false
        superviewLegendLabel.font = legendFont
        superviewLegendLabel.text = "Superview"
        legendView.addArrangedSubview(superviewLegendLabel)

        let subviewLegend = UIView()
        subviewLegend.widthAnchor.constraint(equalToConstant: legendViewSize.width).isActive = true
        subviewLegend.heightAnchor.constraint(equalToConstant: legendViewSize.height).isActive = true
        subviewLegend.translatesAutoresizingMaskIntoConstraints = false
        subviewLegend.backgroundColor = Colors.Background.subview
        legendView.addArrangedSubview(subviewLegend)

        let subviewLegendLabel = UILabel()
        subviewLegendLabel.font = legendFont
        subviewLegendLabel.text = "Subview"
        legendView.addArrangedSubview(subviewLegendLabel)

        let frameLegend = UIView()
        frameLegend.widthAnchor.constraint(equalToConstant: legendViewSize.width).isActive = true
        frameLegend.heightAnchor.constraint(equalToConstant: legendViewSize.height).isActive = true
        frameLegend.translatesAutoresizingMaskIntoConstraints = false
        frameLegend.backgroundColor = Colors.Background.frame
        legendView.addArrangedSubview(frameLegend)

        let frameLegendLabel = UILabel()
        frameLegendLabel.font = legendFont
        frameLegendLabel.text = "Frame"
        legendView.addArrangedSubview(frameLegendLabel)

        let anchorPointLegend = UIView()
        anchorPointLegend.widthAnchor.constraint(equalToConstant: legendViewSize.height).isActive = true
        anchorPointLegend.heightAnchor.constraint(equalToConstant: legendViewSize.height).isActive = true
        anchorPointLegend.translatesAutoresizingMaskIntoConstraints = false
        anchorPointLegend.layer.borderWidth = 2
        anchorPointLegend.layer.cornerRadius = legendViewSize.height / 2
        anchorPointLegend.layer.borderColor = Colors.Border.anchorPoint.cgColor
        anchorPointLegend.backgroundColor = Colors.Background.anchorPoint
        legendView.addArrangedSubview(anchorPointLegend)

        let anchorPointLegendLabel = UILabel()
        anchorPointLegendLabel.font = legendFont
        anchorPointLegendLabel.text = "Anchor Point"
        legendView.addArrangedSubview(anchorPointLegendLabel)

        // control panel

        let controlPanel = UIView()
        controlPanel.translatesAutoresizingMaskIntoConstraints = false
        controlPanel.backgroundColor = .systemGroupedBackground
        controlPanel.layer.shadowOpacity = 0.1
        view.addSubview(controlPanel)

        let cells = [
            addSliderCell(title: "bounds.x", initialValue: Float(state.bounds.origin.x), minValue: -100, maxValue: 100, valueChangedAction: #selector(handleBoundsX), outerValueLabel: &boundsXValueLabel),
            addSliderCell(title: "bounds.y", initialValue: Float(state.bounds.origin.y), minValue: -100, maxValue: 100, valueChangedAction: #selector(handleBoundsY), outerValueLabel: &boundsYValueLabel),
            addSliderCell(title: "bounds.width", initialValue: Float(state.bounds.size.width), minValue: 0, maxValue: 300, valueChangedAction: #selector(handleBoundsWidth), outerValueLabel: &boundsWidthValueLabel),
            addSliderCell(title: "bounds.height", initialValue: Float(state.bounds.size.height), minValue: 0, maxValue: 300, valueChangedAction: #selector(handleBoundsHeight), outerValueLabel: &boundsHeightValueLabel),
            addSliderCell(title: "center.x", initialValue: Float(state.center.x), minValue: 0, maxValue: 300, valueChangedAction: #selector(handleCenterX), outerValueLabel: &centerXValueLabel),
            addSliderCell(title: "center.y", initialValue: Float(state.center.y), minValue: 0, maxValue: 300, valueChangedAction: #selector(handleCenterY), outerValueLabel: &centerYValueLabel),
            addSliderCell(title: "anchorPoint.x", initialValue: Float(state.anchorPoint.x), minValue: 0, maxValue: 1, valueChangedAction: #selector(handleAnchorPointX), outerValueLabel: &anchorPointXValueLabel),
            addSliderCell(title: "anchorPoint.y", initialValue: Float(state.anchorPoint.y), minValue: 0, maxValue: 1, valueChangedAction: #selector(handleAnchorPointY), outerValueLabel: &anchorPointYValueLabel),
            addSliderCell(title: "scale", initialValue: Float(state.scale), minValue: 0, maxValue: 2, valueChangedAction: #selector(handleScale), outerValueLabel: &scaleValueLabel),
            addSliderCell(title: "rotation", initialValue: Float(state.rotation), minValue: 0, maxValue: 360, valueChangedAction: #selector(handleRotation), outerValueLabel: &rotationValueLabel),
        ]

        for cell in cells {
            controlPanel.addSubview(cell)
        }

        // constraints

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: legendView.topAnchor, constant: -5),

            superView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            superView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            superView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            superView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            legendView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            legendView.heightAnchor.constraint(equalToConstant: 20),
            legendView.bottomAnchor.constraint(equalTo: controlPanel.topAnchor, constant: -10),

            controlPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        var previousCell: UIView?
        for cell in cells {
            cell.leadingAnchor.constraint(equalTo: controlPanel.leadingAnchor).isActive = true
            cell.trailingAnchor.constraint(equalTo: controlPanel.trailingAnchor).isActive = true

            if let previousCell {
                cell.topAnchor.constraint(equalTo: previousCell.bottomAnchor).isActive = true
            } else {
                cell.topAnchor.constraint(equalTo: controlPanel.topAnchor).isActive = true
            }

            if cell == cells.last {
                cell.bottomAnchor.constraint(equalTo: controlPanel.safeAreaLayoutGuide.bottomAnchor).isActive = true
            }
            cell.heightAnchor.constraint(equalToConstant: 28).isActive = true
            previousCell = cell
        }

        // initial updates

        updateValueLabels()
        updateTargetViewGeometry()
    }

    // MARK: - helpers

    private func addSliderCell(title: String, initialValue: Float, minValue: Float, maxValue: Float, valueChangedAction: Selector, outerValueLabel: inout UILabel?, bold: Bool = false) -> UIView {
        let cell = UIView()
        cell.translatesAutoresizingMaskIntoConstraints = false

        let font = bold ? UIFont.boldSystemFont(ofSize: 13) : UIFont.systemFont(ofSize: 13)

        let titleLabel = UILabel()
        titleLabel.font = font
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        cell.addSubview(titleLabel)

        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: valueChangedAction, for: .valueChanged)
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = initialValue
        slider.setThumbImage(UIImage(named: "Thumb"), for: .normal)
        cell.addSubview(slider)

        let valueLabel = UILabel()
        valueLabel.font = font
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textAlignment = .right
        cell.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),

            slider.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            slider.centerYAnchor.constraint(equalTo: cell.centerYAnchor),

            valueLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: -5),
            valueLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5),
            valueLabel.widthAnchor.constraint(equalToConstant: 75),
        ])
        outerValueLabel = valueLabel
        return cell
    }

    // MARK: - handlers

    @objc private func handleBoundsX(_ sender: UISlider) {
        state.bounds.origin.x = CGFloat(sender.value).rounded()
    }

    @objc private func handleBoundsY(_ sender: UISlider) {
        state.bounds.origin.y = CGFloat(sender.value).rounded()
    }

    @objc private func handleBoundsWidth(_ sender: UISlider) {
        state.bounds.size.width = CGFloat(sender.value).rounded()
    }

    @objc private func handleBoundsHeight(_ sender: UISlider) {
        state.bounds.size.height = CGFloat(sender.value).rounded()
    }

    @objc private func handleCenterX(_ sender: UISlider) {
        state.center.x = CGFloat(sender.value).rounded()
    }

    @objc private func handleCenterY(_ sender: UISlider) {
        state.center.y = CGFloat(sender.value).rounded()
    }

    @objc private func handleAnchorPointX(_ sender: UISlider) {
        state.anchorPoint.x = CGFloat(sender.value)
    }

    @objc private func handleAnchorPointY(_ sender: UISlider) {
        state.anchorPoint.y = CGFloat(sender.value)
    }

    @objc private func handleScale(_ sender: UISlider) {
        state.scale = CGFloat(sender.value)
    }

    @objc private func handleRotation(_ sender: UISlider) {
        state.rotation = CGFloat(sender.value).rounded()
    }

    // MARK: - updates

    private func updateValueLabels() {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal

        boundsXValueLabel?.text = (formatter.string(from: Decimal(state.bounds.origin.x) as NSNumber) ?? "") + " pt"
        boundsYValueLabel?.text = (formatter.string(from: Decimal(state.bounds.origin.y) as NSNumber) ?? "") + " pt"
        boundsWidthValueLabel?.text = (formatter.string(from: state.bounds.size.width as NSNumber) ?? "") + " pt"
        boundsHeightValueLabel?.text = (formatter.string(from: state.bounds.size.height as NSNumber) ?? "") + " pt"
        centerXValueLabel?.text = (formatter.string(from: state.center.x as NSNumber) ?? "") + " pt"
        centerYValueLabel?.text = (formatter.string(from: state.center.y as NSNumber) ?? "") + " pt"
        anchorPointXValueLabel?.text = (formatter.string(from: state.anchorPoint.x as NSNumber) ?? "") + " upt"
        anchorPointYValueLabel?.text = (formatter.string(from: state.anchorPoint.y as NSNumber) ?? "") + " upt"
        scaleValueLabel?.text = (formatter.string(from: state.scale as NSNumber) ?? "") + "x"
        rotationValueLabel?.text = (formatter.string(from: state.rotation as NSNumber) ?? "") + " deg"
    }

    private func updateTargetViewGeometry() {
        targetView.bounds = state.bounds
        targetView.center = state.center // same as targetView.center
        targetView.anchorPoint = state.anchorPoint
        targetView.transform = CGAffineTransform(scaleX: state.scale, y: state.scale).rotated(by: deg2rad(state.rotation))

        frameView.frame = targetView.frame

        let xPath = UIBezierPath()
        xPath.move(to: CGPoint(x: state.center.x, y: 0))
        xPath.addLine(to: state.center)
        xCenterLine.path = xPath.cgPath

        let yPath = UIBezierPath()
        yPath.move(to: CGPoint(x: 0, y: state.center.y))
        yPath.addLine(to: state.center)
        yCenterLine.path = yPath.cgPath

        let circleRadius: CGFloat = 8
        anchorPointCircle.path = UIBezierPath(ovalIn: CGRect(x: state.center.x - circleRadius, y: state.center.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)).cgPath

        // Double-check that the computeFrame function accurately replicates frame calculations in UIKit
        let uiKitCalculatedFrame = targetView.frame
        let ourCalculatedFrame = computeFrame(bounds: targetView.bounds, center: targetView.center, anchorPoint: targetView.anchorPoint, tranform: targetView.transform)

        assert(uiKitCalculatedFrame.nearlyEqual(ourCalculatedFrame), "\(uiKitCalculatedFrame) != \(ourCalculatedFrame)")
    }
}
