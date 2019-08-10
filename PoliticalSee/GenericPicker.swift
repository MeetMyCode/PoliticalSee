//
//  GenericPicker.swift
//  PoliticalSee
//
//  Created by Rossco on 09/04/2017.
//  Copyright © 2017 Coco. All rights reserved.
//

import UIKit

class GenericPicker: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray: [String]?
    var filteredDataArray: [String]?
    var statsVcRef: StatsAboutParliament?
    
    //TAG COMES FROM THE BUTTON THAT INITIATED THE SEGUE TO HERE (GENERIC PICKER). USED WHEN CALLING DIDSELECTROW.
    var buttonTagFromStats: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        GenericPickerTV.delegate = self
        GenericPickerTV.dataSource = self
        
        filteredDataArray = dataArray
    
    }
    
    
    //MARK: - ACTIONS AND OUTLETS
    
    
    @IBOutlet weak var GenericPickerTV: UITableView!
    
    
    //MARK: - TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filteredDataArray!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = GenericPickerTV.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredDataArray?[indexPath.row]
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        switch buttonTagFromStats! {
            
        case 0:
            statsVcRef?.SelectParliamentCrossSection.setTitle("\(text!)", for: .normal)
            statsVcRef?.SelectAnalysisButton.isHidden = false
            
            //SET/RESET OTHER TWO BUTTONS IN CASE YOU HAVE ALREADY DISPLAYED A GRAPH.
            statsVcRef?.SelectAnalysisButton.setTitle("Select Analysis", for: .normal)
            statsVcRef?.SelectChartType.setTitle("Select Chart Type", for: .normal)
            statsVcRef?.removePreviousChartView()
            
        case 1:
            statsVcRef?.SelectAnalysisButton.setTitle("\(text!)", for: .normal)
            statsVcRef?.SelectChartType.isHidden = false
            
            //SET/RESET CHART BUTTON IN CASE YOU HAVE ALREADY DISPLAYED A GRAPH.
            statsVcRef?.SelectChartType.setTitle("Select Chart Type", for: .normal)
            statsVcRef?.removePreviousChartView()
            
        case 2:
            let analysis = statsVcRef?.SelectAnalysisButton.titleLabel?.text
            let crossSection = statsVcRef?.SelectParliamentCrossSection.titleLabel?.text
            statsVcRef?.SelectChartType.setTitle("\(text!)", for: .normal)
            statsVcRef?.constructGraph(crossSection: crossSection!, analysisToDo: "\(analysis!)", chartType: text!)

            
        default:
            break
        }
        
        
        performSegue(withIdentifier: "unwindToStats", sender: text)
        
    }


    //MARK: - SEGUE METHODS
    
























}//END OD CLASS
