//
//  StopWatch.swift
//  StopWatch_App
//
//  Created by Designer on 2023/07/10.
//

import UIKit

enum StopWatchType: String {
    case start = "START"   // 새로시작 -> STOP을 할 수 있음
    case stop  = "STOP"    // 멈춤(suspend) -> RESUME을 할 수 있음
    case resume = "RESUME" // 다시 진행 -> STOP을 할 수 있음
    case reset = "RESET"   // 완전 종료 초기화 -> START를 할 수 있음
    
}

enum LapResetType: String {
    case lap = "LAP"
    case reset = "RESET"
    case disable
}

class StopWatch {
    // 1. StopWatch 기능만 분리
        var timer: Timer?
        var startTime: Date?
        var middleStartTime: Date?
        var stopTime: Date?
        
        var showElapsedTime: ((String) -> Void)?
        var showElapsedMiddleTime: ((String) -> Void)?
    
        var stopwatchType = StopWatchType.reset {
            didSet {
                switch stopwatchType {
                case .start:
                    start()
                case .stop:
                    stop()
                case .resume:
                    resume()
                case .reset:
                    reset()
                }
            }
        }
    
        var lapResetType: LapResetType {
            switch stopwatchType {
            case .start:
                return .lap
            case .stop:
                return .reset
            case .resume:
                return .lap
            case .reset:
                return .disable
                
            }
        }
        var lapResetTitle: String {
            lapResetType.rawValue
        }
    
        var possableType: StopWatchType {
            switch stopwatchType {
            case .start:
                return .stop
            case .stop:
                return .resume
            case .resume:
                return .stop
            case .reset:
                return .start
            }
        }
    
        func runPossableType() {
            stopwatchType = possableType
        }
    
        func runPossableLeftType() -> LapResetType{
            if lapResetType == .reset {
                stopwatchType = .reset
//                timeLabel.text = "00:00.00"
            } else if lapResetType == .lap {
                lap()
            }
            return lapResetType
        }
    
        func possableButtonTitle() -> String {
            possableType.rawValue
        }
    
        func registTimer() {
            timer = Timer(timeInterval: 0.01, repeats: true, block: { _ in
                self.showElapsedTime?(self.elapsedTime())
                self.showElapsedMiddleTime?(self.elapsedMiddleTime())
            })
            RunLoop.current.add(timer!, forMode: .common)
        }
        
        func start() {
            startTime = Date()
            middleStartTime = startTime
            
            registTimer()
        }
        
        func stop() {
            stopTime = Date()
            timer?.invalidate()
            timer = nil
        }
        
        
        func resume() {
            if let elapsedStopTime = stopTime?.timeIntervalSinceNow {
                startTime = startTime?.addingTimeInterval(elapsedStopTime * -1)
                registTimer()
            }
        }

        func reset() {
            lapList.removeAll()
        }
        
        func lap() {
            lapList.insert(elapsedMiddleTime(), at: 0) // 항상 첫번째로 값을 추가
            middleStartTime = Date() // 초기화를 나중에 시켜야 데이터가 제대로 저장된다.
        }
        
        func elapsedTime() -> String{
            // 진행되는 시간을 화면에 표시
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm:ss.SS"
            
            // 진행된 시간 = 기준 시간 - 진행된 현재 시간
            let interval = (self.startTime?.timeIntervalSinceNow ?? 0) * -1
            let customDate = Date(timeIntervalSinceReferenceDate: interval)
            
            return dateFormatter.string(from: customDate)
        }
        
        func elapsedMiddleTime() -> String{
            // 진행되는 시간을 화면에 표시
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm:ss.SS"
            
            // 진행된 시간 = 기준 시간 - 진행된 현재 시간
            let interval = (self.middleStartTime?.timeIntervalSinceNow ?? 0) * -1
            let customDate = Date(timeIntervalSinceReferenceDate: interval)
            
            return dateFormatter.string(from: customDate)
        }
        
       
        
        var lapList = [String]()
}
