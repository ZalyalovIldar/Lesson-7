//
//  PostTableViewCell.swift
//  BlocksSwift
//
//  Created by Евгений on 08.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    
    var delegate: PostDeletingDelegate?
    var post: Post!
    
    
    /// Configures cell with the post
    /// - Parameter post: Post, with which cell need to be configured
    /// - Parameter delegate: Delegate to work with
    func configure(with post: Post, delegate: PostDeletingDelegate) {
        
        self.delegate = delegate
        self.post = post
        self.postImageView.image = UIImage(named: post.image)
        self.postTextLabel.text = post.text
        self.postDateLabel.text = post.date
        self.profileAvatarImageView.layer.cornerRadius = profileAvatarImageView.bounds.height / 2
    }
    
    //Editing button pressed
    @IBAction func editingButtonPressed(_ sender: Any) {
        delegate?.deletePost(post: post)
    }
}
