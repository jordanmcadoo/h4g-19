import UIKit
import MapKit

protocol FavoritesViewControllerDelegate: class {
    func favoritesViewController(_: FavoritesViewController, didSelectJob: Job)
}

class FavoritesViewController: UIViewController {
    private let realView = FavoritesView()
    weak var delegate: FavoritesViewControllerDelegate?
    var favorites: [Job] = []
    
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

        navigationItem.title = "Favorites"
        realView.tableView.dataSource = self
        realView.tableView.delegate = self
        realView.tableView.register(JobResultsCell.self, forCellReuseIdentifier: JobResultsCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favorites = JobFavorites.shared.favorites
        if favorites.count > 0 {
            realView.tableView.reloadData()
            realView.tableView.isHidden = false
            realView.noFavoritesView.isHidden = true
        } else {
            realView.tableView.isHidden = true
            realView.noFavoritesView.isHidden = false
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobResultsCell.reuseIdentifier) as! JobResultsCell
        let job = favorites[indexPath.row]
        
        // todo - save off user address. this is just using the eFactory.
        if let latDegree = CLLocationDegrees(exactly: 37.2119519), let lngDegree = CLLocationDegrees(exactly: -93.290407) {
            cell.setupWithJob(job, location: CLLocation(latitude: latDegree, longitude: lngDegree))
        }
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
      return 55
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    return UITableView.automaticDimension
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = favorites[indexPath.row]
        delegate?.favoritesViewController(self, didSelectJob: job)
    }
}
