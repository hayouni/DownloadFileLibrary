//
//  DownloadsCell.swift
//  FileDownloads
//
//  Created by Saiefeddine HAYOUNI on 04/08/2022.
//

import UIKit

public class DownloadsCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progress: UILabel!
    private var indexPath: IndexPath?

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    // MARK: - Constants

    struct K {
        static let pausedButton = "paused"
        static let canceledButton = "canceled"
    }
    // MARK: - Closure
    var onPause: ((IndexPath?) -> Void)?
    var onStop: ((IndexPath?) -> Void)?
    var onResume: ((IndexPath?) -> Void)?

    // MARK: - Configurations
    func configCell(download: Download, indexPath: IndexPath) {
        self.indexPath = indexPath
        title.text = download.url.absoluteString
        update(state: download.state, progress: download.pourcentage)
        updateButton(download: download)
    }
    
    @IBAction func pauseDownload(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        onPause?(indexPath)
    }
    
    @IBAction func cancelDownload(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        onStop?(indexPath)
    }
    
    @IBAction func resumeDownload(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        onResume?(indexPath)
    }
    
    /// update UI
    /// - Parameter download: Download
    func updateDisplay(download: Download) {
        update(state: download.state, progress:"\(download.pourcentage)")
        updateButton(download: download)
    }
    /// update Button UI
    /// - Parameter download: Download
    func updateButton(download: Download)  {
        let pauseDownload: Bool = download.state == .pause
        let cancelDownload: Bool = download.state == .cancel
        let finishDownload: Bool = download.state == .done
        pauseButton.isHidden = pauseDownload || cancelDownload || finishDownload
        resumeButton.isHidden = !pauseDownload || cancelDownload || finishDownload
        cancelButton.isHidden = finishDownload
    }
    /// update progress UI
    /// - Parameter state: DownloadState
    /// - Parameter progress: String
    func update(state: DownloadState, progress: String) {
        switch state {
        case .start,.resume:
            self.progress.text = progress
        case.pause:
            self.progress.text = K.pausedButton
        case.cancel:
            self.progress.text = K.canceledButton
        default:
            return
        }
    }
 
}
