import UIKit

private let postCellIdentifier = "postCell"
private let postCellNibName = "PostCell"

class PostsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var posts: [PostModel] = []
    var postIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.scrollToRow(at: postIndexPath, at: .top, animated: true)
    }
    
    func fetchData() {
        
        LocalDataManager.shared.asyncGetPosts { postModels in
            
            DispatchQueue.main.async {
                self.posts = postModels
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - TableView

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier) as! PostCell
        cell.setup(for: posts[indexPath.row])
        cell.postCellDelegate = self
        return cell
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibCell = UINib(nibName: postCellNibName, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: postCellIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: - SearchBar

extension PostsViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            fetchData()
            return
        }
        
        LocalDataManager.shared.asyncSearchPost(for: searchText) { postModels in
            
            DispatchQueue.main.async {
                self.posts = postModels
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - PostCell Delegate

extension PostsViewController: PostCellDelegate {
    
    func presentActionSheet(actionSheet: UIAlertController) {
        present(actionSheet, animated: true, completion: nil)
    }
    
    func reloadData() {
        fetchData()
    }
}
