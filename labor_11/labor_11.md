# `iOS` alapú szoftverfejlesztés - Labor `11`

## A laborsegédletet összeállította
* Kelényi Imre - imre.kelenyi@aut.bme.hu
* Kántor Tibor - tibor.kantor@autsoft.hu
* Blázovics László - blazovics.laszlo@aut.bme.hu
* Krassay Péter - peter.krassay@autsoft.hu

## A labor témája

* [Messenger](#messenger)
    * [Pozíció lekérdezése](#pozicio-lekerdezese)
    * [Pozíció csatolása az üzenethez](#pozicio-csatolasa-az-uzenethez)
    * [`MapView` megjelenítés](#mapview-megjelnites)
* [Önálló feladatok](#onallo-feladatok)

## Messenger <a id="messenger"></a>

> Másoljuk a `res/` mappában lévő **`Messenger`** kezdőprojektet a `labor_11/` mappánkba! Ez lényegében az előző labor során kidolgozott projekt.

![](img/01_start.png)

A főbb változások az előző verzióhoz képest, hogy a `MessagesViewController` alján megjelent egy `UIToolBar` rajta egy **Map** feliratú gombbal, illetve az üzenet létrehozó nézeten megjelent egy `UILabel` **Pending** felirattal. Ez a nézet fogja jelezni, hogy sikerült-e a feladó koordinátáját lekérdezni. Ezen kívül a `ComposeMessageViewController`ben megjelent egy `CLLocation` property, ami a pozíciót fogja majd tárolni. 

> Próbáljuk ki az alkalmazást és nézzük át a forráskódját! 

### Pozíció lekérdezése <a id="pozicio-lekerdezese"></a>
> Készítsünk el egy osztályt, mely segítségével le tudjuk kérdezni az aktuális pozíciónkat. Ehhez hozzuk létre a `LocationManager` nevű, `NSObject`ből származó osztályunkat!

Ahhoz, hogy az osztály értesítéseket kapjon a pozícióval kapcsolatban, implementálni kell a `CLLocationManagerDelegate` protokolt. Ahogy az a kódban is látható, az osztálynak ehhez importálnia kell a `CoreLocation` modult.

> Hozzunk létre 
>
> * egy `CLLocation` típusú, **lastLocation** nevű property-t, ami a legutolsó ismert pozíciót fogja tárolni,
> * egy `NSTimer` típusú, **timeoutTimer** nevű property-t,
> * egy closure-t, **locationUpdated** névvel, hogy értesíteni tudjuk a pozícióra várakozó objektumainkat a pozíció változásáról (ennek értéket a hívó fél ad a `startLocationManager` meghívásakor),
> * egy `CLLocationManager` típusú, **locationManager** nevű property-t!

```swift
import CoreLocation
import Foundation

class LocationManager: NSObject {

  var lastLocation: CLLocation?
  var timeoutTimer: Timer?
  var locationUpdated: (()->())!
  var locationManager: CLLocationManager!

}

extension LocationManager: CLLocationManagerDelegate {

}
```

> Implementáljuk a szükséges függvényeket!

A pozíció lekérdezés indítását a következő függvény végzi. Ha nem történik érdemi esemény, `15` másodperc után leáll a pozíció lekérdezése.

```swift
func startLocationManager(updated: @escaping ()->()) {

  locationUpdated = updated

  locationManager = CLLocationManager()
  locationManager.requestWhenInUseAuthorization()
  locationManager.delegate = self
  locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

  timeoutTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(LocationManager.stopLocationManager), userInfo: nil, repeats: false)

  locationManager.startUpdatingLocation()
}
```

Ha időközben érkezik frissítés, akkor az alábbi függvény le fogja kezelni.

```swift
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  guard let newLocation = locations.last else {
    return
  }

  if -newLocation.timestamp.timeIntervalSinceNow > 5.0 {
    return
  }

  if newLocation.horizontalAccuracy < 0 {
    return
  }

  if lastLocation == nil || lastLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
    lastLocation = newLocation

    if newLocation.horizontalAccuracy <= manager.desiredAccuracy {
      stopLocationManager()
    }
  }
}
```

> Ezután írjuk meg a hibakezelő delegate metódust. Ha nem tudta meghatározni a pozíciónkat, akkor állítsuk meg a frissítést!

```swift
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  stopLocationManager()
  print(error.localizedDescription)
}
```

> Majd implementáljuk azt a metódust, mely ténylegesen leállítja a frissítési folyamatot!

```swift
func stopLocationManager() {
  if let timer = timeoutTimer {
    timer.invalidate()
  }

  locationManager.stopUpdatingLocation()
  locationUpdated()
}
```

> Végül adjuk hozzá az `Info.plist` fájlban az alábbi kulcsot **Privacy - Location When In Use Usage Description** (`NSLocationWhenInUseUsageDescription`)!

![](img/02_location_when_in_use.png)

Értéknek bármi megadható, de vigyázzunk, mert ezt fogja a felhasználó először elolvasni, amikor engedélyt kér az alkalmazás tőle.

### Pozíció csatolása az üzenethez <a id="pozicio-csatolasa-az-uzenethez"></a>

> Térjünk rá a `ComposeMessageViewController` kiegészítésére! Először vegyünk fel egy `LocationManager` típusú property-t az osztályban és inicializáljuk is!

```swift
var locationManager = LocationManager()
```

> Ezután valósítsuk meg az aktuális pozíció tárolásáért felelős részeket. Indítsuk el/állítsuk le a frissítést, amikor szükséges és implementáljuk a megfelelő closure-t a pozíció frissítéshez!

```swift
// MARK: - View Lifecycle

override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)

  locationManager.startLocationManager {
    if let location = self.locationManager.lastLocation {
      self.location = location
      self.coordinateLabel.text = "\(location.coordinate.latitude) " + "\(location.coordinate.longitude)"
    }
  }
  coordinateLabel.text = "Pending"
}

override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)

  locationManager.stopLocationManager()
}
```

> Ahhoz, hogy a koordinátákat ténylegesen fel is küldjük a szervernek, a `MessagesViewController`ben egészítsük ki a `composeMessageViewControllerDidSend(_:)` metódust a koordinátánk felküldésével!

```swift
if let location = viewController.location {
  message["latitude"] = location.coordinate.latitude
  message["longitude"] = location.coordinate.longitude
}
```

> Teszteljük az alkalmazást!

###  `MapView` megjelenítés <a id="mapview-megjelnites"></a>
> Hogy meg is tudjuk nézni az egyes, helyhez kötött üzeneteket, hozzunk létre egy `MapViewController` nevű osztályt, ami a `UIViewController`ből származik.

<!--  -->
> A `Main.storyboard`ban tegyünk a `MapViewController` `view`-jába egy teljes nézetet betöltő `MKMapView`-t, majd kössük be egy `Outlet`tel a `MapViewController`be **mapView** néven.

![](img/03_mapview_vc.png) ![](img/04_mapview_object.png)

> Ne felejtsük el az újonnan hozzáadott `MKMapView`-nak beállítani a tartalmazó `ViewController`t, mint delegate-et!

![](img/05_mapview_delegate.png)

> Miután ez megvan, térjünk vissza az osztály forrásához, importáljuk a `MapKit` modult! Adjunk továbbá hozzá egy property-t, ami majd a megjelenítendő üzeneteinket fogja tartalmazni,  illetve jelezzük, hogy meg fogjuk valósítani az `MKMapViewDelegate`-et (`extension`)!

```swift
import MapKit
import UIKit

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  var messages = [Any]()

}

extension MapViewController: MKMapViewDelegate {

}
```

> A `Main.storyboard`ban hozzunk létre egy **MapSegue** nevű **Show** `segue`-t, amivel a **Map** gombra kattintva betölthetjük a térképet. A navigation bar *title*-je legyen **Map**!

<!--  -->
> Ezután menjünk át a `MessagesViewController`be és készítsük fel a térkép betöltésére: egészítsük ki a `prepare(for:sender:)` metódust!

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if segue.identifier == "ComposeMessageSegue" {
    let vc = segue.destination as? ComposeMessageViewController
    vc?.delegate = self
  }
  else if segue.identifier == "MapSegue" {
    let vc = segue.destination as? MapViewController
    vc?.messages = messages
  }
}
```

> Teszteljük az alkalmazást!

Látható, hogy a térkép betöltődött, ugyanakkor nincs rajta semmi.

> Ezt megoldandó, hozzunk létre egy új `NSObject`ből leszármazó osztályt, `MessageAnnotation` névvel, ami megvalósítja az `MKAnnotation` protokolt!

```swift
import MapKit
import UIKit

class MessageAnnotation: NSObject {

  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?

  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }

}

extension MessageAnnotation: MKAnnotation { }
```

> Ha ez kész, akkor térjünk vissza a `MapViewController`be és tegyük lehetővé, hogy a térképen megjelenjenek az üzenetek!

<!--  -->
> Először is adjuk hozzá az üzeneteket a térképhez `annotation` formában!

```swift
// MARK: - View Lifecycle

override func viewDidLoad() {
  super.viewDidLoad()

  for case let message as [String: Any] in messages {
    let coordinate = CLLocationCoordinate2D(latitude: message["latitude"] as! Double, longitude: message["longitude"] as! Double)
    let title = "\(message["to_user"] as! String) \(message["from_user"] as! String)"
    let subtitle = message["topic"] as! String

    let annotation = MessageAnnotation(coordinate: coordinate, title: title, subtitle: subtitle)
    mapView.addAnnotation(annotation)
  }
}
```

> Futtassuk az alkalmazást!

<!--  -->
> Az annotációk mellett adjunk hozzá egy törtvonalat (`MKPolyLine`) is a térképhez úgy, hogy minden üzenet legyen egymás után sorban összekötve. Ehhez először hozzunk létre egy koordinátákat tartalmazó tömböt, amivel létrehozzuk a törtvonalat, majd adjuk hozzá a törtvonalat a `mapView`-hoz, mint *overlay*!

```swift
// MARK: - View Lifecycle

override func viewDidLoad() {
  super.viewDidLoad()

  var coordinates = [CLLocationCoordinate2D]()

  for case let message as [String: Any] in messages {
    guard let latitude = message["latitude"] as? Double, latitude != 0, let longitude = message["longitude"] as? Double, longitude != 0 else {
      continue
    }

    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let title = "\(message["to_user"] as! String) \(message["from_user"] as! String)"
    let subtitle = message["topic"] as! String

    let annotation = MessageAnnotation(coordinate: coordinate, title: title, subtitle: subtitle)
    mapView.addAnnotation(annotation)

    coordinates.append(coordinate)
  }

  let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
  mapView.add(polyline)
}
```

> Ezután implementáljuk a következő delegate metódust, hogy ki is legyen rajzolva a törtvonal!

```swift
func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
  if overlay is MKPolyline {
    let line = MKPolylineRenderer(overlay: overlay)
    line.strokeColor = UIColor.blue
    line.lineWidth = 2

    return line
  }

  return MKPolylineRenderer()
}
```

Látható, hogy most már szépen megjelennek az üzenetek és az azokat összekötő vonal, ugyanakkor nem tudjuk betölteni a teljes tartalmukat.

> Ehhez valósítsuk meg a következő delegate metódust, aminek a segítségével testreszabhatjuk a megjelenő annotation kinézetét és viselkedését!

```swift
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
  if annotation is MessageAnnotation {
    let reusableId = "MessangerAnnotationID"
    var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableId) as? MKPinAnnotationView

    if pinAnnotationView == nil {
      pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusableId)
      pinAnnotationView?.pinTintColor = UIColor.green
      pinAnnotationView?.canShowCallout = true

      let calloutButton = UIButton(type: .detailDisclosure)
      pinAnnotationView?.rightCalloutAccessoryView = calloutButton
    }
    else {
      pinAnnotationView?.annotation = annotation
    }

    return pinAnnotationView
  }

  return nil
}
```

> Implementáljuk az előbb hozzáadott gomb eseménykezelőjét! 

A gomb megnyomására először lekérdezzük az adott üzenet koordinátáját, majd a beépített reverse geocoding szolgáltatás segítségével megkapjuk a pontos címét is a küldés helyének.

Ezután létrehozunk egy két `MKMapItem`ből álló tömböt. Az első elem az aktuális koordinátánk lesz, a második pedig előbb meghatározott helyet fogja tartalmazni.

Végül ezt és egy megfelelő kulcsokat tartalmazó collectiont átadva meghívjuk a beépített `Map` alkalmazást, ami a paramétereknek megfelelően megtervezi az útvonalat az átadott pontok között.

```swift
func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
  guard let coordinate = view.annotation?.coordinate else {
    return
  }

  let geocoder = CLGeocoder()
  let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

  geocoder.reverseGeocodeLocation(location) { placemarks, error in
    if let error = error {
      print("Error: \(error.localizedDescription)")
    }

    guard let placemarks = placemarks, placemarks.count != 0 else {
      return
    }

    let clPlacemark = placemarks.first!
    let placemark = MKPlacemark(placemark: clPlacemark)
    let mapItem = MKMapItem(placemark: placemark)

    mapItem.name = view.annotation?.title!

    var mapItems = [MKMapItem]()
    mapItems.append(MKMapItem.forCurrentLocation())
    mapItems.append(mapItem)

    let launchOptions: [String: Any] = [
      MKLaunchOptionsMapTypeKey: MKMapType.hybrid.rawValue,
      MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    ]
    MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
  }
}
```

> Futtassuk az alkalmazást!

## Önálló feladatok <a id="onallo-feladatok"></a>

1.  Az üzenetek mellett jelenítsük meg a saját pozíciónkat is a térképen!
1.  Az annotation `leftCalloutAccessoryView`-jában jelenítsük meg az üzenethez tartozó képet! (A kép letöltését érdemes a `mapView(:didSelect:)`delegate metódusban elindítani.)
1.  Módosítsunk a vonal kirajzolásán úgy, hogy azok az üzenetek legyenek összekötve, akiknek a szerzői üzentek már a másik félnek. (Több vonalra lesz szükség.)
