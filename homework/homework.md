# Házi feladat tudnivalók `2018` ősz

## A házi feladatról
A házi feladat egy önállóan elkészített `iOS` alkalmazás. Házi feladat készítése nem kötelező, a tárgykövetelményeket házi feladat beadás nélkül is lehet teljesíteni. A házi feladatra megajánlott jegyet adunk, amellyel kiváltható a vizsgázás.

Minden, házi feladattal kapcsolatos interakció a `GitHub`on történik, a `labor-username` repository-khoz hasonlóan mindenki létre tud magának hozni egy `hazi-feladat-username` repository-t a **[linkre](https://classroom.github.com/a/Fw794ECW)** kattintva.

## A megvalósított alkalmazás
A házi feladat célja, hogy a hallgató bizonyítsa vele, hogy elsajátította az `iOS` programozás alapjait és képes önállóan egy kisebb alkalmazást elkészíteni. Bár alapesetben arra számítunk, hogy a megvalósított alkalmazás a félév során készül el, be lehet adni korábban elkészített programot is, de ennek természetesen a hallgató saját munkájának kell lennie és ezt minden esetben ellenőrizzük. A házi feladatokat az utolsó laboron lehet személyesen bemutatni a laborvezetőnek. A kész feladatok forráskódját is kérjük, de ezt bizalmasan kezeljük (sehol sem publikáljuk).

Minimális követelmények a házifeladat-alkalmazáshoz:

* Natív, `Swift`ben írt alkalmazás (a projekt tartalmazhat `Objective-C` kódot is, de a nagyobb részét `Swift`ben kell megírni).
* Több `View Controller`ből álló felhasználói felülettel rendelkezzen.
* Ha nem játék vagy speciális felhasználói felülettel rendelkező alkalmazás, akkor használjon `Auto Layout`ot (alapvetően elég, ha egy alkalmazás vagy csak `iPhone`-ra vagy csak `iPad`re van optimalizálva, de az univerzális alkalmazásokat plusz munkaként értékeljük)!
* A felhasználói felületen túl használjon **legalább hármat**, az alábbi funkciókból (irányszám):
    * Perzisztens adattárolás a program adataihoz (`Core Data`, `SQLite`, sima fájlok),
    * Hálózati kommunikáció, adatok küldése hálózatra vagy adatok fogadása és prezentálása,
    * `MapKit` használata,
    * Valamilyen saját, komplexebb nézet/felhasználói felület, gesztusok kihasználása,
    * `CoreMotion` kihasználása,
    * `CoreLocation` kihasználása,
    * Játéklogika és/vagy `SpriteKit` használata,
    * `ARKit`,
    * `Metal`,
    * `iCloud` támogatás,
    * `App Extension` írása (pl. `Home Screen Extension` ~ `Widget`),
    * `Adaptive Layout` vagy univerzális alkalmazás egyedi `iPhone` + `iPad` felülettel,
    * Multimédia: videó vagy hang lejátszás/rögzítés.

**A megadott szempontok csak irányvonalak, bármilyen egyéb, kellően komplex alkalmazás beadható (konzultálj a laborvezetőddel)!**

## Specifikáció

Az első lépés a házi feladat specifikáció feltöltése és elfogadtatása. A specifikáció egy rövid, néhány mondatos leírás vagy felsorolás (maximum `1` A4-es oldal), mely tartalmazza a program célját és megvalósítandó funkciókat, valamint a felhasználandó technológiákat. A házi specifikációkat minden esetben átnézzük és egyenként elfogadjuk/visszautasítjuk. Ha valakinek nem fogadjuk el a specifikációját, arról issue-t fogunk kiírni a `GitHub` repository-jába. Elfogadás esetén a tényt rögzítjük a `README.md` fájlban.

**A specifikáció feltöltésének határideje a 9. oktatási hét vége, vasárnap éjfél: 2018. november 04. 23:59** A feltöltés a `GitHub`ra történik a `hazi-feladat-username` repository `README.md` fájljába a sablonnak megfelelően.

<p align="center">
    <b>A specifikációt <a href="https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet">Markdown</a> formátumban várjuk!</b>
</p>

## Beadás
__A házi feladatot 2018. december 6. 12:00-ig kell feltölteni a saját `GitHub` repository-ba.__ A feltöltött projekt mellett mindenkitől várunk a `README.md` fájlba egy nagyjából egy oldalas projekt leírást is __Markdown__ formátumban. Ennek az alkalmazás rövid leírását kell tartalmaznia `3` db jellemző képernyőkép mellett.

### Bemutatás
A házi feladatot az utolsó labor idejében (december 6. 12-14 vagy 14-16) a laborvezetőnek kell bemutatni **személyesen**. Ez feltétele a házi feladat elfogadásának.

### Késedelmes beadás
Késedelmes beadás esetén a vizsgaidőszak utolsó vizsgája előtti napig lehet bemutatni a házit a laborvezetővel előre egyeztett időpontban. A határidőn túli házi beadás pótdíját a Neptunon keresztül kell befizetni. Ha valaki késedelmes beadással szeretne élni, ezt legkésőbb az utolsó előtti labor végéig jelezze a laborvezetőjének és a tárgy előadóinak **írásos formában**.

### Megajánlott jegy
Aki megajánlott jegyet szerzett, fel kell vennie egy vizsgát, különben a jegyet nem tudjuk beírni. A vizsgára nem kell eljönnie.
