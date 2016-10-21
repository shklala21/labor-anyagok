# `iOS` alapú szoftverfejlesztés - Labor `06`

## A laborsegédletet összeállította
* Kelényi Imre - imre.kelenyi@aut.bme.hu
* Kántor Tibor - tibor.kantor@autsoft.hu
* Krassay Péter - peter.krassay@autsoft.hu

## A labor témája

* [iTravel](#itravel)
    * [Kezdeti adatok betöltése](#kezdeti-adatok-betoltese)
    * [Utak listájának megjelenítése: dinamikus `Table View`](#dinamikus-table-view)
    * [Utak részletezése: statikus `Table View`](#statikus-table-view)
    * [Cellák törlése és mozgatása](#cellak-torlese-es-mozgatasa)
* [Önálló feladat](#onallo-feladat)
    * [Új cella hozzáadása](#uj-cella-hozzaadasa)

A labor célja egy utazásokat nyilvántartó alkalmazás megírása és ezzel együtt a `Table View` használatának begyakorlása.

# iTravel <a id="itravel"></a>

## Kezdeti adatok betöltése <a id="kezdeti-adatok-betoltese"></a>
> Hozzunk létre egy `Single View Application`t **iTravel** névvel `iPhone`-ra.

Az egyes utak adatai egy-egy *Dictionary*-ben vannak eltárolva. Hogy mindig legyen pár adatunk a teszteléshez, egy *Property List*ből betöltünk pár kezdeti értéket.

> Húzzuk be a `res/iceland.jpg` és a `res/berlin.jpg` képeket az `Assets.xcasset` katalógusba. 

A képek nyugodtan hagyhatjuk `Universal 1x`-en.

> Húzzuk be az `InitialTrips.plist` fájlt is egy új **Trips** nevű *Group*ba. A fájlt megnyitva megnézhetjük a kezdeti adatokat.

![](img/01_initial_trips_plist.png)

<!--  -->
> Hozzunk létre egy új, `TripsDataManager` nevű osztályt (*Swift File* template), melyben az utazások adatait fogjuk tárolni.

Az osztálynak egyetlen property-je lesz, mely egy `AnyObject` típusú tömbben tárolja az utak adatait.

```swift
var trips: [AnyObject]
```

> Írjuk meg az alap inicializálót, mely betölti a kezdeti utakat a *plist*ből!


```swift
init() {
  let filePath = Bundle.main.path(forResource: "InitialTrips", ofType: "plist")
  trips = NSArray(contentsOfFile: filePath!) as! [AnyObject]
}
```

> Hozzunk létre egy property-t `TripsDataManager`ből az `Application Delegate`-ben és példányosítsuk is!

```swift
let tripsDataManager = TripsDataManager()
```

## Utak listájának megjelenítése: dinamikus `Table View` <a id="dinamikus-table-view"></a>
> Töröljük ki a forrásfájlok közül a legenerált `ViewController`t (*Delete --> Move to Trash*)!

Térjünk át a `Main.storyboard`hoz! Az alkalmazást `iPhone`ra szánjuk, ellenőrizzük tehát, hogy a **compact width**, **regular height** méretosztályban vagyunk-e. (Álló módban minden `iPhone` ezekkel a méretosztályokkal rendelkezik.)

![](img/02_traits.png)

> Töröljük ki a `storyboard`ban levő, generált jelenetünket!

<!--  -->
> Rakjunk be egy `Table View Controller`t! Ágyazzuk be ezt a `Table View Controller`t egy `Navigation Controller`be és állítsuk be a hozzá tartozó *Navigation Item Title* property-jét **Útjaim**ra! 

![](img/03_utjaim_table_view.png)

Ne felejtsük el beállítani `Initial View Controller`nek a `Navigation Controller`t!

> Hozzunk létre egy új, `UITableViewController`ből származó osztályt, `TripsViewController` névvel. Állítsuk be a `storyboard`ban a `Table View Controller` osztályát az újonnan definiált osztályra!

<!--  -->
> Állítsuk át a `Table View Controller`ben lévő `Table View Cell` stílusát **Subtitle**-re és adjunk meg neki egy azonosítót: **TripsTableViewCell**!

![](img/04_utjaim_table_view_cell.png)

> A `TripsViewController`hez adjunk hozzá egy tagváltozót, melyen keresztül elérhetjük az utak adatait!

```swift
var tripsDataManager: TripsDataManager?
```

> Ezt inicializáljuk a `viewDidLoad` metódusban!

```swift
tripsDataManager = (UIApplication.shared.delegate as? AppDelegate)?.tripsDataManager
```

> Valósítsuk meg a `Table View` *Data Source* metódusait!

```swift
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
  return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return tripsDataManager!.trips.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell", for: indexPath)

  let tripData = tripsDataManager!.trips[indexPath.row] as! [String: AnyObject]
  cell.textLabel?.text = tripData["name"] as? String
  cell.detailTextLabel?.text = tripData["location"] as? String

  if let tripImageName = tripData["image-name"] as? String {
    cell.imageView?.image = UIImage(named: tripImageName)
  }

  return cell
}
```

---

*A `MARK: - ` "kulcsszó" segítségével a metódusainkat csoportokba rendezhetjük, egy elválasztót hozhatunk létre közéjük.*

![](img/05_mark_explained.png)

---

> Próbáljuk ki az alkalmazásunkat!

![](img/06_dynamic_table.png)

## Utak részletezése: statikus `Table View` <a id="statikus-table-view"></a>
> Hozzunk létre egy új `Table View Controller`t majd állítsuk át a benne foglalt `Table View` *Content* property-jét **Static Cells**-re!

<!--  -->
> Állítsuk be a *Sections*-t **`2`**-re, a *Style*-t pedig **Grouped**ra!

![](img/07_static_table_view_settings.png)

> Ezek után módosítsuk a `Table View`-t oly módon, hogy az első szekcióban `1` **Custom**, a másodikban pedig `2` **Right Detail** és `1` **Custom** stílusú cella legyen (az egyes cellák *Style* property-jét kell állítgatni).

<!--  -->
> Az első szekció cellájába adjunk hozzá egy `Image View`-t, a második szekció utolsó cellájához pedig egy `Text View`-t. Módosítsuk a feliratokat, hogy a következő képhez hasonló felületet kapjunk (a `Text View` cellájának magassága lehet nagyobb is).

Ha valami miatt az `Interface builder`ben nem sikerülne beállítani az egyes cellák magasságát, akkor a `Size inspector`ban kapcsolhatjuk át **Custom**ra.

![](img/08_static_table_view_layout.png)

Bár ha nem adunk meg a nézetben egyetlen `Auto Layout` kényszert sem, akkor is működni fog, az elegáns megoldás, ha mind az `Image View`-t, mind a `Text View`-t rögzítjük a szülő nézeteikhez néhány kényszer megadásával (pl. **Standard** távolság a szülő összes oldalától vagy csupa 0, a *Constrain to margins* bekapcsolása mellett).

![](img/09_image_view_pin.png)

> Az `Image View` *Mode* property-jét állítsuk **Aspect Fit**re!

![](img/10_image_view_aspect_fit.png)

> A `Text View`-nak kapcsoljuk ki az *Editable* property-jét és állítsuk átlátszóra a háttérszínét!

![](img/11_text_view_editable.png)

![](img/12_text_view_background.png)

> A 4 cellát kiválasztva a *Selection* property értékét állítsuk **None**-ra, hogy ne lehessen kiválasztani a cellákat!

![](img/13_table_view_cells_selection.png)

> Hozzunk létre egy új, `UITableViewController`ből leszármazó osztályt, `TripDetailViewController` névvel, **töröljük ki a generált kódot** és állítsuk be ezt a `storyboard`ban létrehozott `Table View Controller` osztályául.

---

*Ezt a két függvényt különösen fontos kitörölni, ugyanis ezek felülírják a storyboardban nagy gonddal beállított táblázatunkat!*

```swift
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
}
```

---

> Vegyünk fel `Outlet`eket a `4`, adatmegjelenítésre szolgálló nézethez (minden cellából azt a nézetet válasszuk ki, mely az egyedi adat megjelenítésére szolgál, és ezeket kössük be `Outlet`ekre)!

```swift
@IBOutlet weak var tripImageView: UIImageView!
@IBOutlet weak var tripNameLabel: UILabel!
@IBOutlet weak var tripLocationLabel: UILabel!
@IBOutlet weak var tripDescriptionTextView: UITextView!
```

> Vegyünk fel egy `trip` nevű, *Dictionary* típusú property-t a `TripDetailViewController`be. Ez fogja tárolni az éppen kiválasztott út adatait.

```swift
var trip: [String: AnyObject]?
```

> Definiáljuk fel a `viewWillAppear(_:)` metódust, melyben beállítjuk a nézetek kezdeti értékét a `trip` property-ben eltárolt utazás alapján!

```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)

  if let trip = trip {

    if let tripImageName = trip["image-name"] as? String {
      tripImageView.image = UIImage(named: tripImageName)
    }

    tripNameLabel.text = trip["name"] as? String
    tripLocationLabel.text = trip["location"] as? String
    tripDescriptionTextView.text = trip["description"] as? String

    navigationItem.title = trip["name"] as? String
  }
}
```

> A `storyboard`ban kössük be egy **Show** `segue`-el a `Trips View Controller`ben lévő `Table View` prototípus celláját a `Detail View Controller`-re. Nevezzük el a `segue`-t **TripDetailSegue**-nek!

![](img/14_show_segue.png)

![](img/15_show_segue_id.png)

> Ezek után definiáljuk felül `TripsViewController`ben a `prepare(for:sender:)` metódust, hogy átadhassa az éppen kiválasztott cellához tartozó utazás adatait a megjelenő `TripDetailViewController`nek!

```swift
//   MARK: - Navigation

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if segue.identifier == "TripDetailSegue" {
    let vc = segue.destination as? TripDetailViewController
    let row = tableView.indexPathForSelectedRow?.row
    vc?.trip = tripsDataManager?.trips[row!] as? [String: AnyObject]
  }
}
```

> Teszteljük az alkalmazást!

## Cellák törlése és mozgatása <a id="cellak-torlese-es-mozgatasa"></a>
Ahhoz, hogy a `Table View` celláit törölni vagy mozgatni tudjuk, a `Table View`-t *Edit* módba kell kapcsolni. Szerencsére ennek elvégzésére van egy beépített *Edit* gomb a `Table View Controller`ben, ezt csak hozzá kell adnunk például a `Navigation Bar`hoz. 
> Adjuk a következő sort a `TripsViewController` `viewDidLoad:` metódusához!

```swift
navigationItem.rightBarButtonItem = editButtonItem
```

A következő metódust akkor érdemes csak felülírni, ha nem akarunk minden cellát szerkeszthetővé (törölhetővé) tenni, ugyanis alapértelmezés szerint minden cella szerkeszthető.

```swift
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
  return true
}
```

A törlés elvégzését viszont meg nekünk kell elvégezni.

```swift
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  if editingStyle == .delete {
    tripsDataManager?.trips.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .fade)
  }
}
```

A cellák mozgatásának engedélyezése a következőképpen tehető meg. Ez a felülírás a törlés engedélyezéséhez hasonlóan felesleges, ha minden cellára engedélyezni szeretnénk. Amennyiben a `tableView(_:moveRowAt:to:)` metódus implementálva van, akkor alapértelmezetten `true` értékkel tér vissza a `tableView(_:canMoveRowAt:)` metódus.

```swift
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
  return true
}
```

A mozgatás folyamata, mely során az adatforrásként használt tömbben felcserélünk két elemet.

```swift
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
  let tripsToMove = tripsDataManager?.trips[fromIndexPath.row]
  tripsDataManager?.trips.remove(at: fromIndexPath.row)
  tripsDataManager?.trips.insert(tripsToMove!, at: to.row)
}
```

# Önálló feladat <a id="onallo-feladat"></a>

## Új cella hozzáadása <a id="uj-cella-hozzaadasa"></a>
> Vegyünk fel egy új `View Controller`t a `storyboard`ba és ágyazzuk be rögtön egy szintén újonnan létrehozott `Navigation Controller`be. A cél ezután az, hogy a következő felületet állítsuk össze!

![](img/16_edit_trip_layout.png)

> 
* Vegyünk fel egy `Image View`-t és állítsuk be a háttérszínét (*Background* attribútum) valamilyen élénk színre.
* Vegyünk fel két `Text Field`et, és állítsunk be bennünk *Placeholder*t (**Utazás neve** és **Helyszín**).
* Vegyünk fel egy `Text View`-t és állítsuk át a háttérszínét, valamint a kezdeti szöveget pl. **Utazás leírása**-ra.

Az idő szűkössége miatt nem definiálunk `Auto Layout` kényszereket, de ne felejtsük el, hogy így az alklamzás nem fog jól mutatni más kijelzőméreteken, illetve elforgatáskor. Egy éles alkalmazásban ez nem elfogadható.

> Húzzunk be `1-1` `Bar Button Item`et a `View Controller` tetején lévő `Navigation Bar`ra, majd állítsuk ezek *System Item* attributumát **Cancel**re, illetve **Save**-re

![](img/17_bar_button_item.png)

![](img/18_cancel_save.png)

> Hozzunk létre egy új, `EditTripViewController` nevű, `UIViewController`ből származó osztályt, állítsuk be az újonnan létrehozott nézetünk *Class* property-jének az `Identity inspector`ban, majd írjuk felül a fájl tartalmát a következő kóddal!

```swift
import UIKit

class EditTripViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditTripViewController.handleImageViewTap(_:)))
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGestureRecognizer)

    descriptionTextView.delegate = self
  }

  @IBAction func didEndOnExit(sender: UITextField) {
    sender.resignFirstResponder()
  }

  @IBAction func textFieldEditingDidBegin(sender: UITextField) {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -100)
      }, completion: nil)
  }

  @IBAction func textFieldEditingDidEnd(sender: UITextField) {
    sender.resignFirstResponder()

    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 100)
      }, completion: nil)
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }
    else {
      return true
    }
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -210)
      }, completion: nil)
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 210)
      }, completion: nil)
  }
  
  func handleImageViewTap(sender: UITapGestureRecognizer) {
    
  }
}
```

> Végezzük el a következő módosításokat!

* Kössük be a kódban definiált `Outlet`ekre az `Image View`-t, a `2` `Text Field`et és a `Text View`-t! Itt figyeljünk arra, hogy a bekötés során a *sender* attribútumot állítsuk át `AnyObject`ről az aktuális nézet típusára!
* Kössük be az alsó `Text Field` *Editing Did Begin* és *Editing Did End* eseményeit a `textFieldEditingDidBegin(sender:)` és a `textFieldEditingDidEnd(sender:)` metódusokra, továbbá a `didEndOnExit(sender:)` metódusra is!

> Adjunk hozzá a `TripsViewController` `Navigation Bar`jához egy `Bar Button Item`et, majd ennek *System Item* attribútumát állítsuk **Add**ra!

![](img/19_add_bar_button_item.png)

> Kössünk rá az új gombra egy **Show** `segue`-t, ami az új `Navigation Controller`re mutat (ami a szerkesztő `View Controller`t tartalmazza). A `segue`-t nevezzük el **AddTripSegue**-nek, majd teszteljük az alkalmazást!

Amikor az egyelőre üres képre rákattint a felhasználó, meghívódik egy `Tap Gesture Recognizer`t kezelő metódus az `EditTripViewController`ben (`handeImageViewTap(_:)`). Itt szeretnénk megjeleníteni egy képkiválasztó rendszer `View Controller`t. 

```swift
func handleImageViewTap(_ sender: UITapGestureRecognizer) {
  let pickerController = UIImagePickerController()
  pickerController.delegate = self
  pickerController.sourceType = .savedPhotosAlbum
  show(pickerController, sender: nil)
}
```

> Majd valósítsuk meg a `imagePickerController(_:didFinishPickingMediaWithInfo:)` metódust!

```swift
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
  let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
  imageView.image = selectedImage
  dismiss(animated: true, completion: nil)
}
```

> Próbáljuk ki az alkalmazást!

A következő *crash*-t fogjuk kapni.

*iTravel[33375:1745798] [access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.*

`iOS 10`-től kezdve ha használni szeretnénk a rendszer beépített fotóválasztóját, akkor ezen szándékunkat előre kell jelezni az alkalmazásunk `Info.plist` fájljában. (Régebben a rendszer ilyenkor automatikusan feldobott a kérdést a felhasználónak, hogy engedélyezi-e a fotóihoz való hozzáférést.)

*"To protect user privacy, an iOS app linked on or after iOS 10.0, and which accesses the user’s photo library, must statically declare the intent to do so. Include the NSPhotoLibraryUsageDescription key in your app’s Info.plist file and provide a purpose string for this key. If your app attempts to access the user’s photo library without a corresponding purpose string, your app exits."* [Forrás](https://developer.apple.com/library/prerelease/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html)

> Adjuk hozzá az `NSPhotoLibraryUsageDescription` kulcsot az `Info.plist` fájlunkhoz valamilyen tetszőleges magyarázattal!

![](img/20_photo_library.png)

> A szerkesztő nézetből való kilépéshez `1-1` **Unwind** `segue`-t fogunk használni. Ehhez először fel kell vennünk `1-1` speciális akció metódust abban a `View Controller`ben, ahova "vissza szeretnénk térni" a szerkesztő nézet bezárásakor. Ez esetünkben a `TripsViewController`, úgyhogy ehhez adjuk a következő két metódust!

```swift
@IBAction func editTripViewControllerDidSave(unwindSegue: UIStoryboardSegue) {
  let viewController = unwindSegue.source as! EditTripViewController
  let trip: NSDictionary = ["name": viewController.nameTextField.text,
                           "location": viewController.locationTextField.text,
                           "description": viewController.descriptionTextView.text,
                           "image": viewController.imageView.image!]
  tripsDataManager?.trips.append(trip)
  tableView.reloadData()
}

@IBAction func editTripViewControllerDidCancel(unwindSegue: UIStoryboardSegue) {}
```

> A `storyboard`ban kössük be a *Cancel* és a *Save* gombokat a kis `Exit` jelre és itt válasszuk ki `TripsViewController` megfelelő metódusait!

![](img/21_unwind_segue.png)

> Módosítsuk `tableView(:_cellForRowAt)` metódusát, hogy az *image* kulcs esetén már egy kész képet olvasson ki az utazás adatait tároló dictionary-ból!

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell", for: indexPath)

  let tripData = tripsDataManager!.trips[indexPath.row] as! [String: AnyObject]
  cell.textLabel?.text = tripData["name"] as? String
  cell.detailTextLabel?.text = tripData["location"] as? String

  if let tripImageName = tripData["image-name"] as? String {
    cell.imageView?.image = UIImage(named: tripImageName)
  }

  if let tripImage: UIImage = tripData["image"] as? UIImage {
    cell.imageView?.image = tripImage
  }

  return cell
}
```

> Hasonló módon, a `TripDetailViewController`ben is adjuk hozzá a már létező kódhoz a `viewWillAppear(_:)` metódusban a következő `if let` szerkezetet (közvetlenül az `image-name`-es `if let` alá)!

```swift
if let tripImage = trip["image"] as? UIImage {
  tripImageView.image = tripImage
}
```

> Teszteljük az alkalmazást!
