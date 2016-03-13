/*
The MIT License (MIT)

Copyright (c) 2016 Forrest Collins

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/



/*                                              TUTORIAL

    STEP 1: Add a textfield, tableview, and label to your storyboard.

    STEP 2: Create a text file of a list of items in TextEdit with the format >
            "Make Plain Text" with each item on its own line. Text files will
            store the autocomplete words to appear when searching.

    OPTIONAL: You may create multiple text files if you wish.
              I created 2 .txt files. One for fruit and one for vegetables.

    STEP 3: Use the same logic code below for my autocomplete functionality or
            adjust your existing code to your preferences.
*/

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var autocompleteLabel: UILabel!
    @IBOutlet weak var autocompleteTextfield: UITextField!
    @IBOutlet weak var autocompleteTableview: UITableView!
    
    // autocomplete arrays
    var fileWords = [String]()
    var autocompleteWords = [String]()
    
    //----------------------
    // MARK: - View Did Load
    //----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteTextfield.delegate = self
        autocompleteTableview.delegate = self
        autocompleteTableview.dataSource = self
        
        // hide empty tableview cells
        let backgroundView = UIView(frame: CGRectZero)
        autocompleteTableview.tableFooterView = backgroundView
        autocompleteTableview.separatorColor = UIColor.clearColor()
        autocompleteTableview.backgroundColor = UIColor.clearColor()
        autocompleteTableview.separatorStyle = .None
        
        // add elements of .txt files to appear for autocomplete
        addTextFiles(["fruit", "vegetables"])
    }
    
    //------------------------------------------
    // MARK: - Should Change Characters in Range
    //------------------------------------------
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == autocompleteTextfield {
            
            let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)

            searchAutocompleteWordsWithSubstring(substring)
            
            autocompleteTableview.reloadData()
        }
        
        return true
    }
    
    //-------------------------------------------------
    // MARK: - Search Autocomplete Words with Substring
    //-------------------------------------------------
    func searchAutocompleteWordsWithSubstring(substring: String)
    {
        // clean up array
        autocompleteWords.removeAll(keepCapacity: false)
        
        for word in fileWords
        {
            let myString: NSString! = word as NSString
            
            // do a case insensitive search for words in the .txt files
            let substringRange:NSRange! = myString.rangeOfString(substring, options: .CaseInsensitiveSearch)
            
            if (substringRange.location == 0)
            {
                autocompleteWords.append(word)
            }
        }
        
        autocompleteTableview!.reloadData()
    }
    
    //----------------------------------
    // MARK: - Number of Rows in Section
    //----------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteWords.count
    }
    
    //-----------------------------------
    // MARK: - Cell for Row at Index Path
    //-----------------------------------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: "Cell")
        
        // make autocomplete cell text appear bold for the characters typed in
        let item = autocompleteWords[indexPath.row]
        let text = NSMutableAttributedString(string: item)
        let font = UIFont.boldSystemFontOfSize(cell.textLabel!.font.pointSize)
        text.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: autocompleteTextfield.text!.characters.count + 1))
        cell.textLabel!.attributedText = text
        
        cell.textLabel?.textColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        
        // no background color or selection style for cells
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        return cell
    }
    
    //-------------------------------------
    // MARK: - Did Select Row at Index Path
    //-------------------------------------
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pickedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        autocompleteTextfield.text = pickedCell.textLabel!.text
        autocompleteLabel.text = pickedCell.textLabel!.text
    }
    
    //-------------------------------------------------
    // MARK: - Add Text File Data to Autocomplete Field
    //-------------------------------------------------
    func addTextFiles(textFiles: [String]) {
        
        for textFile in textFiles {
            
            let path = NSBundle.mainBundle().pathForResource(textFile, ofType: "txt")!
            
            let content = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            
            fileWords.appendContentsOf(content.componentsSeparatedByString("\n"))
        }
    }
}

