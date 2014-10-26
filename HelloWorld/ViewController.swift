//
//  ViewController.swift
//  HelloWorld
//
//  Created by Chris Young on 10/23/14.
//  Copyright (c) 2014 Chris Young. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var appsTableView : UITableView?
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getIndex()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.textLabel.text = rowData["name"] as? String
        cell.imageView.image = UIImage(data: imageFromRow(rowData))
        
        return cell
    }
    
    func imageFromRow(rowData: NSDictionary) -> NSData{
        let images = rowData["images"] as NSArray
        let image = images[0] as NSDictionary
        let urlString = image["url"] as NSString
        let imgURL: NSURL = NSURL(string: urlString)!
        return NSData(contentsOfURL: imgURL)!
    }
    
    func getIndex() {
        let url: NSURL = NSURL(string: "http://www.tanga.com/deals/front-page.json")!

        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if(error != nil) { println(error.localizedDescription) }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = self.parse(data)
                self.appsTableView!.reloadData()
            })

        }).resume()
    }
    
    func parse(data: NSData) -> NSArray {
        return JSON(data: data).object as NSArray
    }
}

