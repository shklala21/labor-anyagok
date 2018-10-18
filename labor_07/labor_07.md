# `iOS` alapú szoftverfejlesztés - Labor `07`

## A labor témája

* [Vezetett labor](#vezetett)
  * [Az `Auto Layout` bemutatása](#auto-layout-bemutatasa)
  * [Adatok elmentése](#adatok-elmentese)
* [Önálló feladat](#onallo)
  * [Scroll View használata](#scroll-view-hasznalata)
* [Szorgalmi feladat](#szorgalmi)
  * [Kezdő képernyő elkészítése](#kezdo-kepernyo)

A labor célja az `Auto Layout` használatának a gyakorlása egy alkalmazás kezdeti képernyőin keresztül.

# Vezetett labor <a id="vezetett"></a>

## Az `Auto Layout` bemutatása <a id="auto-layout-bemutatasa"></a>
> Hozzunk létre egy `Single View App`ot **AutoLayout** névvel a `labor_07` könyvtárba!

<img src="img/create_project.png" style="width: 55%;"/>

<!--  -->
> Állítsuk a `Devices` beállítást `iPhone`-ra (`Target` beállítások, `Deployment Info` szekció). 

<!--  -->
> A `res` mappában található képeket húzzuk be az `Assets.xcassets` katalógusba.

<!--  -->
> A `Main.storyboard`ban állítsuk be a megjelenített eszközt **`iPhone XS`**-re. (A `Storyboard` ezt a méretet fogja szimulálni nekünk.)

<img src="img/default_size_class.png" style="width: 35%;"/>

> A létrejött `View Controller` scene-en lévő `View` *hátterét* állítsuk be valamilyen sötétebb színre, majd tegyünk be felülre egy `Text Field`et vízszintesen középre, használva a segédvonalakat!

<img src="img/text_field.png" style="width: 40%;"/>

> Futtassuk le az alkalmazást a szimulátorban (ne felejtsük el kiválasztani az `iPhone XS` szimulátort) és forgassuk el a kijelzőt!

A szimulátor elforgatásához nyomjuk le a `⌘` + `→` vagy a `⌘` + `←` billentyűkombinációt, attól függően, hogy milyen irányba szeretnénk fordítani a szimulátort.

A `Text Field` sajnos nem maradt középen fekvő módban. Ha azt szeretnénk, hogy középen maradjon, akkor szükség lesz explicit `Auto Layout` kényszerekre.

> Adjunk hozzá a nézetünkhöz egy kényszert, ami biztosítja, hogy horizontálisan középre legyen rendezve. Ehhez jelöljük ki a `Text Field`et és az `Align` menüből válasszuk ki a **`Horizontally in Container`** t, a konstans értéke legyen **0**!

<img src="img/horizontal_center_constraint.png" style="width: 35%;"/>

> Kattintsunk az *Add 1 Constraint* gombra!

Ekkor megváltozik a nézetvezérlő képe és piros vonalak jelennek meg.

<img src="img/missing_auto_layout_constraints.png" style="width: 40%;"/>

A piros vonalakkal az `Xcode` kényszerek hiányát jelzi. Amíg nem adtunk hozzá egyetlen kényszert sem, addig a rendszer fordítási időben implicit kényszereket generál az abszolút pozíció és méret alapján. Azzal, hogy egy kényszert manuálisan hozzáadtunk a nézetünkhöz, a rendszer már nem tudja, hogy milyen egyéb kényszereket generáljon. A problémát a `Document Outline` is mutatja.

<img src="img/document_outline_red_arrow.png" style="width: 25%;"/>

> Kattintsunk rá a piros nyílra!

<img src="img/which_constraint_is_missing.png" style="width: 25%;"/>

A hiba tehát az, hogy az `Auto Layout` motor függőlegesen nem tudja meghatározni a `Text Field` pozícióját.

> Ehhez a `Pin` menüből állítsuk be, hogy a `Safe Area` tetejétől (a legördülőből ki kell választani) mért távolsága **0** legyen! (A `Constrain to margins` legyen **bekapcsolva**!)

<img src="img/text_field_top_pin.png" style="width: 30%;"/><img src="img/text_field_top_pin_selector.png" style="width: 25%;"/>

> Ugyan már nem kapunk figyelmeztetést, de mivel egy nagyobb méretű `Text Field`re van szükségünk, ezért rögzítsük a méretét a `Pin` menü segítségével!

<img src="img/text_field_size_constraints.png" style="width: 30%;"/>

> Futtassuk az alkalmazást és forgassuk el a szimulátort!

<!--  -->
> Állítsuk be a `Text Field` tulajdonságainál *Placeholder*nek a **login** feliratot, majd tegyük lejjebb. Ehhez jelöljük ki, majd módosítsuk a `Safe Area`hoz rögzített kényszert a `Size inspector`ban, *konstansnak* állítsunk be **160**-at!

<img src="img/text_field_safe_area_160.png" style="width: 25%;"/>

> Növeljük meg a `Text Field` horizontális méretét egészen a szaggatott vonalakig mindkét irányba!

<img src="img/text_field_orange_position.png" style="width: 40%;"/>

Mivel explicit méret kényszerek vannak, így a narancssárga vonalakkal azt jelzi a rendszer, hogy futási időben hová fog kerülni az elem. Ahhoz, hogy megtudjuk, hogy pontosan hogyan néz ki az adott képernyő futási időben, nem muszáj folyton a szimulátorban futtatni az alkalmazást.

> Nyissuk meg az `Assistant Editor`t és a felső menüből válasszuk ki a `Preview` funkciót!

<img src="img/preview_assistant_editor.png" style="width: 30%;"/>

Az előnézetet a képernyő alatti ikonnal tudjuk elforgatni.

<img src="img/preview_rotate.png" style="width: 50%;"/>

A bal alsó sarokban található `+` gombbal adjunk hozzá egy másik `iPhone XS` `Preview`-t, így mindkét tájolásban látjuk, hogy fog kinézni az alkalmazás.

Láthatjuk, hogy hiába növeltük meg a méretet a `Storyboard`ban, a kényszerek határozzák majd meg futási időben a méretet.

> Töröljük ki minden kényszert! Ehhez jelöljük ki őket a tervezési területen, a `Document Outline`on, vagy a `Size inspector`ban, majd nyomjuk meg a `Backspace` gombot.

<!--  -->
> Az előző kényszerek helyett rögzítsük a `Safe Area` bal/leading és jobb/trailing szélétől **16** pontra és a  `Safe Area` tetejétől/top **160** pontra!  `Constrain to margins` legyen **kikapcsolva**!

<img src="img/text_field_leading_trailing.png" style="width: 30%;"/>

> Próbáljuk ki az alkalmazást!

<!--  -->
> Tegyünk be alá egy másik `Text Field`et az alsó szaggatott vonalához igazítva! (Jelöljük ki a már meglévő `Text Field`ünket és nyomjuk meg a `Cmd+D` billentyűkombinációt!)

<!--  -->
> A `Document Outline`-ban valamelyik `Text Field`ről a `Ctrl` gombot lenyomva tartva húzzuk az egeret a másik `Text Field`re! A megjelenő ablakban tartsuk lenyomva a `Shift`-et és jelöljük ki **`Leading`** és a **`Trailing`** kényszereket!

<img src="img/text_field_equal_leading_trailing_edges.png" style="width: 25%;"/>

> Jelöljük ki az alsó `Text Field`et és rögzítsük a felette lévő `Text Field`től mért távolságát **Standard**re! `Constrain to margins` legyen **bekapcsolva**!

<img src="img/text_view_top_constraint.png" style="width: 30%;"/><img src="img/text_view_top_constraint_standard.png" style="width: 25%;"/>

> A második `Text Field` tulajdonságainál állítsuk be *Placeholder*nek a **password**öt, és pipáljuk be a *Secure Text Entry*-t!

<!--  -->
> Rakjunk be egy `Label`t az alsó `Text Field` alá, a szövege legyen **Save username**, a színe pedig **fehér**! A pozíció és méret meghatározásához használjuk a következő kényszereket!
>
1. A bal oldalát igazítsuk a felette lévő `Text Field`hez (`Align` / **`Leading Edges`**)
2. A köztük lévő távolságot rögzítsük (`Pin` / **`Vertical Spacing`**) értéke legyen __Standard__!

<img src="img/save_username_label.png" style="width: 40%;"/>

> Ezek után rakjunk be a `Label` mellé egy `Switch`-et és állítsuk be a következőket.
> 
1.  A két elem közepe mindig egy vonalban legyen (`Align` / **`Vertical Centers`**) 
2.  Közöttük mindig **176** egységnyi távolság legyen! Ehhez a `Label`ről indulva a `Ctrl` gomb lenyomása mellett húzzunk át a `Switch`-re és válasszuk a **`Horizontal Spacing`** gombot, majd jelöljük ki az újonnan létrejött kényszert és a tulajdonságainál a konstansát állítsuk át **176**-ra!

<img src="img/save_username_switch.png" style="width: 40%;"/>

> Végül emeljünk be egy új `Button`t az elemek alá középre, a szövegét állítsuk **Login**-re, igazítsuk középre (`Align` / **`Horizontally in Container`**, **0** konstans értékkel) és rögzítsük a távolságot a felette lévő password `Text Field`hez képest **1.2 * Standard** egységre (`Pin` / **`Vertical Spacing`**, majd multiplier átírása **1.2**-re).

<img src="img/login_button_vertical_spacing.png" style="width: 40%;"/>

<img src="img/finished_ui.png" style="width: 40%;"/>

> Futtassuk le az alkalmazást! Láthatjuk, hogy elforgatva is használható, de nem néz jól ki!

Az Xcode-ban lehetőségünk van az alkalmazást speciális módban futtatni, megnézhetjük, hogy hogyan nézne ki dupla olyan hosszú szöveges erőforrásokkal, illetve hogyan nézne ki RTL (Right To Left) módban. Ezeket a scheme beállításoknál tudjuk átírni.

> Nyissuk meg a sémabeállításokat! Kattintsunk a bal felső sarokban az `AutoLayout`-ra és válasszuk az `Edit Scheme...` menüpontot!

<img src="img/edit_scheme.png" style="width: 20%;"/>
<img src="img/scheme_settings.png" style="width: 70%;"/>

> Állítsuk át az *Application Language*-et **Double-Length Pseudolanguage**-re és futtassuk újra az alkalmazást!

<img src="img/double_length_pseudolanguage.png" style="width: 30%;"/>

Azt tapasztaljuk, hogy `portrait` módban eltűnt a `Switch`! Szerencsére az `Auto Layout` segítségével könnyedén tudjuk kezelni a dinamikus változásokat is a kényszerek prioritásai segítségével. Itt olyan kényszerekre van szükségünk, hogy “ha lehetőség van rá, akkor a `Label` és a `Switch` közti távolság legyen valamekkora, de a `Switch` és a képernyő széle között mindig legyen legalább **16** egységnyi távolság”. Az első kényszernek kisebb lesz a prioritása, mert a második kényszer fontosabb.

> Ehhez jelöljük ki a `Switch`-et és rögzítsük a `Safe Area`-tól **16** távolságra (`Pin` / **`Trailing Space To Safe Area`**).

<!--  -->
> A kettő közti távolság kényszerének a *relation*jét állítsuk **Greater Than or Equal**re, a *prioritását* vegyünk le **750**-re, a *konstans*át pedig **50**-re!

<img src="img/label_text_field_constraint.png" style="width: 25%;"/>

<img src="img/fixed_ui.png" style="width: 40%;"/>

> Próbáljuk ki az alkalmazást ismét, majd állítsuk vissza a sémabeállításoknál az *Application Language*-et **System Language**-re!

<!--  -->
> Tegyünk be egy `Image View`-t a `Text Field` fölé **343x150**-es méretben középre!
> Adjunk hozzá egy középre rendezést biztosító kényszert (`Align` / **`Horizontally in Container`**), majd rögzítsük a méreteit (`Pin` / **`Width`** és **`Height`**)
> Végül pedig a `Safe Area` tetejétől mért távolsága legyen **0** (`Pin`).

<!--  -->
> Ezek után a felső `Text Field`hez adjuk hozzá egy kényszert, ami a képtől mért távolságot rögzíti **15** egységre.

Ez ellentmond a `Text Field` másik kényszerének, ami `Safe Area` tetejétől miért távolságát rögzíti, ezt piros színnel jelzi a rendszer.

<img src="img/conflicting_constraints.png" style="width: 40%;"/>

Ha futtatjuk az alkalmazást, akkor hiba nélkül fut, ugyanakkor a konzolban láthatjuk, hogy a kényszereink egy időben nem teljesíthetők.

> Töröljük hát a `Safe Area` és a `Text Field` teteje közti távolság kényszert!

<!--  -->
> Képnek állítsuk be az `AUTLogoBlack` képet és állítsuk a `Content Mode`-ot **`Aspect Fit`** re!

<!--  -->
> Futtassuk az alkalmazást és kattintsunk bele a `Text Field`ekbe. (Ha nem jelenne meg a billentyűezet, akkor nyomjuk meg a `⌘` + `K` billentyűkombinációt, vagy a `Simulator` menüjéből válasszuk ki a `Hardware/Keyboard/Toggle Software Keyboard` menüpontot.)

Azt látjuk, hogy `landscape` módban az alsó `Text Field`et kitakarja a billentyűzet.

Erre a legegyszerűbb megoldás, ha billentyűzet megjelenésekor minden elemet feltolunk. Függőlegesen minden elem valójában a `Image View`-hoz igazodik, így ennek a pozícióját kell változtatni a billentyűzet láthatóságának függvényében.

> Hozzunk létre egy új **`LoginViewController`** osztályt és állítsuk ezt be a `Storyboard`ban a nézetvezérlő osztályának (`Identity inspector`). (Ezután kitörölhetjük a `ViewController.swift` fájlt, ugyanis nem lesz rá szükségünk: *Move to Trash*)

<!--  -->
> Vegyünk fel egy `Outlet`et a kép teteje és a `Safe Area` közötti kényszerhez! Ehhez jelöljük ki a kényszert, majd a szokásos módon húzzuk át a `LoginViewController.swift` fájlba az `Assistant Editor`ban. Az `Outlet` neve legyen **`imageViewTopConstraint`**.

<!--  -->
> Továbbá vegyünk fel még két `Outlet`et a felső `Text Field`hez **`usernameTextField`** néven és az alsó `Text Field`hez **`passwordTextField`** néven!

<!--  -->
> Ezek után iratkozzunk fel, illetve le a billentyűzet megjelenése és eltűnése rendszer eseményekre a `viewWillAppear(_:)` és `viewVillDisapear(_:)` metódusokban!

```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
  NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
}

override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)
  NotificationCenter.default.removeObserver(self)
}
```

> Valósítsuk meg a két függvényt!

```swift
@objc private func keyboardWillShow(notification: Notification) {
  if let userInfo = notification.userInfo, let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
    if passwordTextField.frame.maxY > (view.frame.height - keyboardSize.height) {
      imageViewTopConstraint.constant = -1 * (passwordTextField.frame.maxY - (view.frame.height - keyboardSize.height))
    }
  }
}

@objc private func keyboardWillHide(notification: Notification) {
  imageViewTopConstraint.constant = 0
}
```

> Végül pedig vegyük fel a `Text Field` eltűntetésért felelős `Did End On Exit` esemény metódusát és kössük be mindkét `Text Field`hez! Ehhez használjuk a *Connections inspector*t!
```swift
@IBAction func editingDidEndOnExit(_ sender: UITextField) {
    sender.resignFirstResponder()
}
```

<!--  -->
> Próbáljuk ki az alkalmazást!

Sokat javít a felhasználói élményen, ha a konstans beállítása nem azonnal, hanem *animálva* történik.

```swift
@objc private func keyboardWillShow(notification: Notification) {
  if let userInfo = notification.userInfo,
    let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
    let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
    if passwordTextField.frame.maxY > (view.frame.height - keyboardSize.height) {
      UIView.animate(withDuration: duration, animations: {
        self.imageViewTopConstraint.constant = -1 * (self.passwordTextField.frame.maxY - (self.view.frame.height - keyboardSize.height))
        self.view.layoutIfNeeded()
      })
    }
  }
}

@objc private func keyboardWillHide(notification: Notification) {
  if let userInfo = notification.userInfo,
    let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
    UIView.animate(withDuration: duration) {
      self.imageViewTopConstraint.constant = 0
      self.view.layoutIfNeeded()
    }
  }
}
```

Elképzelhető, hogy az animációk nem jelennek meg szépen a szimulátorban, aki teheti próbálja ki eszközön is!

# Adatok elmentése <a id="adatok-elmentese"></a>
Az `Auto Layout`tól való pihenésképpen valósítsuk meg, hogy a felhasználónév mentése valóban működjön! Az adatok tárolására a `User Defaults`ot fogjuk használni. 

<!--  -->
> Hozzunk létre a `Switch`-hez egy **`saveUsernameSwitch`** `Outlet`et! Kössünk be egy `Action`t is a `Login` gomb megnyomására `loginButtonTapped` szignatúrával, majd adjuk hozzá a következő implementációt!

<img src="img/login_button_action.png" style="width: 25%;"/>

```swift
@IBAction func loginButtonTapped() {
  let alertController = UIAlertController(title: "Successful login!", message: "Congratulation!", preferredStyle: .alert)
  let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
  alertController.addAction(defaultAction)
  present(alertController, animated: true, completion: nil)

  UserDefaults.standard.set(saveUsernameSwitch.isOn, forKey: "usernameSaved")
  if saveUsernameSwitch.isOn {
    UserDefaults.standard.set(usernameTextField.text, forKey: "username")
  }
}
```

> Végül a `viewDidLoad()`-ot is frissítsük!

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  saveUsernameSwitch.setOn(UserDefaults.standard.bool(forKey: "usernameSaved"), animated: false)
  if saveUsernameSwitch.isOn {
    usernameTextField.text = UserDefaults.standard.value(forKey: "username") as? String
  }
}
```

> Próbáljuk ki az alkalmazást! Ne felejtsünk el rányomni a gombra a mentéshez.

# Önálló feladat <a id="onallo"></a>

## Scroll View használata <a id="scroll-view-hasznalata"></a>
> Tegyünk be egy új `View Controller`t, amit állítsunk be kezdő `View Controller`nek (*Initial View Controller*)! A `View Controller` tulajdonságainál kapcsoljuk ki az *Adjust Scroll View Insets* property-t!

<img src="img/initial_vc_scrollview_insets.png" style="width: 25%;"/>

<!--  -->
> A gyökérnézetbe helyezzünk el egy `Scroll View`-t, úgy, hogy kitöltse a teljes rendelkezésre álló területet és állítsunk be olyan kényszereket, hogy minden oldala és a `Safe Area` közötti távolság **0** legyen!

<img src="img/scroll_view_constraints.png" style="width: 30%;"/>

<!--  -->
> Tegyünk be a `Scroll View`-ba egy `Vertical Stack View`-t és úgy, hogy kitöltse a teljes rendelkezésre álló területet és állítsunk be olyan kényszereket, hogy az oldalai és a `Scroll View` közötti távolság **0** legyen! (*Constrain to margins* **kikapcsolva**)

> Állítsuk be a `Stack View` szélessége megegyezzen a gyökér `View` szélességével (**Equal Widths**)!

<!--  -->
> Tegyünk be a `Stack View`-ba egy `Image View`-t felülre és állítsuk be háttérképnek a `BMEQBuilding.jpeg` képet, a *Content Mode*-ot pedig **Aspect Fit**re!

<!--  -->
> A `Image View`-ra állítsuk be, hogy a magassága megegyezzen a gyökér `View` magasságával: **Equal Heights**, majd szerkesszük ennek a kényszernek a *multiplier* property-jét és állítsuk **`0.3`**-ra. (Az **Equal Heights** beállításánál az `Image View`-ból indítsuk a `Ctrl + draget`!)

Ezzel azt értük el, hogy az Image View magassága a mindenkori View magasságának a 30%-a lesz.

> Helyezzünk be egy `Label`t a kép alá!

> A `Label` tulajdonságainál állítsuk be, hogy több soros szöveget tartalmaz. Ehhez a *Line Break* mode-ot állítsuk **`Word Wrap`** re, a *Lines*t pedig **0**-ra!

<!--  -->
> A `Label` szövegéhez másoljuk be a `AUT` portálon lévő [*Rólunk*](https://www.aut.bme.hu/Pages/AboutUs) szövegét `kétszer`!

<!--  -->
> Próbáljuk ki az alkalmazást! Forgassuk el, ellenőrizzük, hogy mindkét tájolásban scrollozható.

A `Scroll View`-nk így már görgethető és működik is, viszont elég csúnyán néz ki, hogy a szöveg edge-to-edge jelenik meg.

> Erre egy lehetséges megoldás, hogy a `Stack View` *Layout Margins* property-jét **Language Directional**re állítjuk a következő értékekkel:

* *Leading*: **20**
* *Top*: **8**
* *Bottom*: **8**
* *Trailing*: **20**

<!--  -->
> Ágyazzuk be egy `Navigaton Controller`be a nézetvezérlőt. Ekkor a teljes nézet lejjebb csúszik, mivel megváltozik a `Safe Area` tetejének pozíciója.

# Szorgalmi feladat <a id="szorgalmi"></a>

## Kezdő képernyő elkészítése <a id="kezdo-kepernyo"></a>
> Készítsük el a következő képernyőt `Auto Layout` kényszerek segítségével és valósítsuk meg a gombok működését!

<img src="img/desired_ui.png" style="width: 40%;"/>

Segítség a képernyő felépítéséhez:

* Alapja kettő azonos magasságú konténer `View`, melyek szélességben kitöltik a rendelkezésre álló teret és a köztük lévő távolság **0**. Fontos, hogy ezeket a kényszereket ne a `Safe Area`hoz, hanem a gyökér `View`-hoz kössük.
* A felső konténer `View` háttere vörös (*RGB:* **124, 6, 64**), az alsójé szürke (*RGB:* **102, 102, 102**).
* A felső konténer tartalmaz egy képet (`Image View`), amely kitölti a rendelkezésre álló területet (a felső kényszert a `Safe Area`hoz kössük!), ugyanakkor nem torzítja a képet.
* Az alsó konténer két középre rendezett gombot tartalmaz, amely vertikális pozíciója is rögzített (ezeket viszonylag magasan helyezzük el a konténerben).
* Az alsó konténer tartalmaz továbbá egy alulra pozícionált **© Minden jog fenntartva. BME AUT** szöveget, melyet a `Safe Area`hoz kössünk.
* A felületet mindkét tájolásban próbáljuk ki!

A végső flow így nézzen ki!

<img src="img/desired_flow.png" style="width: 60%;"/>

# A laborsegédletet összeállította
* Krassay Péter - krassay.peter@autsoft.hu
* Dávid Márk Tamás - david.tamas@autsoft.hu
* Varga Domonkos - varga.domonkos@autsoft.hu
* Szücs Zoltán - szucs.zoltan@autsoft.hu
* Kántor Tibor - tibor.kantor@autsoft.hu
