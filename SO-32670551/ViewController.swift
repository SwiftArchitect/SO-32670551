//
//  ViewController.swift
//  SO-32670551
//
//  Copyright © 2017 Xavier Schott
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

    class TapOverlayView: UIView {
        var centroid:CGRect = CGRect.zero

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            centroid = CGRect(origin: point, size: CGSize(width: 1, height: 1))
            return nil // tap through
        }
    }

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tap: TapOverlayView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "SO-32670551", ofType: "pdf")
        let url = URL(fileURLWithPath: path!, isDirectory: false)
        let request = URLRequest(url: url)

        webView.loadRequest(request)
    }
}

    extension ViewController: UIWebViewDelegate {
        public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            let rqstUrl = request.url

            if( rqstUrl!.scheme?.contains("http"))! && ( .linkClicked == navigationType) {
                webView.stopLoading()

                let contentViewController = storyboard!.instantiateViewController(withIdentifier: "popover")
                let popController = UIPopoverController(contentViewController: contentViewController)
                contentViewController.modalPresentationStyle = .popover
                popController.contentSize = CGSize(width: 200, height: 40)
                let direction:UIPopoverArrowDirection = .down
                popController.layoutMargins = UIEdgeInsetsMake(0, tap.centroid.origin.x, 1, 1)
                popController.present(from: tap.centroid,
                                      in: webView,
                                      permittedArrowDirections: direction,
                                      animated: true)
            }
            return true
        }
    }

