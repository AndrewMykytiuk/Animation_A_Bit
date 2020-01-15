//
//  PopUpViewController.swift
//  AnimationX
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

protocol PopUpViewControllerDelegate: class {
    func getInfo(_ info:String, numberInArray:Int)
}

class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PopUpTableView: UITableView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var data: [String] = []
    var lastChoosenResults: [String] = []
    var numberInArray: Int = 0
    
    weak var delegate:PopUpViewControllerDelegate?
    
    //MARK: - Lifecycle
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.layer.cornerRadius = 5
        buttonView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    //MARK: - Actions
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        
        if lastChoosenResults.count > 0 {
            
            delegate?.getInfo(lastChoosenResults.last!, numberInArray: numberInArray)
            
            self.view.removeFromSuperview()
        }
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCellBy(cellClass: InfoTableViewCell.self, indexPath: indexPath)
        
        cell.infoLabel.text = data[indexPath.row]
        
        if lastChoosenResults.contains(data[indexPath.row]) {
            let cellX = PopUpTableView.cellForRow(at: indexPath) as! InfoTableViewCell
            cellX.chooseButton.backgroundColor = UIColor(red: 0, green: 122, blue: 256, alpha: 1)
            self.view.layoutIfNeeded()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = PopUpTableView.cellForRow(at: indexPath) as! InfoTableViewCell
        
        numberInArray = indexPath.row
        
        PopUpTableView.deselectRow(at: indexPath, animated: true)
        
        cell.chooseButton.layer.borderWidth = 10
        self.view.layoutIfNeeded()
        
        if lastChoosenResults.contains(data[indexPath.row]) {
            cell.chooseButton.layer.borderWidth = 1
            var count = 0
            for i in lastChoosenResults {
                
                if i == data[indexPath.row]
                {
                    
                    lastChoosenResults.remove(at: count)
                    
                }
                count += 1
            }
        } else {
            lastChoosenResults.append(data[indexPath.row])
        }
        
    }
    
}
