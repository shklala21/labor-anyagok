import Fortress
import MapKit
import UIKit

class FortressDetailViewController: UITableViewController {

    private let animationDuration = 0.2
    private var fortress: Fortress?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Trash gomb létrehozása

        // Szorgalmi: Spring Loading beállítása a Trash gombra

        // Szorgalmi: Drag interaction hozzáadása az Image View-hoz

        // Drop delegate beállítása

        positionMapViewToHungary()
    }

    private func refreshView(with fortress: Fortress) {
        self.fortress = fortress
        navigationItem.title = fortress.name

        // Hiányzó két sor

        let annotation = MKPointAnnotation()
        annotation.title = fortress.name
        annotation.coordinate = fortress.coordinates
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: fortress.coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000), animated: true)
    }

    @objc private func clearView() {
        fortress = nil

        navigationItem.title = nil
        imageView.image = nil
        descriptionTextView.text = nil

        mapView.removeAnnotations(mapView.annotations)
        positionMapViewToHungary()
    }

    // Moves center of the MapView to Hungary 🇭🇺
    private func positionMapViewToHungary() {
        let hungaryCoordinates = CLLocationCoordinate2D(latitude: 47, longitude: 19)
        mapView.setRegion(MKCoordinateRegion(center: hungaryCoordinates, latitudinalMeters: 400000, longitudinalMeters: 400000), animated: true)
    }
}
