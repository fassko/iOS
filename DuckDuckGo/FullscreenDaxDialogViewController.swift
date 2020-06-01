//
//  FullscreenDaxDialogViewController.swift
//  DuckDuckGo
//
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

protocol FullscreenDaxDialogDelegate: NSObjectProtocol {

    func hideDaxDialogs(controller: FullscreenDaxDialogViewController)

}

class FullscreenDaxDialogViewController: UIViewController {

    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    weak var daxDialogViewController: DaxDialogViewController?
    weak var delegate: FullscreenDaxDialogDelegate?

    var spec: DaxDialogs.BrowsingSpec?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        daxDialogViewController?.cta = spec?.cta
        daxDialogViewController?.message = spec?.message
        daxDialogViewController?.onTapCta = dismissCta
        containerHeight.constant = spec?.height ?? 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        daxDialogViewController?.start()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.destination is DaxDialogViewController {
            daxDialogViewController = segue.destination as? DaxDialogViewController
        }
    }

    @IBAction func onTapHide() {
        dismiss(animated: true)
        delegate?.hideDaxDialogs(controller: self)
    }
    
    private func dismissCta() {
        dismiss(animated: true)
    }
    
}

extension TabViewController: FullscreenDaxDialogDelegate {

    func hideDaxDialogs(controller: FullscreenDaxDialogViewController) {

        let controller = UIAlertController(title: "Hide remaining tips?",
                                           message: "There are only a few, and we tried to make them informative.",
                                           preferredStyle: isPad ? .alert : .actionSheet)

        controller.addAction(title: "Hide tips forever", style: .default) {
            DaxDialogs().dismiss()
        }
        controller.addAction(title: "Cancel", style: .cancel)
        present(controller, animated: true)
    }

}
