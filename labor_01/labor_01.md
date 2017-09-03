# `iOS` alapú szoftverfejlesztés - Labor `01`

## A laborsegédletet összeállította

* Kelényi Imre - imre.kelenyi@aut.bme.hu
* Kántor Tibor - tibor.kantor@autsoft.hu
* Krassay Péter - peter.krassay@autsoft.hu

## A labor témája

- [Bemutatkozás](#bemutatkozas)
- [`macOS` felhasználói alapismeretek](#macOS)
    - [Billentyűzet](#billentyuzet)
    - [Egér](#eger)
    - [Unix gyökerek](#unix-gyokerek)
    - [Fájlkezelés](#fajlkezeles)
- [*Xcode*, `iOS` fejlesztőkörnyezet bemutatása, *HelloWorld*](#xcode)
    - [Projektek](#projektek)
    - [Toolbar](#toolbar)
    - [Navigator](#navigator)
    - [Projekt felépítése](#projekt-felepitese)
    - [Projekt fordítása, futtatása](#projekt-forditasa-futtatasa)
    - [Írás a konzolra](#iras-a-konzolra)
    - [Írás a képernyőre](#iras-a-kepernyore)
    - [Debugolás alapok](#debugolas-alapok)
    - [Szöveg testreszabás](#szoveg-testreszabas)
    - [Projektbeállítások áttekintése](#projektekbeallitasok-attekintese)
    - [Alkalmazás ikon beállítása](#alkalmazas-ikon-beallitasa)
    - [Kezdőképek (*Launch images)*](#kezdokepek)
    - [`iPad` támogatás](#ipad)
    - [Hasznos Xcode billentyűkombinációk](#hasznos-xcode-bill)
- [Extra feladatok](#extra-feladatok)

## Bemutatkozás <a id="bemutatkozas"></a>
* A laborok `60%`-án kötelező a részvétel. (Idén ez `8` labort jelent.) A laborvezetők minden óra elején körbeadnak egy jelenléti ívet. Ezen felül minden labor végén fel kell tölteni a `GitHub`ra az elkészült laborfeladatot, egyetlen `.zip` fájl formájában (aki ezt nem teszi meg, annak érvénytelen a laborja!). A laborvezetőknek lehetősége van a kimagasló/nagyon jó megoldásokért vagy órai munkáért plusszpontokat osztani a laborok után, ami beszámít a ZH-ba, az év végi jegybe vagy a házi feladat értékelésnél (+1 pont laboronként).
* Rendszeresen látogassátok a [tárgy honlapját](https://www.aut.bme.hu/Course/ios), ide kerül fel minden információ. (Van RSS feed is.)
* A tárgyból a legkönnyebben házi feladat beadásával lehet megszerezni a félév végi jegyet. A beadott házikat a laborvezetők fogják értékelni. A házi feladat beadás rendjéről a tárgy honlapján fogunk a későbbiekben információkat közzétenni.
* A laborokkal kapcsolatban mindenkitől örömmel fogadunk hibajelentéseket vagy bármilyen egyéb, _építő jellegű_ kritikát.

## `macOS` felhasználói alapismeretek <a id="macOS"></a>

### Billentyűzet <a id="billentyuzet"></a>
Mac-ekhez külön Apple billentyűzetek léteznek, melyeken némiképp különbözőek a funkcióbillentyűk, és található rajtuk néhány extra gomb. Ezeken túl azonban a billentyűkiosztás megegyezik a standard PC-s billentyűzetekkel. A laborokban PC-s billentyűzetek vannak rákötve a Mac-ekre, melyeken elérhető minden szükséges gomb, azonban van néhány eltérés a Windowsos használathoz képest.

A legfontosabb különbség, hogy Mac-en `Command` (`⌘`) gomb van Windows gomb helyett. Ez a PC-s billentyűzeten alapesetben pont a Windows gombra képződik le. A `Control` (`⌃`), `Alt` és `Alt Gr` (Right Alt), Mac-en is ugyanúgy használatos. Mac-en az `Alt`-ot `Option`-nek (`⌥`) hívjuk.

---

*Mac-en a billentyűparancsok jelentős része nem a `Control`, hanem a `Command` billentyűvel válthatók ki, tehát `⌃+C` helyett `⌘+C`-t használunk!*

---

![](img/01_keyboard.png)

| A legfontosabb általános billentyűkombinációk                 | |
| --- | --- |
| `⌘+C`         | Copy                                          |
| `⌘+V`         | Paste                                         |
| `⌘+X`         | Cut                                           |
| `⌘+Z`         | Undo                                          |
| `⌘+⇧+Z`       | Redo                                          |
| `⌘+F`         | Keresés szövegben                             |
| `⌘+G`         | Következő találat kereséskor                  |
| `⌘+W`         | Ablak bezárása                                |
| `⌘+Q`         | Kilépés az alkalmazásból                      |
| `⌘+Space`     | *Spotlight* (gyorskereső, alkalmazásindtás)   |
| `⌘+→`         | Ugrás a sor végére (`End` helyett)            |
| `⌘+←`         | Ugrás a sor elejére (`Home` helyett)          |
| `⌘+↹`         | Futó alkalmazások közötti váltás              |

---

*A legtöbb Mac-es alkalmazásnál az alkalmazás ablakainak vagy ablakának bezárása után is tovább fut a program. A teljes kilépéshez a `⌘+Q`-t használhatjuk.*

---

### Egér <a id="eger"></a>
Korábban a Mac-es egerek egygombosak voltak, a `⌃+klikkel` lehetett az alternatív funkciókat elérni (ma is használható: `⌃+balklikk`). Kétgombos egereknél a jobb gomb funkciója megegyezik a `⌃+balklikkel`.

### Unix gyökerek <a id="unix-gyokerek"></a>
A `macOS` (korábban `OS X`, `Mac OS`) egy Unix (BSD) alapú operációs rendszer. A Unix-os alapokat teljesen elfedi a GUI és az Apple saját alkalmazásai.

Minden felhasználónak (esetünkben a `labor` nevű user-nek) van egy home könyvtára (`/Users/labor`), itt fogjuk a labor során a projekteket és egyéb fájljainkat tárolni.

> A laborok végén kérjük töröljétek a létrehozott fájlokat! A `macOS` alapból a lomtárba töröl (alul a dokkon, jobb oldalt a kuka), ezt a jobb klikkel előhozható menüből lehet törölni.

Az *Activity Monitor* alkalmazást elindítva láthatjuk a futó alkalmazások process-eit. Itt van lehetőség egy esetleg lefagyott alkalmazás kilövésére is. Alkalmazások bezárásához használhatjuk még a `⌘+⌥+Esc` billentyűkombinációra megnyíló ablakot is.

### Fájlkezelés <a id="fajlkezeles"></a>
Alap fájlkezelő: *Finder*, hasonlóan működik mint Windows intéző.

| Néhány hasznos *Finder* billentyűkombináció                                     | |
| --- | --- |
| `⌘+Le`        | Belépés egy könyvtárba                                            |
| `⌘+Fel`       | Kilépés egy könyvtárból                                           |
| `⌘+Backspace` | Fájl törlése                                                      |
| `Enter`       | Fájl átnevezése                                                   |
| `Space`       | *QuickLook*                                                       |
| `⌘+⇧+G`       | Navigálás egy könyvtárhoz (Go to Folder)                          |

A törlés a *Trash*-be történik, amit jobb klikk után kiüríthetünk.

Külső USB eszköz csatlakoztatás után a `/Volumes/` mappába mountolódik automatikusan. A *Finder*ben és bárhol a standard fájlkezelő dialógusoknál a bal szélső gyorsmenüből a `Devices` részben érhetők el, de a `Desktop`on is megjelenik hozzájuk egy-egy ikon. Az USB-s eszközöket a kihúzás előtt unmountolni kell. (*Finder*ben a bal szélső menüben, az USB eszköz előtti kis "eject" ikon, vagy pedig jobb klikk után "Unmount". További lehetőség még az asztalon az USB-s eszközt a `Trash`-be húzni.)

## *Xcode*, `iOS` fejlesztőkörnyezet bemutatása, *HelloWorld* <a id="xcode"></a>
*Xcode*, "all in one" `iOS`, `macOS`, `watchOS`, `tvOS` fejlesztőkörnyezet, tartalmazza a platform SDK-kat és minden egyéb eszközt ami ahhoz szükséges, hogy alkalmazásokat fejlesszünk. Saját gépre egyszerűen az `macOS` *App Store*-ból lehet ingyenesen letölteni, mint egy standard alkalmazást.

A továbbiakban megismerkedünk az *Xcode* legfontosabb funkcióval és bemutatásra kerül az `iOS`-es alkalmazások projektjeinek felépítése.

### Projektek <a id="projektek"></a>
Az alkalmazások, komponensek forráskódját és egyéb fájljaikat projektek fogják össze. Új projekt létrehozásakor (`⌘+⇧+N`) kiválaszthatjuk a projekt sémáját. A megadott template-ek csak az automatikusan legenerált kezdeti fájlokat határozzák meg, további megkötéseket nem jelentenek a projektre.

> Hozzunk létre egy új projektet (`⌘+⇧+N`) és válasszuk a `Single View App` template-et!
![](img/02_create_new_project_template.png)

<!-- -->
> * A *Product Name* legyen **`Labor1`**.
> * A *Team* legyen **`None`**.
> * Az *Organization Name* tetszőlegesen választható, a példában **`BME AUT`** lesz.
> * Az *Organization Identifier* az alkalmazás egyedi azonosítójának része lesz, itt konvenció szerint "fordított DNS jelölést" szokás használni, vagyis pl. `hu.cégnév`. A példánkban **`hu.bme.aut`** lesz.
> * A *Language* **`Swift`** legyen.
> * A többi opciót hagyjuk az alapbeállításokon.
![](img/03_create_new_project_options.png)

Az *Xcode* automatikusan létre tud hozni egy lokális `git` repository-t a projekthez.
![](img/04_create_new_project_git.png)

*A `git` egy elosztott verziókezelő rendszer, amely kiválóan alkalmas projektek forráskódjának verzióinak menedzselésére és a csapatmunka támogatására. Aki nem ismerné a `git`et, annak házi feladat.*

* [https://try.github.io](https://try.github.io)
* [https://www.atlassian.com/git/](https://www.atlassian.com/git/)

A laborgépeken célszerű a projekteket a `/Users/labor/Developer` mappában tárolni.

### Toolbar <a id="toolbar"></a>
A képernyő tetején található sáv.
![](img/05_xcode_toolbar.png)

### Navigator <a id="navigator"></a>
Bal szélső panel. Több tabból áll, a projekt fájljait az `1.` tabon, a `Project Navigator`ban láthatjuk (`⌘+1`).
![](img/06_xcode_navigator.png)

Az itt látható mappákat *Group*oknak nevezik és *Xcode 9*-től **tükrözik**, hogy a fájlrendszerben hol is helyezkednek el a fájlok. (Régebben ennek megoldására csak *3rd party* eszközök álltak rendelkezésünkre.) Tetszőlegesen csoportosíthatjuk a fájlokat új *Group*okba, vagy átnevezhetjük a már meglévő *Group*okat, az *Xcode* le fogja követni ezeket a változtatásokat a fájlrendszerben.

---

*A `Project Navigator`ban lévő mappák (*Groupok*) segítségével logikailag csoportosíthatjuk a projekt fájljait.*

---

> Ellenőrizzük a `Project Navigator`ban és a fájlrendszerben lévő fájlokat és a könyvtárszerkezetet (*Finder* segítségével).

### Projekt felépítése <a id="projekt-felepitese"></a>

---

*Az `iOS`-re írt alkalmazások alapvetően az `MVC` (Model View Controller) architektúrára épülnek.*

---

Az `iOS` alkalmazások felépítésével részletesebben a következő hetekben fogunk foglalkozni. Most csak nagyon röviden végignézzük, hogy a generált fájlok közül melyik micsoda.

| Fájlnév | Leírás |
| --- | --- |
| `AppDelegate.swift`         | Az alkalmazáshoz tartozó `UIApplicationDelegate` protocol (interfész) implementációja, melyben lekezelhetjük az alkalmazás életciklus fontosabb eseményeit (pl. elindult a program). Egyszerűbb alkalmazásoknál ez lehet a fő/gyökér osztály, ahol az alkalmazáslogikát megírjuk. |
| `ViewController.swift`      | Az alkalmazás egy `View controller`e, mely tartalmazza az alkalmazás egy "képernyőjéhez" tartozó logikát/kódokat. |
| `Main.storyboard`           | Az alkalmazás felhasználói felületét, "nézeteit" és azok kapcsolatát leíró XML fájl. |
| `Assets.xcassets`            | A projektben használt képi erőforrásokat (képfájlokat) tartalmazó "asset katalógus". Valójában egy könyvtár. |
| `LaunchScreen.storyboard`   | Az alkalmazás indításakor, töltés közben megjelenő *Launch Screen* (~"Splash Screen", de csak addig látszódik, míg töltődik az alkalmazás). |
| `Info.plist`                | Metaadatokat tartalmaz az alkalmazásról az OS felé (pl. indítófájl, alkalmazás ikon neve, stb.) |

A `Products` *Group* egy speciális mappa, mely az alkalmazás fordításakor/tesztelésekor előállított binárisokat tartalmazza (ezeket már a fordító/linker állítja elő a projekthez definiált `Target`ekhez. Pl. a **Labor1.app** az elkészítendő alkalmazás `bundle`-re hivatkozik (lényegében ez tartalmaz mindent, ami az alkalmazás futtatásához kell).

> Ellenőrizhetjük, hogy a fájlrendszerben nincsen ott a **Labor1.app**

| Gyakori fájlkiterjesztések | |
| --- | --- |
| `.swift`                | `Swift` forráskód |
| `.h`                    | Objective-C forráskód (header fájl) |
| `.m`                    | Objective-C forráskód (implementáció) |
| `.storyboard, .xib`     | Felhasználói felületet leíró (XML) fájlok, *Xcode*-ban grafikusan szerkeszthetők |
| `.framework`            | Framework (~DLL + headerök + bármilyen egyéb erőforrások) |
| `.plist`                | Property list: hierarchikus adatstruktúra (listák, dictionary-k és alaptípusok tetszőleges elrendezésben), a lemezre mentve, *Xcode*-ban grafikusan szerkeszthető (valójában egy XML, bár van bináris változata is) |

### Projekt fordítása, futtatása <a id="projekt-forditasa-futtatasa"></a>
> Fordítsuk le és futtassuk az alkalmazást (`⌘+R`) és gyönyörködjünk a megjelenő fehér ablakban! Ismerkedjünk meg az *iOS Simulator* alapfunkcióival!

<!-- -->
> Próbáljuk ki az *iOS Simulator* alapfunkcióit (`Multitasking Bar` behozása (`2x` `⌘+⇧+H`), futó alkalmazás leállítása, alkalmazás törlése, minden alkalmazás törlése *Reset Content and Settings* paranccsal)!

A fordítási folyamat eredménye egy **Labor1.app** nevű bundle. A bundle nem más mint egy könyvtár, fix belső szerkezettel. Ezen belül található az alkalmazás futtatható indítófájlja és az egyéb erőforrások (képek, adatfájlok, stb.). Szimulátorra való fordítás esetén a **Labor1.app** megtalálható a Mac fájlrendszerében.

---

*Sajnos Xcode 6-tól elég nehéz megtalálni a szimulátor és azon belül az alkalmazások könyvtárát. A `~/Library/Developer/CoreSimulator/Devices/UID/data/Container/Data/Application/` körül lehet keresgélni, de a `UID` egy hosszú, kvázi-véletlen azonosító, ami ráadásul fordítások között is változhat...*
*Több 3rd party megoldás született már a mappa könnyebb megtalálásához, pl. [SimPholders](http://simpholders.com)*

---

### Írás a konzolra <a id="iras-a-konzolra"></a>
A konzolra való log üzenetek megjelenítéséhez a `print(_:separator:terminator:)` függvényt használhatjuk. A konzol ablak alapból rejtve van, kapcsoljuk be a *Toolbar*on.
![](img/07_xcode_debug_area.png)

A képernyő jobb alsó sarkában megjelenő sávban is gondoskodjunk arról, hogy a *Console* nézet be legyen kapcsolva.
![](img/08_xcode_console.png)

> Írjuk ki a konzolra az ominózus "Hello World" szöveget (szúrjuk be a kódot az `AppDelegate.swift` fájlba az `application(_:didFinishLaunchingWith⌥s:)` metódus végére, a `return true` elé)!

```swift
print("Hello World!")
```

A `Swift` szintaktikailag közel áll a `C`-hez és `Java`-hoz, azonban azoknál jóval tömörebb. A zárójelek a legtöbb esetben elhagyhatók, hasonlóan a mondatvégi pontosvesszőkhöz. Egy `for` ciklus pl. így néz ki.

```swift
for i in 1...5 {
  print("Hello \(i)!")
}
```

### Írás a képernyőre <a id="iras-a-kepernyore"></a>
Váltsunk át a `Main.storyboard` fájlra. Itt az alkalmazás jeleneteit (*scene*-eit, *View Controller*eit) láthatjuk. Kezdéskor egyetlen jelenet található a `storyboard`ban, amely teljesen üres. A későbbiekben részletesen fogunk foglalkozni a felhasználói felület felépítésével, most azonban elégedjünk meg annyival, hogy itt tudjuk definiálni, hogy milyen nézetekből épüljön fel a felhasználói felülete és ezekhez milyen beállítások tartozzanak.

> Módosítsuk a `ViewController.swift` fájlban a `viewDidLoad` metódust, hogy az létrehozzon egy új `UILabel`t és kiírja a **Hello World**öt a képernyőre.

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
}
```

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    let helloWorldLabel = UILabel(frame: CGRect(x: 10, y: 20, width: 300, height: 100))
    helloWorldLabel.text = "Hello World"
    view.addSubview(helloWorldLabel)
}
```

Röviden beszéljük meg a következő fogalmakat (fontos, ezekről mind lesz szó még későbbi laborokon, most csak ismerkedünk velük).

* A `viewDidLoad` metódus akkor hívódik meg, mikor a rendszer betölti a memóriába jelenethez (View Controllerhez) tartozó nézetet. Jelen esetben felfoghatjuk úgy, hogy akkor hívódik meg, mielőtt megjelenne a jelenetünk.
* A `helloWorldLabel` egy (lokális) konstans, (a `let` kulcsszó vezeti be a konstansokat), melynek értékül adunk egy új `UILabel` példányt.
* `UILabel`nek a példányosításakor át kell adnunk egy `CGRect`et, mely megmondja hol és mekkorában helyezkedik el a képernyőn.
* A `view` valójában `self.view`-ra hivatkozik és az aktuális View Controller gyökérnézetét jelöli, de `Swift`ben lehetőség van a `self` (~`this` pointer) elhagyására.

> Nézzük meg a `UILabel` osztály rövid leírását (`⌥+klikk` a kódban `UILabel`re), majd a [teljes leírást](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UILabel_Class/) az Apple Developer Library-ban!

### Debugolás alapok <a id="debugolas-alapok"></a>
Debug breakpointok a kódsorok elé klikkelve hozhatók létre, illetve itt kapcsolhatók ki/be.
![](img/09_vc_viewdidload.png)

> Próbáljuk ki az alap debug funkciókat! (breakpoint létrehozása, `⌘+8`: `Breakpoint Navigator`)

<!-- -->
> Vezessünk be egy hibát a kódba, adjuk hozzá a `UILabel`t saját magához (nyilván ez helytelen művelet).

```swift
//view.addSubview(helloWorldLabel)
helloWorldLabel.addSubview(helloWorldLabel)
```

> Indítsuk el az alkalmazást és figyeljük meg milyen, amikor egy `Exception` keletkezik.

Először a konzolt keressük meg és ezen belül görgessünk oda, ahol az exception leírása olvasható (ez mindig a stack trace előtt található, a konzol log vége felé).

`2017-09-03 13:33:53.703095+0200 Labor1[76117:13889807] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Can't add self as subview'`

A leírás itt elég jó, de azért próbáljuk megnézni pontosan melyik kódsor is dobta hibát. Nyissuk meg a `Debug Navigator`t, ha nem lenne nyitva (`⌘+7`). A probléma, hogy az `AppDelegate` van megjelölve mint az utolsó lefutó kódot tartalmazó osztály. Ez azért van, mert alapesetben, kivételek keletkezése után, ha azt a kivételt nem kapja el semmilyen köztes kód, végül itt, az `AppDelegate` egy (általunk nem látható) kódrészlete lövi ki a szálat.
![](img/10_vc_exception.png)

Szerencsére van lehetőség rá, hogy az exception keletkezéséhez legközelebbi kódrészletnél álljon meg a futás, ehhez Egy `Exception Breakpoint`ot kell létrehozni (ezt minden projektben egyetlen egyszer kell csak megtenni).

`Breakpoint Navigator` (`⌘+8`).
![](img/11_xcode_breakpoint_navigator.png)
Bal alsó sarokban a + gomb.
![](img/12_xcode_exception_breakpoint.png)

> Futtassuk újra az alkalmazást és most már láthatjuk, hogy hol is keletkezett a hiba. Azonban érdemes azt is megfigyelni, hogy ilyenkor még nem jelenik meg a konzolon az exception leírása. Ahhoz, hogy azt megkapjuk "tovább kell engedni" a debuggert a `Continue Program Execution` gomb néhányszori megnyomásával (gyakran nem elég egyszer megnyomni).
![](img/13_xcode_continue_program_execution.png)

### Szöveg testreszabás <a id="szoveg-testreszabas"></a>
A következő kódrészlettel kicsit csinosíthatunk a megjelenítésen.

```swift
helloWorldLabel.textAlignment = .center
helloWorldLabel.textColor = .blue
helloWorldLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1.0)
helloWorldLabel.font = UIFont.preferredFont(forTextStyle: .title1)
```

### Projektbeállítások áttekintése <a id="projektekbeallitasok-attekintese"></a>
A projekt szintű beállításokat a `Project Navigator`ban, a projekt nevére/fejlécére klikkelve hozhatjuk elő.
![](img/14_xcode_project_settings.png)

A jobb oldalt megjelenő listában láthatjuk, hogy a **Labor1** `Project` és az ahhoz tartozó **Labor1** `Target`tel dolgozunk. Több beállítást redundáns módon mind a *Project* mind a *Target* szinten megadhatunk. A *Target* alapból örökli az összes *Project* szintű beállítást, de ha bármit átállítunk *Target* szinten, akkor az fog érvénybe lépni, és felüldefiniálja a *Project* szintű beállításokat.

---

*Egy projekthez több* Target *is tartozhat. A különféle* Target*ekhez különböző fordítási és projektbeállításokat rendelhetünk, így például készíthetünk egy külön* Target*et az alkalmazás ingyenes (Free) változatához és a fizetőshöz (Paid).*

---

A bonyolultabb beállításokat későbbi laborokon részletezzük.

### Alkalmazás ikon beállítása <a id="alkalmazas-ikon-beallitasa"></a>
> Töltsünk le [egy](res/Icon-120.png) `120x120` pixeles `.png` fájlt az internetről és mentsük el a projekt mappájába `Icon-120.png` néven.

<!-- -->
> Válasszuk ki a projekt fájlai közül az `Assets.xcassets` nevű asset katalógust.
![](img/15_assets_xcasset.png)

<!-- -->
> A megjelenő listából válasszuk ki az `AppIcon` elemet, majd húzzuk rá a letöltött `.png` fájlt az `iPhone App iOS 7-10 60pt` `2x` rublikára.

![](img/16_assets_appicon.png)

---

*Az asset katalógusok az alkalmazás képfájljainak csoportosítására szolgálnak. Egy `iOS` alkalmazásban egy képfájlból (ikonból) gyakran több különféle felbontású verzió is kell, ezeket az összetartozó képeket tudjuk hatékonyan együtt kezelni az asset katalógusok segítségével. 
Pl. az `AppIcon` azonosítóhoz hozzárendelhetjük a menüben *(Springboard) *megjelenő `120x120` pixeles változatot, illetve a keresésnél *(Spotlight) *megjelenő kisebb változatokat is.
Ha nem adunk meg az egyik típushoz ikont, akkor a rendszer megpróbálja azt a megadott ikonból legenerálni (átméretezéssel), de ez a legtöbb esetben nem fog hibátlan eredménnyel járni.*

---

---

*Érdemes megjegyezni, hogy `iPhone`-on és `iPad`en eltérő méretű az alkalmazások ikonja.*

---

> A szimulátorban ellenőrizzük, hogy megjelenik-e az új alkalmazás ikon!

### Kezdőképek (*Launch images*) <a id="kezdokepek"></a>
Miközben betöltődik egy `iOS` alkalmazás, egy ún. *Launch Screen* látható. Ezt kétféleképpen lehet megadni.

* Statikus képként az `Assets` katalógusban (hasonlóan az alkalmazás ikonhoz)
* Egy felületleíró `storyboard` fájllal, ami tetszőleges felhasználó felület elemeket tartalmazhat. Ez leginkább dinamikus/interaktív indítóképernyő megadására szolgál.

Fontos, hogy a *Launch Screen* csak addig látszódik, amíg betölt az alkalmazás, ez nem egy "Splash Screen"! Az Apple Design Guidelines tiltja, hogy a töltési folyamatnál hosszabb ideig mutassuk a indítóképernyőt!

Az *Xcode* által generált projekt sémában alapból a `LaunchScreen.storyboard` van beállítva indítóképernyőnek. 

> Nyissuk meg és módosítsuk háttérszínét, pl. zöldre.

### `iPad` támogatás <a id="ipad"></a>
A labor elején létrehozott projekt alapértelmezetten `Universal` alkalmazásként jött létre. 

> Indítsuk el az alkalmazást egy `iPad` szimulátorral és nézzük meg hogy néz ki.

> Állítsuk át a *Devices* beállítást `iPhone`-ra és így is indítsuk el az alkalmazást `iPad` szimulátorral! Mit tapasztalunk? 

<!-- -->
> Ne felejtsük el óra végén feltölteni az elkészült alkalmazást az *GitHub*ra! Indítsuk el a *Terminal*t vagy a *Source Tree* alkalmazást és commitoljuk, illetve pusholjuk fel a saját repository-nkba az elkészült munkát! (Kövessük a laborvezető utasításait.)

### Hasznos Xcode billentyűkombinációk <a id="hasznos-xcode-bill"></a>

| Hasznos Xcode billentyűkombinációk | |
| --- | --- |
| `⌃+Space`/`Esc`    | Kód kiegészítés ("intellisense", autocomplete). |
| `⌃+⌘+Fel`          | Vátlás header/implementáció között. |
| `⌃+⌘+Bal/Jobb`     | Váltás vissza/előre a legutóbb szerkesztett fájlok között. |
| `⌘+⇧+O`            | Gyorskeresés/uggrás fájlnévre vagy szimbólumra. |
| `⌘+⇧+F`            | Keresés sztringre a teljes projektban. |
| `⌃+⌘+klikk`        | A megklikkelt osztály/azonosító definíciójára/deklarációjára való ugrás. |
| `⌥+klikk`          | A megklikkelt osztály rövidített dokumentációjának megjelenítése. |
| `⌘+B`              | Fordítás. |
| `⌘+R`              | Fordítás majd futtatás (debug). |
| `⌘+.`              | Debug session leállítása. |
| `⌃+I`              | Aktuális sor vagy a kijelölt kódrészlet újratördelése (`Re-indent`). |
| `⌘+T`              | Új Tab. |
| `⌘+W`              | Tab bezárása. Ha csak egy tab aktív, akkor az egész projektet bezárja! |
| `⌃+6`              | Jumb bar megnyitása: az aktuális forrásfájl metódusainak gyors áttekintéséhez vagy eléréséhez. |
| `⌘+/`              | Komment ki-/bekapcoslása az aktuális soron vagy kijelölt kódon .|

> Kicsit gyakoroljuk a kódban különféle billentyűkombinációkat (`⌃+⌘+↑`, `^+⌘+←/→`, `⌘+B`, stb.)

## Extra feladatok (idő függvényében) <a id="extra-feladatok"></a>
> Vizsgáljuk meg az *Interface Builder*t és helyezzünk el pár nézetet a `Main.storyboard`on. Ez az alternatívája annak, hogy kódból hozzuk létre a nézeteket. 
> Nézzük meg a `storyboard`ot XML formátumban is!

<!-- -->
> Nyissunk egy új `.playground` fájlt és nézzük meg a Playgroundok alapszolgáltatásait, pl. *Value History* a `sin` függvényhez.

```swift
for i in 0..<100 {
    sin(Double(i) / 10)
}
```
