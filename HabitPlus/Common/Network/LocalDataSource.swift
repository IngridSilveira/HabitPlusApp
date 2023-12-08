//
//  LocalDataSource.swift
//  HabitPlus
//
//  Created by userext on 27/11/23.
//

import Foundation
import Combine

class LocalDataSource {
    
    static var shared: LocalDataSource = LocalDataSource()
    
    private init() {
    }

    private func saveValue(value: UserAuth) {
        // Objeto com propriedade standard, usado para armazenar algumas informações
        // Usamos o identificador unico, no caso user_key, para buscarmos ele de volta
        // Esse metodo lança uma excessão, por isso usamos o try pra ele tentar salvar o objeto, pode usar o try catch para tratar o erro.
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: "user_key")
    }
    
    private func readValue(forKey key: String) -> UserAuth? {
        var userAuth: UserAuth?
        
        // objeto "value" devolve any, entao fazemos um casting para converter o objeto pro tipo de dado que queremos trabalhar, no caso um data
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            // caso ele consiga devolver um data, vamos decodificar o UserAuth, e o modelo de dado decodificado(os bytes), vai ser o data
            userAuth = try? PropertyListDecoder().decode(UserAuth.self, from: data)
        }
        return userAuth
    }
}

extension LocalDataSource {
    
    func insertUserAuth(userAuth: UserAuth) {
        saveValue(value: userAuth)
    }

    func getUserAuth() -> Future<UserAuth?, Never> {
        let userAuth = readValue(forKey: "user_key")
        return Future { promise in
            promise(.success(userAuth))
        }
    }
}
