//
//  SafeViewController.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class SafeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var coordinator: (SafeCoordinatorProtocol & SafeStateManagerProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTable()
    }

    func setupUI() {
        self.title = R.string.localizable.mine_safesetting.key.localized()

        let customNibName = R.nib.customCell.name
        tableView.register(UINib.init(nibName: customNibName, bundle: nil), forCellReuseIdentifier: customNibName)

        let switchNibName = R.nib.customSwitchCell.name
        tableView.register(UINib.init(nibName: switchNibName, bundle: nil), forCellReuseIdentifier: switchNibName)
    }

    func handleSwitch(_ indexPath: IndexPath, isOn: Bool) {
        switch indexPath.row {
        case 0:
            handleFaceIdOn(isOn)
        case 1:
            handleFingerPrinterOn(isOn)
        case 2:
            handleGestureOn(isOn)
        default:
            break
        }
    }

    func handleFaceIdOn(_ isOn: Bool) {
        if isOn != SafeManager.shared.isFaceIdOpened() {
            return
        }
        if !isOn {
            self.coordinator?.openFaceIdLock({[weak self] (_) in
                guard let `self` = self else { return }
                self.reloadTable()
            })
        } else {
            self.coordinator?.confirmFaceId({[weak self] (result) in
                guard let `self` = self else { return }
                if result {
                    self.coordinator?.closeFaceIdLock()
                }
                self.reloadTable()
            })
        }
    }

    func handleFingerPrinterOn(_ isOn: Bool) {
        if isOn != SafeManager.shared.isFingerPrinterLockOpened() {
            return
        }
        if !isOn {
            self.coordinator?.openFingerSingerLock({[weak self] (_) in
                guard let `self` = self else { return }
                self.reloadTable()
            })
        } else {
            self.coordinator?.confirmFingerSinger({[weak self] (result) in
                guard let `self` = self else { return }
                if result {
                    self.coordinator?.closeFingerSingerLock()
                }
                self.reloadTable()
            })
        }
    }

    func handleGestureOn(_ isOn: Bool) {
        if isOn != SafeManager.shared.isGestureLockOpened() {
            return
        }
        if !isOn {
            self.coordinator?.openGestureLock({[weak self] (_) in
                guard let `self` = self else { return }
                self.reloadTable()
            })
        } else {
            self.coordinator?.confirmGesture({[weak self] (result) in
                guard let `self` = self else { return }
                if result {
                    self.coordinator?.closeGetureLock()
                }
                self.reloadTable()
            })
        }
    }

    func reloadTable() {
        tableView.reloadData()
    }

    func titleWithIndexPath(_ indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0:
            return R.string.localizable.setting_face.key.localized()
        case 1:
            return R.string.localizable.setting_finger.key.localized()
        case 2:
            return R.string.localizable.setting_gesture.key.localized()
        default:
            return R.string.localizable.setting_change_password.key.localized()
        }
    }

    func isOnWithIndexPath(_ indexPath: IndexPath) -> Bool {
        switch indexPath.row {
        case 0:
            return SafeManager.shared.isFaceIdOpened()
        case 1:
            return SafeManager.shared.isFingerPrinterLockOpened()
        case 2:
            return SafeManager.shared.isGestureLockOpened()
        default:
            return false
        }
    }

    override func configureObserveState() {

    }
}

extension SafeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SafeManager.shared.isGestureLockOpened() ? 4 : 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            let switchNibName = R.nib.customSwitchCell.name
            guard let cell = tableView.dequeueReusableCell(withIdentifier: switchNibName, for: indexPath) as? CustomSwitchCell else {
                return UITableViewCell()
            }
            cell.title = titleWithIndexPath(indexPath)
            cell.isOn = isOnWithIndexPath(indexPath)
            cell.switchView.switchView.valueChange = {[weak self] (isOn) in
                guard let `self` = self else {return}
                self.handleSwitch(indexPath, isOn: isOn)
            }
            return cell
        } else {
            let customNibName = R.nib.customCell.name
            guard let cell = tableView.dequeueReusableCell(withIdentifier: customNibName, for: indexPath) as? CustomCell else {
                return UITableViewCell()
            }
            cell.title = titleWithIndexPath(indexPath)
            cell.subTitle = ""
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            self.coordinator?.confirmGesture({[weak self] (result) in
                guard let `self` = self else { return }
                if result {
                    self.coordinator?.openGestureLock({ (_) in
                        self.reloadTable()
                    })
                }
            })
        }
    }
}
