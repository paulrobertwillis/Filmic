//
//  LogOutput.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

// TODO: for prod/dev, can have different targets or a switch ...? By default, just use ifdebug.

protocol LogOutputProtocol {
    func write(_ string: String)
}

class ConsoleLogOutput: LogOutputProtocol {
    func write(_ string: String) {
        print(string)
    }
}

class FileLogOutput: LogOutputProtocol {
    func write(_ string: String) {
        // do later when want to do to file
    }
}

// MARK: - Check to see if OLG logs passwords and private keys?
