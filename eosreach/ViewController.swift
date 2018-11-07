//
//  ViewController.swift
//  eosreach
//
//  Created by Samuel Kirton on 06/11/2018.
//  Copyright © 2018 memtrip. All rights reserved.
//

import UIKit
import eosswift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // test eosswift framework has built correctly
        let transferArgs: TransferArgs = TransferArgs(
            from: AccountNameWriterValue(name: "memtripissue"),
            to: AccountNameWriterValue(name: "memtripblock"),
            quantity: AssetWriterValue(asset: "1.0123 SYS"),
            memo: "hello"
        )
        let transferBody = TransferBody(args: transferArgs)
        let hex = transferBody.toHex()
        print(hex)
    }
}
