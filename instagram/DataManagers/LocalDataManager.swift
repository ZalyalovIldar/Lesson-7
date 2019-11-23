import UIKit

class LocalDataManager: DataManagerProtocol {
    
    static let shared = LocalDataManager()
    
    private var posts: [PostModel] = Generator.getData()
    
    //MARK: - Save
    
    func syncSavePost(post: PostModel) {
        self.posts.append(post)
    }
    
    func asyncSavePost(post: PostModel, complition: @escaping () -> Void) {
        
        let queue = DispatchQueue.global()
        queue.async {
            self.posts.append(post)
            complition()
        }
    }
    
    //MARK: - Search
    
    func syncSearchPost(for searchString: String) -> [PostModel] {
        
        let searchedPosts = posts.filter { (PostModel) -> Bool in
            
            if let postText = PostModel.text {
                return postText.contains(searchString)
            }
            return false
        }
        return searchedPosts
    }
    
    func asyncSearchPost(for searchString: String, complition: @escaping (([PostModel]) -> Void)) {
        
        let queue = DispatchQueue.global()
        queue.async {
            let searchedPosts = self.posts.filter { (PostModel) -> Bool in
                
                if let postText = PostModel.text {
                    return postText.contains(searchString)
                }
                return false
            }
            complition(searchedPosts)
        }
    }
    
    //MARK: - Delete
    
    func syncDeletePost(with postID: String) {
        
        posts.removeAll { (PostModel) -> Bool in
            PostModel.id == postID
        }
    }
    
    func asyncDeletePost(with postID: String, complition: @escaping () -> Void) {
        
        let queue = DispatchQueue.global()
        queue.async {
            self.posts.removeAll { (PostModel) -> Bool in
                PostModel.id == postID
            }
            complition()
        }
    }
    
    //MARK: - Get
    
    func syncGetPosts() -> [PostModel] {
        return self.posts
    }
    
    func asyncGetPosts(complition: @escaping (([PostModel]) -> Void)) {
        let queue = DispatchQueue.global()
        queue.async {
            complition(self.posts)
        }
    }
}
