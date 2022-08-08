//
//  ViewController.swift
//  demoApp
//
//  Created by Saiefeddine HAYOUNI on 02/08/2022.
//

import UIKit
import FileDownloads

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var downloadsList: DownloadsList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadsList.model = DownloadsListModel(maxConcurrentOperationCount: 2)
    }

    @IBAction func startDownload(_ sender: Any) {
//        ["https://source.unsplash.com/random/4000x4000",
//         "https://www.pexels.com/fr-fr/photo/photo-de-vue-sur-la-montagne-brune-et-verte-842711/",
//         "https://images.unsplash.com/photo-1657540387976-b44d4c25cc07?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=4000&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY1OTcxMjIyOQ&ixlib=rb-1.2.1&q=80&w=4000",
//         "https://images.unsplash.com/photo-1658178082942-4726f1099f25?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=4000&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY1OTcxMjIyNw&ixlib=rb-1.2.1&q=80&w=4000"]
        if let urlString = textField.text,
           let url = URL(string: urlString) {
            downloadsList.startDownload(for: url)
        }
    }
    
}
 
