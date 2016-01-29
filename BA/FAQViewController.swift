//
//  FAQViewController.swift
//  BA
//
//  Created by Felizia Bernutz on 22.12.15.
//  Copyright © 2015 Felizia Bernutz. All rights reserved.
//

import UIKit

class FAQViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var questionsLabel: UILabel?
    @IBOutlet weak var answersLabel: UILabel?
    
    lazy var filteredTableData = [FAQ]()
    lazy var resultSearchController = UISearchController(searchResultsController: nil)
    lazy var faq = FAQModel().provideFAQs()
    
    private var showAnswers : [Bool] = [false, false, false, false, false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FAQ"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // Set up search controller
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        tableView.tableHeaderView = resultSearchController.searchBar
        
        // Reload the table
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return self.filteredTableData.count
        }
        else {
            return faq.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FAQCell
        
        if resultSearchController.active {
            cell.questionLabel?.text = filteredTableData[row].question
            cell.answerLabel?.text = filteredTableData[row].answer
            return cell
        }
        else {
            cell.questionLabel?.text = faq[row].question
            cell.answerLabel?.text = faq[row].answer
//            cell.setCollapsed(!showAnswers[row])
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*
        //TODO: show answers and hide answers
        let index = indexPath.row
        
        tableView.beginUpdates()
        showAnswers[index] = !showAnswers[index]
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
        
        var cellRect = tableView.rectForRowAtIndexPath(indexPath)
        cellRect = tableView.convertRect(cellRect, toView: tableView.superview)
        let completelyVisible = CGRectContainsRect(tableView.frameForAlignmentRect(CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height-100)), cellRect)
        
        if !completelyVisible {
            // Scroll to the bottom of selected cell when expanded
            let delay = 0.1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(time, dispatch_get_main_queue(), {
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            })
        }
        
        */
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //TODO: SectionHeader
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")
//        return headerCell
//    }
    
    
    //MARK: - Search Controller
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
        filteredTableData = faq.filter{
            let stringMatch = (($0.question.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString) != nil) || ($0.answer.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)) != nil)
            return stringMatch ? true: false
        }
        
        self.tableView.reloadData()
    }
}
