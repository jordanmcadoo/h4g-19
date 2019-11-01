import UIKit

class JobResultsViewController: UIViewController {
    let realView = JobResultsView()

    let testData = ["Software Engineer I", "UX Designer", "Project Manager", "Software Engineer II",
    "Senior Software Engineer", "Engineering Manager", "Software Engineer III", "Customer Service Agent"]
    var filteredData: [String]!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realView.tableView.dataSource = self
        realView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        realView.searchBar.delegate = self
        filteredData = testData
    }
}

extension JobResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
}

extension JobResultsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? testData : testData.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        realView.tableView.reloadData()
    }
}
