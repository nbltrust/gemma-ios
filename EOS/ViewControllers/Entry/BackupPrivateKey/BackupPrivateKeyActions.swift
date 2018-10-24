//
//  BackupPrivateKeyActions.swift
//  EOS
//
//  Created zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

// MARK: - State
struct BackupPrivateKeyState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: BackupPrivateKeyPropertyState
    var callback: BackupPrivateKeyCallbackState
}

struct BackupPrivateKeyPropertyState {
}

struct BackupPrivateKeyCallbackState {
    var hadSaveCallback: BehaviorRelay<CompletionCallback?> = BehaviorRelay(value: nil)
}

// MARK: - Action Creator
class BackupPrivateKeyPropertyActionCreate {
    public typealias ActionCreator = (_ state: BackupPrivateKeyState, _ store: Store<BackupPrivateKeyState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: BackupPrivateKeyState,
        _ store: Store <BackupPrivateKeyState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
