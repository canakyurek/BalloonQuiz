//
//  CountingLabel.swift
//  Balloon
//
//  Created by Can Akyurek on 11.06.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

enum CountingMethod {
    case easeInOut, easeIn, easeOut, linear
}

enum AnimationDuration {
    case laborious, plodding, strolling, brisk, none
    
    var value: TimeInterval {
        switch self {
        case .laborious: return 20.0
        case .plodding: return 15.0
        case .strolling: return 8.0
        case .brisk: return 2.0
        case .none: return 0.0
        }
    }
}

enum DecimalPoints {
    case zero, one, two, ridiculous
    
    var format: String {
        switch self {
        case .zero: return "%.0f"
        case .one: return "%.1f"
        case .two: return "%.2f"
        case .ridiculous: return "%f"
        }
    }
}


class CountingLabel: UILabel {

    typealias OptionalCallback = (() -> Void)
    typealias OptionalFormatBlock = (() -> String)
    
    var completion: OptionalCallback?
    var customFormatBlock: OptionalFormatBlock?
    var animationDuration: AnimationDuration = .brisk
    var decimalPoints: DecimalPoints = .zero
    var countingMethod: CountingMethod = .easeInOut
    
    private var rate: Float = 0
    private var startingValue: Float = 0
    private var destinationValue: Float = 0
    private var progress: TimeInterval = 0
    private var lastUpdate: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    private var easingRate: Float = 0
    private var timer: CADisplayLink?
    
    private var currentValue: Float {
        if progress >= totalTime { return destinationValue }
        return startingValue + (update(t: Float(progress / totalTime)) * (destinationValue - startingValue))
    }
    
    func count(from: Float, to: Float, duration: AnimationDuration = .strolling) {
        startingValue = from
        destinationValue = to
        timer?.invalidate()
        timer = nil
        
        if duration.value == 0.0 {
            setTextValue(to)
            completion?()
            return
        }
        
        easingRate = 3.0
        progress = 0.0
        totalTime = duration.value
        lastUpdate = Date.timeIntervalSinceReferenceDate
        rate = 3.0
        
        addDisplayLink()
    }
    
    func countFromCurrent(to: Float, duration: AnimationDuration = .strolling) {
        count(from: currentValue, to: to, duration: duration)
    }
    
    func countFromZero(to: Float, duration: AnimationDuration = .strolling) {
        count(from: currentValue, to: to, duration: duration)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        progress = totalTime
        completion?()
    }
    
    private func addDisplayLink() {
        timer = CADisplayLink(target: self, selector: #selector(self.updateValue(_:)))
        timer?.add(to: .main, forMode: .default)
        timer?.add(to: .main, forMode: .tracking)
    }
    
    @objc private func updateValue(_ timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdate
        lastUpdate = now
        
        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }
        
        setTextValue(currentValue)
        if progress == totalTime { completion?() }
    }
    
    private func update(t: Float) -> Float {
        var t = t
        
        switch countingMethod {
        case .linear:
            return t
        case .easeIn:
            return powf(t, rate)
        case .easeInOut:
            var sign: Float = 1
            if Int(rate) % 2 == 0 { sign = -1 }
            t *= 2
            return t < 1 ? 0.5 * powf(t, rate) : (sign * 0.5) * (powf(t-2, rate) + sign * 2)
        case .easeOut:
            return 1.0 - powf((1.0 - t), rate)
        }
    }
    
    private func setTextValue(_ value: Float) {
        text = String(format: customFormatBlock?() ?? decimalPoints.format, value)
    }
}
