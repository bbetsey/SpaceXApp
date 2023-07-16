//
//  RocketsViewController.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 11.07.23.
//

import UIKit
import RxSwift

final class RocketsViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkService.shared.get(dataType: [Launch].self, apiRequest: LaunchRequest(rocketID: "falcon1"))
            .subscribe(
                onSuccess: { rockets in
                    print(rockets)
                }, onFailure: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }

}
