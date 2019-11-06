//
//  FriendViewModelFactory.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 06.11.2019.
//  Copyright © 2019 Vladimir Bozhenov. All rights reserved.
//

import Foundation

final class FriendViewModelFactory {
    
    func constructViewModels(from users: [User]) -> [FriendViewModel] {
        return users.compactMap(self.viewModel)
    }
    
    private func viewModel(from user: User) -> FriendViewModel {
        
        let name = "\(user.lastName) \(user.firstName)"
        let avatar = user.avatar ?? ""
        
        return FriendViewModel(name: name, avatar: avatar)
    }
}
