//
//  ViewController.swift
//  StopWatch_App
//
//  Created by Designer on 2023/07/05.
//

import UIKit

class ViewController: UIViewController {

    var stopwatch = StopWatch()
    var lapCell: LapCell?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton! {
        didSet{
//            makeCircleButton(btn: leftButton)
            makeCircleButton2(leftButton)
        }
    }
    @IBOutlet weak var rightButton: UIButton! {
        didSet{
//            makeCircleButton(btn: rightButton)
            makeCircleButton2(rightButton)
        }
    }
    
    let makeCircleButton2: (UIButton) -> Void = { btn in
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 100 / 2
    }
    
    func makeCircleButton(btn: UIButton) {
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 100 / 2
    }
    
    @IBOutlet weak var lapTableView: UITableView!
    
    @IBAction func lapOrReset(_ sender: Any) {
//        if stopwatch.lapResetType == .reset {
//            stopwatch.stopwatchType = .reset
//            timeLabel.text = "00:00.00"
//            lapTableView.reloadData()
//        } else if stopwatch.lapResetType == .lap {
//            stopwatch.lap()
//        }
        
        if stopwatch.runPossableLeftType() == .reset {
            timeLabel.text = "00:00.00"
        }
        
        lapTableView.reloadData()
        
        leftButton.setTitle(stopwatch.lapResetTitle, for: .normal)
        rightButton.setTitle(stopwatch.possableButtonTitle(), for: .normal)
    }
    @IBAction func startStopResume(_ sender: Any) {
        stopwatch.runPossableType()
        rightButton.setTitle(stopwatch.possableButtonTitle(), for: .normal)
        leftButton.setTitle(stopwatch.lapResetTitle, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Stopwatch"
        //        self.title = ""
        lapTableView.delegate = self
        lapTableView.dataSource = self
        
        self.view.backgroundColor = .systemGray6
        self.lapTableView.backgroundColor = .systemGray6
        
        rightButton.setTitle(stopwatch.possableButtonTitle(), for: .normal)
        
        stopwatch.showElapsedTime = { time in
            self.timeLabel.text = time
        }
        stopwatch.showElapsedMiddleTime = { time in
            if self.lapCell?.rememberRow == 0 {
                self.lapCell?.rightLabel.text = time
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
            
        return stopwatch.lapList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapCell", for: indexPath) as! LapCell
        
        cell.rememberRow = indexPath.row
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.lapCell = cell
            }
            
            cell.leftLabel.text = "LAP ." + (stopwatch.lapList.count + 1).description
            if stopwatch.lapList.count == 0 {
                cell.rightLabel.text = "00:00.00"
            }
            
        }else if indexPath.section == 1 {
            cell.rightLabel.text = "+" + stopwatch.lapList[indexPath.row]
            cell.leftLabel.text = "LAP ." + (stopwatch.lapList.count - indexPath.row).description
        }
        
        return cell
    }
    
    
}
