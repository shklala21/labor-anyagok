# `iOS` alapú szoftverfejlesztés - Labor `09`

## A laborsegédletet összeállította
* Kelényi Imre - imre.kelenyi@aut.bme.hu
* Krassay Péter - peter.krassay@autsoft.hu

## A labor témája

* [UberNotebook](#ubernotebook)
    * [Alkalmazás váz, Core Data alapok](#core-data-alapok)
    * [Adatmodell definiálása](#adatmodell-definialasa)
    * [Adatmodell osztályok](#adatmodell-osztalyok)
    * [`Notebook`-ok megjelenítése](#notebookok-megjelenitese)
    * [Jegyzetek, `NSFetchedResultsController`](#jegyzetek-nsfetchedresultcontroller)
    * [Jegyzetek felvétele](#jegyzetek-felvetele)
    * [Jegyzetek törlése](#jegyzetek-torlese)
    * [További műveletek](#tovabbi-muveletek)
    * [Managed Object Context mentése](#moc-mentese)
* [Önálló feladatok](#onallo-feladatok)

## UberNotebook <a id="ubernotebook"></a>

### Alkalmazás váz, Core Data alapok <a id="core-data-alapok"></a>
> Hozzunk létre egy új `Single View Application`t **UberNotebook** névvel `iPhone`-ra. Ne felejtsük el bekapcsolni a **Use Core Data** opciót a projekt generálásakor!

![](img/01_use_core_data.png)

> Töröljük ki a projektből a generált `ViewController.swift` fájlt és a `Main.storyboard`ból is távolítsuk el az ott felvett jelenetet (*View Controller*).

---

_Érdemes megvizsgálni az `AppDelegate.swift`ben a `Core Data` stackhez kapcsolódó metódusokat._

_A `persistentContainer` property fogja össze a `Core Data` stacket, definíciójában láthatjuk a nevét, **UberNotebook**. A háttérben alapértelmezetten egy `SQLite` adatbázis lesz, ami az `UberNotebook.sqlite`-ban tárolja az adatokat._

_A `persistentContainer.viewContext` property-jének segítségével fogjuk tudni elérni a kontextust, amin keresztül a `Core Data` műveleteket elvégezhetjük._

_A `saveContext()` metódust használjuk a kontextus mentéséhez. Egyrészt rögtön naplózza az esetleges hibát, másrészt csak akkor fog ténylegesen menteni, ha az előző mentés óta változott valami a kontextusban._

---

### Adatmodell definiálása <a id="adatmodell-definialasa"></a>

> Nyissuk meg a `UberNotebook.xcdatamodeld` fájlt és vegyünk fel:

>* új entitást a **`Notebook`** névvel:
    * **title** (*String*) attribútummal
* új entitást **`Note`** névvel
    * **content** (*String*) attribútummal
    * **creationDate** (*Date*) attribútummal

<!--  -->
> Vegyünk fel a `Notebook`ba egy **notes** *relationship*et, mely `Note`-ra hivatkozik!

<!--  -->
> Vegyünk fel `Note`-ba egy **notebook** *relationship*et, mely `Notebook`ra hivatkozik!

<!--  -->
> Mindkét *relationship*nél állítsuk be az inverz relációt a másikra!

---

_A `Core Data`-ban relációknál mindig meg kell adnunk egy inverz relációt is. Erre azért van szükség, hogy az objektum gráf ne kerülhessen inkonzisztens állapotba, például törlés esetén (ha egy entitásra van egy reláció, de ennek a relációnak nincs inverze, akkor az entitás törlése esetén nem lehetne értesíteni a reláció tulajdonosát, hogy törlődött egy hivatkozott objektum)._

---

> Állítsuk be a **notes** relációt `To-Many`-re és `Cascade` törlési szabályra (így ha törlődik a `Notebook`, a bejegyzései is törlődnek vele együtt).

![](img/02_notes_relationshop.png)

![](img/03_graph_editor.png)

Itt az ideje az adatmodell kipróbálásának!

> Az `AppDelegate.swift` `application(_:didFinisLaunchingWithOptions:)` metódusban hozzunk létre egy új `Notebook`ot és benne egy `Note`-ot!

```swift
let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook", into: persistentContainer.viewContext)
notebook.setValue("Notebook \(arc4random_uniform(10000))", forKey: "title")

let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: persistentContainer.viewContext)
note.setValue("\(arc4random_uniform(10000)) a kedvenc véletlen számom!", forKey: "content")
note.setValue(NSDate(), forKey: "creationDate")
note.setValue(notebook, forKey: "notebook")

saveContext()
```

> A sikeres mentés esetén kérdezzük le és listázzuk ki az összes elmentett jegyzetet!

```swift
let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")

do {
  let notes = try persistentContainer.viewContext.fetch(fetchRequest)
  notes.forEach({ note in
    let content = note.value(forKey: "content") as! String
    print(content)
  })
} catch let error as NSError {
  print("Couldn't fetch \(error), \(error.userInfo)")
}
```

Mivel az alkalmazás indításakor mindig létrehozunk egy új `Notebook`ot és benne egy `Note`-ot, a logban is minden indítás után egyre hosszabb felsorolást kapunk.

---

_Figyeljük meg a `do-catch` párost, mely a `Swift` 2.0-ban bevezetett új hibakezelés. Bármilyen metódus, mely hibával térhet vissza, csak egy `do` blokkon belül hívható továbbá ezen metódusok hívását külön meg kell jelölni a `try` kulcsszóval. A hibát a `catch` blokkban tudjuk feldolgozni._

---

> Próbáljuk ki, hogy bár a lekérdezésben csak `Note`-okat kérünk le, a lekérdezett objektumok relációs property-jein keresztül el tudunk érni más entitásokat is (ilyen esetekben a `Core Data` automatikusan elvégzi a lekérdezést a háttérben). Esetünkben le tudjuk kérni a `Note`-hoz tartozó `Notebook`ot.

```swift
let notebook = note.value(forKey: "notebook") as! NSManagedObject
print(notebook.value(forKey: "title") as! String)
```

> Kapcsoljuk be a `Product/Scheme/Edit Scheme` menüben, hogy a futtatáskor a konzolon megjelenjenek a `Core Data` használata közben kiadott `SQL` utasítások. Ehhez a **-com.apple.CoreData.SQLDebug 1** argumentumot kell felvenni. (Xcode 8-ban sajnos ez így még nem fog működni egy [ismert hiba](https://developer.apple.com/library/content/releasenotes/General/WhatNewCoreData2016/ReleaseNotes.html) miatt. Vegyük fel a **-com.apple.CoreData.Logging.stderr 1** argumentumot is!)

![](img/04_sql.png)

Miután kipróbáltuk az alkalmazást érdemes kikapcsolni az `SQL` loggolást.

### Adatmodell osztályok <a id="adatmodell-osztalyok"></a>
A `Core Data` programozás során mindenre használhatunk `NSManagedObject` típusú objektumokat, de ennél sokkal kényelmesebb és biztonságosabb, ha az entitásoknak definiált külön osztályokat használjuk.

`Xcode 8`-tól az adatmodellhez definiált összes entitáshoz alapértelmezésként automatikusan legenerálódnak az `NSManagedObject` leszármazottak. (Amennyiben az entitás *Codegen* propery-je **Class Definition** értékű.)

![](img/05_codegen.png)

> Vizsgáljuk meg az automatikusan legenerált fájlokat! Ehhez **ideiglenesen** állítsuk át a `Derived Data` helyét, hogy könnyebben megtaláljuk a `Finder`ben.

![](img/06_project_settings.png)
![](img/07_relative_to_workspace.png)

> Fordítsuk újra a projektet (`Cmd+B`)!

Minden `NSManagedObject` alosztályhoz két külön `Swift` fájl jön létre. Az `Entity+CoreDataProperties.swift`ben egy külön `extension`be kerülnek a generált property-k, míg magát a entitás osztály az `Entity+CoreDataClass.swift` fájlba generálja.

![](img/08_derived_data.png)

--- 

_A_ Codegen _további beállításait is érdemes ismerni._

* _**Manual/None**: régi módszer, kézzel kell megírni, vagy legenerálni a szükséges fájlokat. Ehhez az `Xcode` segítséget nyújt, az adatmodellben az entitást kiválasztva, az `Editor/Create NSManagedObject Subclass...` opcióval legenerálja az osztályokat az entitásokhoz._
* _**Category/Extension**: "félautomata" módba kapcsolja a generátort. Ilyenkor automatikusan legenerálódik az `Entity+CoreDataGeneratedProperties.swift` fájl, azonban magáról az osztály 
deklarálásáról nekünk kell gondoskodnunk._
`
---

### `Notebook`-ok megjelenítése <a id="notebookok-megjelenitese"></a>

> Hogy megkönnyítsük a `NSManagedObjectContext` elérését, vegyünk fel egy osztálymetódust az `AppDelegate.swift`be!

```swift
class var managedContext: NSManagedObjectContext {
  return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
```

> Hozzunk létre egy új `UITableViewController`ből származó osztályt **`NotebookViewController`** névvel!

> A `Main.storyboard`ban vegyünk fel egy új `Table View Controller`t és ágyazzuk be egy `Navigation Controller`be, amit jelöljünk ki a kezdeti view controllernek!

![](img/09_desired_ui.png)

> Továbbra is az `Interface Builder`ben válasszuk ki a `Table View Controller`t és

> 1.  A `Navigation Bar` fejlécére klikkelve nevezzük át **Notebooks**-r.
2.  Az `Identity inspector`ban változtassuk át az osztályát **NotebookViewController**re.

<!--  -->
> Állítsuk be a cella prototípus azonosítóját **NotebookCell**re, a *típusát* **Basic**re:

![](img/10_table_view_cell.png)

> A `NotebookViewController.swift` fájlban importáljuk be a `Core Data` modult és vegyünk fel egy property-t a jegyzetfüzetek tárolására!

```swift
import CoreData
```

```swift
var notebooks = [Notebook]()
```

> Definiáljunk egy metódust, mely lekéri a `Notebook`okat!

```swift
func fetchNotebooks() {
  let managedObjectContext = AppDelegate.managedContext

  let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()

  do {
    let notebooks = try managedObjectContext.fetch(fetchRequest)
    self.notebooks = notebooks
  } catch {
    print("Couldn't fetch!")
  }
}
```

> Hívjuk meg `fetchNotebooks()`-ot `viewDidLoad()`-ban!

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  fetchNotebooks()
}
```

> Valósítsuk meg a `UITableViewDataSource` metódusok közül kötelezőket!


```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return notebooks.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "NotebookCell", for: indexPath)

  let notebook = notebooks[indexPath.row]
  cell.textLabel?.text = notebook.title

  return cell
}
```

> Ellenőrizzük le, hogy megjelennek-e a `Notebook`ok a nézetben!

### Jegyzetek, `NSFetchedResultsController` <a id="jegyzetek-nsfetchedresultcontroller"></a>

> A `Main.storyboard`ban hozzunk létre egy új `Table View Controller`t! Kössük be egy *Show* `segue`-el a `Notebooks View Controller` cellájára!

![](img/11_desired_ui.png)

> Válasszuk ki a `segue`-t és adjuk meg azonosítóul: **ShowNotesSegue**.

![](img/12_show_notes_segue.png)

> Hozzunk létre egy új osztály, `NoteViewController` névvel, mely `UITableViewController`ből származik, majd a `storyboard`ban állítsuk be ezt az osztályt az új jelenethez!

<!--  -->
> A cella *prototípus stílusát* állítsuk **Subtitle**-re, az *Identifier* attribútumot pedig **NoteCell**re!

![](img/13_note_cell.png)

> A `NoteViewController.swift`ben importáljuk a `Core Data` modult és vegyünk fel egy **notebook** property-t, melyben azt tároljuk el, hogy melyik `Notebook` jegyzeteit mutatja a nézet!

```swift
import CoreData
```

```swift
var notebook: Notebook!
```

> Nyissuk meg `NotebookViewController.swift`et és definiáljuk felül a `prepare(for:sender:)` metódust, melyben átadhatjuk a megjelenő jegyzet nézetnek a kiválasztott `Notebook`ot!

```swift
// MARK: - Navigation

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if segue.identifier == "ShowNotesSegue" {
    let noteViewController = segue.destination as! NoteViewController
    noteViewController.notebook = notebooks[tableView.indexPathForSelectedRow!.row]
  }
}
```

> Váltsunk a `NoteViewController.swift`re és vegyünk fel egy `NSFetchedResultsController` típusú property-t!

```swift
var fetchedResultsController: NSFetchedResultsController<Note>!
```

> A `viewDidLoad()` metódusban hozzuk létre a `Note`-okat visszaadó lekérdezést és rendeljük egy újonnan létrehozott `NSFetchedResultsController`hez!

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  navigationItem.title = notebook.title

  let managedObjectContext = AppDelegate.managedContext

  let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()

  // szűrés azon Note-okra, melyek a kiválasztott Notebookhoz tartoznak
  let predicate = NSPredicate(format: "%K == %@", #keyPath(Note.notebook), notebook)
  fetchRequest.predicate = predicate

  // rendezés creationDate szerint, csökkenő sorrendben
  let sortDescriptor = NSSortDescriptor(key: #keyPath(Note.creationDate), ascending: false)
  fetchRequest.sortDescriptors = [sortDescriptor]

  // egyszerre max 30 Note lekérdezése
  fetchRequest.fetchBatchSize = 30

  fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: managedObjectContext,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)

  do {
    try fetchedResultsController.performFetch()
  } catch let error as NSError {
    print("\(error.userInfo)")
  }

}
```

Most még nem látszik miért jobb az `NSFetchedResultsController` egy sima `array`-be történő lekérdezéshez képest, később viszont jelezni fogja ha bármi megváltozik a lekérdezésben érintett objektumokban, ha pl. létrehozunk vagy törlünk egy új `Note`-ot.

> A `UITableViewDataSource` metódusoknál töröljük ki a szekciók számát megadót, a sorok számánál pedig térjünk vissza a `Fetched Results Controller`től elkért értékkel!

```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  guard let sectionInfo = fetchedResultsController.sections?[section] else {
    return 0
  }

  return sectionInfo.numberOfObjects
}
```

> A `tableView(_:cellForRowAt:)` metódusban szintén a `Controller`től kérjük el a megfelelő indexű `Note`-ot és ez alapján konfiguráljuk a cellát. Vegyünk fel egy külön metódust a cella adatainak beállításához (később még ennek hasznát vehetjük, ha már egy létező cellát akarunk frissíteni)!

```swift
func configure(cell: UITableViewCell, at indexPath: IndexPath) {
  let note = fetchedResultsController.object(at: indexPath)

  cell.textLabel?.text = note.content

  let dateFormatter = DateFormatter()
  dateFormatter.dateStyle = .medium
  dateFormatter.timeStyle = .medium
  cell.detailTextLabel?.text = dateFormatter.string(from: note.creationDate as! Date)
}
```

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

  configure(cell: cell, at: indexPath)

  return cell
}
```

> Próbáljuk ki az alkalmazást és ellenőrizzük, hogy megjelennek-e a `Note`-ok a `Notebook`okon belül!

### Jegyzetek felvétele <a id="jegyzetek-felvetele"></a>

> Definiáljunk egy `createNote(content:)` nevű metódust, mely létrehoz egy új jegyzetet és hozzárendeli az aktuális `Notebook`hoz!

```swift
func createNoteWith(content: String) {
  let managedObjectContext = AppDelegate.managedContext

  let note = Note(context: managedObjectContext)
  note.content = content
  note.creationDate = NSDate()
  note.notebook = notebook

  (UIApplication.shared.delegate as! AppDelegate).saveContext()
}
```

> A `storyboard`ban vegyünk fel egy `Bar Button Item`et a `Note View Controller`re a `Navigation Bar` jobb szélére! (Amennyiben nem sikerülne rögtön ráhúzni a `Bar Button Item`et a jelenetünkre, valószínűleg hiányzik a `Navigation Item`. Pótoljuk, ha szükséges.)

![](img/14_add_bar_button_item.png)

> Kössünk be hozzá egy `addNoteButtonTap()` akció metódust, melyben jelenítsünk meg egy `Alert Controller`t, az új jegyzet szövegének bekéréséhez!

```swift
@IBAction func addNoteButtonTap(_ sender: Any) {
  let createNoteAlert = UIAlertController(title: "Create Note", message: "Enter the content", preferredStyle: .alert)

  createNoteAlert.addTextField() {
    textField in
    textField.placeholder = "Note content"
  }

  let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  createNoteAlert.addAction(cancelAction)

  let createAction = UIAlertAction(title: "Create", style: .default) {
    action in

    let textField = createNoteAlert.textFields!.first!
    self.createNote(content: textField.text!)
  }
  createNoteAlert.addAction(createAction)

  present(createNoteAlert, animated: true, completion: nil)
}
```

Ha kipróbáljuk az alkalmazást, azt láthatjuk, hogy nem jelenik meg az új jegyzet a mentés után. Ez azért van mert a `Table View` még nem értesül a kontextus módosításáról. Ekkor tűnik fel a képben az `NSFetchedResultsController`, mely képes értesítéseket küldeni, ha megváltozik az általa figyelt lekérdezés, esetünkben azok a `Note` objektumok, amik az éppen kiválasztott `Notebook`hoz tartoznak.

> Adjuk hozzá `NoteViewController`hez az `NSFetchedResultsControllerDelegate` protokolt!

```swift
extension NoteViewController: NSFetchedResultsControllerDelegate {

}
```

> A `viewDidLoad()` metódusban állítsuk be a `delegate`-et!

```swift
fetchedResultsController.delegate = self
```

> Valósítsuk meg a protokoll következő **3** műveletét!

```swift
func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  tableView.beginUpdates()
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
  switch type {
  case .insert:
    tableView.insertRows(at: [newIndexPath!], with: .fade)
  default:
    break
  }
}

func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  tableView.endUpdates()
}
```

Ezek a metódusok szinte minden alkalmazásban ugyanígy néznek ki (a .delete, .update, .move megadásával, később azokat is felvesszük).

### Jegyzetek törlése <a id="jegyzetek-torlese"></a>

> Engedélyezzük a *Swipe to delete* funkciót a `tableView(:canEditRowAt:)` metódussal!

```swift
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
  return true
}
```

> Majd végezzük el a törlést a `UITableViewDataSource`-ból adoptált `tableView(_:commit:forRowAt:) metódusban!

```swift
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  if editingStyle == .delete {
    let managedObjectContext = AppDelegate.managedContext
    let noteToDelete = fetchedResultsController.object(at: indexPath)
    managedObjectContext.delete(noteToDelete)
  }
}
```

> A törlésről értesül a `Fetched Results Controller` és meghívja az előbb bemutatott `delegate` metódust, ebben vegyük fel a törlés eseményhez, hogy a `Table View` kitörölje a megfelelő elemet!

```swift
case .delete:
  tableView.deleteRows(at: [indexPath!], with: .automatic)
```

> Próbáljuk ki a törlést!

### További műveletek <a id="tovabbi-muveletek"></a>

A `Fetched Results Controller` jelez ha bármelyik objektum módosításra kerül (pl. átírták egy attribútumát) vagy ha megváltozik a pozíciója a lekérdezésen belül. Bár ezeket a laboron nem használjuk, érdemes a standard implementációt ezekhez is felvenni.

```swift
func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
  switch type {
  case .insert:
    tableView.insertRows(at: [newIndexPath!], with: .automatic)
  case .delete:
    tableView.deleteRows(at: [indexPath!], with: .automatic)
  case .update:
    let cell = tableView.cellForRow(at: indexPath!)!
    configure(cell: cell, at: indexPath!)
  case .move:
    tableView.deleteRows(at: [indexPath!], with: .automatic)
    tableView.insertRows(at: [newIndexPath!], with: .automatic)
  }
}
```

### Managed Object Context mentése <a id="moc-mentese"></a>

A jelenlegi implementáció rögtön elmenti a változásokat a perzisztens tárolóba. Sok módosítás esetén (vagy ha esetleg szeretnénk érvényteleníteni a legutóbbi változtatásokat), érdemes lehet a módosításokat csak akkor menteni, mikor az alkalmazás a háttérbe kerül.

> Ehhez módosítsuk az applicationDidEnterBackground() metódust az AppDelegate-ben!

```swift
func applicationDidEnterBackground(_ application: UIApplication) {
  saveContext()
}
```

## Önálló feladatok <a id="onallo-feladatok"></a>

> Építsük be `NotebookViewController`be is új `Notebook`ok felvételének és törlésének lehetőségét!
