# `iOS` alapú szoftverfejlesztés - Labor `03`

## A laborsegédletet összeállította
* Kelényi Imre - imre.kelenyi@aut.bme.hu
* Kántor Tibor - tibor.kantor@autsoft.hu
* Krassay Péter - peter.krassay@autsoft.hu

## A labor témája
* [iCalculator](#icalculator)
    * [Alap nézetek használata](#alap-nezetek-hasznalata)
    * [`Outlet`ek és akció metódusok](#outletek-es-akcio-metodusok)
* [Stack View](#stack-view)
* [Önálló feladatok](#onallo)
    * [Több számológép művelet támogatása](#tobb-szamologep-muvelet)
    * [Korábbi számítások (*`History` nézet*)](#korabbi-szamitasok)
    * [Extra: alkalmazás ikon](#extra)

A labor során egy egyszerű számológép alkalmazást készítünk el, melyen keresztül megismerkedünk az `iOS`-es felhasználói felület készítésének alapjaival.

## iCalculator <a id="icalculator"></a>
> Hozzunk lére egy új `Single View Application`t, `iCalculator` névvel a `labor_03` könyvtárba!
 
> A `Target` beállítások alatt módosítsuk a `Devices` beállítást `iPhone`-ra.
 
> <img src="img/01_device_iphone.png" alt="01" style="width: 75%;"/>

*Egy `Storyboard` összefoglalja az alkalmazás felhasználói felületének több "jelenetét". Minden jelenethez tartozik egy nézet (`View`) hierarchia és egy `View Controller` (`UIViewController`), ami az adott nézet hierarchiát menedzseli (fogadja a nézetek eseményeit és konfigurálja a nézeteket).*

*Lényegében a `View Controller`hez tartozó egyedi osztály forráskódjában tudjuk "hozzátenni a logikát" az `Interface Builder`ben megtervezett nézet hierarchiához.*

*Egy alkalmazásban több `Storyboard` is lehet, a projekt beállítások között lehet megadni melyik legyen az, melyet megjelenít a program indításkor.*


> Első lépésként válasszuk ki a `Main.storyboard`ot, majd a `File Inspector`ban kapcsoljuk ki a `Use Trait Variations` és a `Use Safe Area Layout Guides` beállításokat!

> <img src="img/02_trait_variations.png" alt="02" style="width: 50%;"/>

*Egy `Trait` leír egy környezeti tulajdonságot, mint például, hogy támogatott-e a `Force Touch` vagy sem. A `Trait Collection` egy `Dictionary`, ami az alkalmazás aktuális környezeti tulajdonságait `Trait`ek és a hozzájuk tartozó értékek formájában tárolja.*

*A `Layout Traits`ben találhatjuk meg többek között a `Size Classes` `Trait`et, ami lehetővé teszi, hogy különféle képernyőméretekre (készülék kategóriákra) és tájolásokra (álló/fekvő) egyetlen nagy közös UI tervet készítsünk (egy `Storyboard`ot).*

*Ez a `Trait Variations` felel meg *Xcode 9*-ben az `Adaptive Layout`nak, amivel később fogunk megismerkedni. Ha kikapcsoljuk, akkor a `Storyboard` azt feltételezi, hogy a felületet csak egyetlen "eszköz típusra" definiáljuk (pl. `iPhone`-ra).*

*A `Safe Area Layout Guide`-ok a képernyő egy olyan területét határolják, melyet nem takar semmilyen rendszerhez tartozó elem, vagy egyéb tartalom. Az `iOS 11`-ben vezették be, a `top` illetve `bottom layout guide`-ok helyett.*

<a id="alap-nezetek-hasznalata"></a>
> Hozzunk létre a `Main.storyboard`ban, a `ViewController`en belül lévő `View`-ban **2 db** `UITextField`et, **2 db** `UILabel`t és **1 db** `UIButton`t.

> <img src="img/03_starter_ui.png" alt="03" style="width: 50%;"/>

*A nézetek elrendezéséhez most még abszolút koordinátákat használunk, ami miatt elforgatott, vagy eltérő méretű kijelzőn a felület "helytelenül" fog megjelenni (nem középen lesz amit középre rakunk).  Ezt a problémát oldja meg az `Auto Layout`, melyről később fogunk tanulni.*

Lehetőség van rá, hogy értelmes neveket adjunk az egyes felületelemeknek. Az átnevezéshez válasszunk ki egy elemet a bal szélső listából, majd az `Enter` megnyomása után átnevezhetjük. 

> <img src="img/04_named_views.png" alt="04" style="width: 30%;"/>
>

> Rendezzük középre a két `UILabel` szövegét az *`Alignment`* property módosításával!

> ![](img/05_alignment.png)

> Teszteljük a felületet a szimulátorral!

> Hozzunk létre egy `IBOutlet`et `ViewController`ben az egyik `Text Field`hez! 

```swift
@IBOutlet weak var inputTextFieldA: UITextField!
```

<a id="outletek-es-akcio-metodusok"></a>
**Mi az `Outlet`?**
*Property, amin keresztül hivatkozhatunk egy, a grafikus szerkesztőben (`Interface Builder`) létrehozott, felületi elemre.*

**Miért van itt `weak` property?**
*Mert az `Outlet`ekhez tartozó nézeteket a szülő nézeteik vagy a gyökérnézet esetén a `View Controller` birtokolja. Ha egy nézet kidobja a gyerekeit, akkor azt várjuk, hogy azok törlődjenek (szabaduljon fel az általuk foglalt memóriaterület), és ha `strong` referencia lenne rájuk az `Outlet`ek miatt, akkor ez nem történne meg.*

> Kössük be a `Text Field`et az `Outlet`re, a `Storyboard`ból a `Connections Inspector`t használva!

> <img src="img/06_outlet.png" alt="06"/>
> 
> Módosítsuk kódból, a `viewDidLoad` metódusból a `Text Field` értékét!

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  
  inputTextFieldA.text = "13"
}
```

<!-- Mutogassuk meg, hogy milyen szépen mutatja a kódban és a UI editorban, hogy melyik Outlethez melyik UI elem tartozik. Mind a sorok elején lévő kis jellel, mint a Connection inspectorban. -->
> Váltsunk `Assistant Editor` nézetbe (`⌘+⌥+Enter`), majd hozzunk létre `Outletek`et az egyes nézetekhez `Jobbklikk-Drag&Drop`-pal (kivéve a `+` jeles `UILabel`hez)!

> ![](img/07_create_outlet.png)

```swift
@IBOutlet weak var inputTextFieldA: UITextField!
@IBOutlet weak var inputTextFieldB: UITextField!
@IBOutlet weak var calculateButton: UIButton!
@IBOutlet weak var resultLabel: UILabel!
```

<!-- Meséljünk a generált eseményekről és az elkapásukra szolgáló akció metódusokról. -->
> Adjunk hozzá egy akciót is a gomb (`calculateButton`) `Touch Up Inside` akciójához (`calculateButtonTouchUpInside`) és valósítsuk meg a gomb lenyomásakor meghívódó metódust!

```swift
@IBAction func calculateButtonTouchUpInside(_ sender: Any) {
  let numberFormatter = NumberFormatter()

  if
    let textA = inputTextFieldA.text,
    let textB = inputTextFieldB.text,
    let a = numberFormatter.number(from: textA)?.doubleValue,
    let b = numberFormatter.number(from: textB)?.doubleValue {

    resultLabel.text = "\(a + b)"
  }
}
```

*A többsoros `if` valójában négy `optional binding` egymás után végrehajtva. `textA`, `textB`, `a` és `b` is mind új változók, melyek csak az `if`-hez tartozó blokkon belül láthatók. Az ilyen, vesszővel elválasztott, több tagú `if`-eknél az egyes feltételek sorban értékelődnek ki és ha valamelyik feltétel nem sikerül, a többit már nem ellenőrzi a fordító ("`short-circuit` kiértékelés”).*

> Próbáljuk ki a félkész számológépet!

> Állítsuk át a `Storyboard`ban, a `Text Field`ek `Keyboard` attribútumát `Decimal Pad`ra. Ezzel elérjük, hogy egy csak számokat tartalmazó billentyűzet jelenjen meg!
![](img/08_decimal_number_pad.png)

> Ezek után adjuk az `onCalculateButtonTouchUpInside` akció metódusunkhoz a következő két utasítás, melyek hatására el fog tűnni a billentyűzet a képernyőről (amennyiben éppen aktív/látható)!

```swift
inputTextFieldA.resignFirstResponder()
inputTextFieldB.resignFirstResponder()
```

*A `first responder` az az objektum (esetünkben nézet), mely éppen "fókuszban van" és először fogadja a felhasználótól érkező billentyű eseményeket. Ha egy `Text Field` nézet lesz a `first responder`, akkor automatikusan megjelenik a billentyűzet. Ha "lemondunk" a `first responder` státuszról a `resignFirstResponder()` metódus meghívásával, akkor eltűnik a billentyűzet is.
Ha nem tudjuk pontosan hogy épp ki a `first responder`, akkor elegánsabb megoldás a `view.endEditing(true)` hívás, mely végiglépked a nézet gyereknézetein és mindegyiknél lemond a `first responder` státuszról.*

> Írjuk át a kódot, hogy egyszerre mondjuk le az összes `Text Field` `first responder` státuszáról!

```swift
view.endEditing(true)
```

A probléma most már csak az, hogy a feljövő virtuális billentyűzetet csak úgy tudjuk eltüntetni, ha megnyomjuk az számológép gombját. Az elegáns megoldás `Decimal Pad` billentyűzet eltüntetésére, hogy a gyökér nézet hátterét bárhol megérintve eltűnjön a billentyűzet.

Ahhoz, hogy a gyökér nézet megérintését le tudjuk kezelni, le kell cserélnünk az osztályát `UIView`-ról, `UIControl`ra (hiszen csak `UIControl` és belőle származó osztályok tudnak előre definiált eseményeket generálni). 
> Az `Interface Builder`ben kiválasztva a `ViewController` gyökér nézetét, a `Identity Inspector`ban választhatjuk ki hozzá a konkrét osztályt, itt váltsunk `UIControl`ra!

> <img src="img/09_selected_view.png" alt="09" style="width: 30%;"/>

> ![](img/10_identity_inspector.png)

> Ezek után a `Connections inspector`ban a `Touch Up Inside` eseményhez rendeljünk hozzá egy `onBackgroundTouchUpInside` nevű metódust!

```swift
@IBAction func onBackgroundTouchUpInside(_ sender: Any) {
  view.endEditing(true)
}
```

*He szeretnénk, hogy eltűnjön a már beírt szöveg a `Text Field` kiválasztásakor, akkor kapcsoljuk be a `Clear when editing begins` opciót az `Attributes Inspector`ban. Itt adhatjuk meg azt is, hogy a törlés (`Clear`) gomb mikor jelenjen meg.*
![](img/11_clear_text_field.png)

## Stack View <a id="stack-view"></a>

Ha most kipróbáljuk az alkalmazást egy, a grafikus tervezőfelülettel nem megegyező méretű szimulátoron, azt fogjuk tapasztalni, hogy a nézetek nem középre rendezve jelennek meg. Ennek oka, hogy jelenleg abszolút koordinátákkal adtuk meg a nézetek méretét és elhelyezkedését, ami nem változik ha eltérő méretű kijelzőt használunk.

A legegyszerűbb megoldás az elemek dinamikus elrendezéséhez az `iOS 9`-ben debütáló `Stack View`. 

> Válasszuk ki az összes nézetet, majd nyomjuk meg a `Stack` gombot a szerkesztő nézet jobb alsó sarkában! ![](img/12_stack_button.png)

Először valami hasonló, nem túl jól kinéző felületet fogunk látni.
> <img src="img/13_initial_stack_view.png" alt="13" style="width: 75%;"/>

> Ahhoz, hogy a nézetek egyenletesen helyezkedjenek el, válasszuk ki a `Stack View`-t és állítsuk be a *`Distribution`* paraméterét **`Equal Spacing`**re az `Attributes Inspector`ban!

> ![](img/14_stack_view_distibution.png)

> Továbbra is a `Stack View` beállításai között állítsuk az *`Alignment`* paramétert **`Fill`**re! Ezzel azt érjük el, hogy a `Stack View`-ban lévő nézetek kitőltik a rendelkezésre álló szélességet.

> ![](img/15_stack_view_alignment.png)

Utolsó lépésként még be kell állítanunk, hogy maga a `Stack View` dinamikusan legyen elrendezve a képernyőn. Ehhez az `Auto Layout`ot fogjuk használni, amiről a következő laboron még bőven lesz szó.
> Most egyelőre csak válasszuk ki a `Stack View`-t és a `Pin` opciót, majd csatoljuk hozzá a szülő nézetéhez és magasságát állítsuk fixen `300`-ra!

> <img src="img/16_auto_layout.png" alt="16" style="width: 50%;"/>

# Önálló feladatok <a id="onallo"></a>

## Több számológép művelet támogatása <a id="tobb-szamologep-muvelet"></a>
> Töröljük ki a `+` jelet megjelenítő `UILabel`t és a helyére húzzunk be egy `Segmented Control`t (`UISegmentedControl`)!

> ![](img/20_segmented_control.png)

> Módosítsuk a `Segmented Control`t, hogy **`3`** szegmensből álljon (`Attributes Inspector`ban a *`Segments`* attribútum), majd írjuk át ezek szövegét (dupla klikk a szerkesztőben, vagy `Attributes Inspector`ban az adott `Segment` `Title` property-jének módosításával) a szorzás, osztás és összeadás müveletknek megfelelő jelekre!

> <img src="img/21_segmented_control_segment_title.png" alt="21" style="width: 30%;"/>
> <img src="img/22_segmented_control_operators.png" alt="22" style="width: 50%;"/>

> Az `Assistant Editor` nézetre váltva, kössük be a `Segmented Control` `Value Changed` eseményét egy új `operationSelectorValueChanged:` nevű akció metódusra a `ViewController` osztályban!

```swift
@IBAction func operationSelectorValueChanged(_ sender: Any)
```

> Vegyünk fel egy új enumerációt a `ViewController` osztályon belül, mely az éppen kiválasztott számológép műveletet jelöli!

```swift
enum OperationType {
  case add
  case multiply
  case divide
}
```

> Továbbá vegyünk fel egy privát tagváltozót az osztály implementációs blokkjába!

```swift
private var operationType = OperationType.add
```

Érdemes a `Segmented Control` kezdeti értékét is megadni (bár esetünkben ez pont helyesen `0`-ra van inicializálva, de nem árt rászokni, hogy mindig inicializáljunk). 
> Ehhez fel kell vennünk egy `Outlet`et a `Segmented Control`hoz (pl. `operationSelector`), majd a `View Controller` `viewDidLoad` metódusában az `Outlet` `selectedSegmentIndex` property-jét `0`-ra állítani.

```swift
operationSelector.selectedSegmentIndex = 0
```

> Majd implementáljuk az `onOperationSelectorValueChanged` metódust!

```swift
@IBAction func operationSelectorValueChanged(_ sender: AnyObject) {
  switch operationSelector.selectedSegmentIndex {
  case 0:
    operationType = .add
  case 1:
    operationType = .multiply
  case 2:
    operationType = .divide
  default:
    return
  }
}
```

Ezek után már csak annyi dolgunk van, hogy a kiszámítást elindító gomb megnyomásakor meghívódó akció metódusban `operationType` tartalmának megfelelő műveletet végezzünk (itt is érdemes egy állapotgépet használni).

## Korábbi számítások (*`History` nézet*) <a id="korabbi-szamitasok"></a>

> Adjunk hozzá egy `Text View`-t a `Stack View` aljához, majd hozzunk létre hozzá egy `IBOutlet`et a `View Controller` interfészében (pl. `historyView` névvel)!

> ![](img/23_text_view.png)

> <img src="img/24_history_view.png" alt="24" style="width: 50%;"/>

> A már korábban látott módon állítsuk be a `Text View` magasságát `100`-ra `Auto Layout` segítségével!

*A `Text View` legfőbb különbségei `UILabel`hez képest, hogy szerkeszthető és a kilógó szöveg görgethető.*

> Állítsuk a `Text View`-t csak olvasható üzemmódba (`historyView.isEditable = false`)!

> Módosítsuk az eredményeket kiszámító kódot oly módon, hogy az aktuális számításról bekerüljön egy sor a `Text View`-ba, pl. `13.00 + 13.00 = 26.00`!

> ![](img/25_history_view.png)

Tippek:

* Allítsunk össze egy `String`et az új bejegyzéshez.
* Allítsuk be a `Text View` `text` property-jének értékét oly módon, hogy az új bejegyzéshez hozzáillesztjük a `Text View` `text` property-jének korábbi értékét (`textView.text = újSzöveg + textView.text`).
* Egy `enum` rendelkezhet `String` `raw value`-val, és így rendelhetünk hozzá szöveges értéket.

## Extra: alkalmazás ikon <a id="extra"></a>
> Töltsük le, majd állítsuk be [az ikont](res/Icon-120.png)!
