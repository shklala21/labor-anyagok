# Házi feladat specifikáció információk `2016` ősz 

## A házi feladatról
A házi feladat egy önállóan elkészített `iOS` alkalmazás. Házi feladat készítése nem kötelező, a tárgykövetelményeket házi feladat beadás nélkül is lehet teljesíteni. A házi feladatra megajánlott jegyet adunk, amellyel kiváltható a vizsgázás.

## A megvalósított alkalmazás
A házi feladat célja, hogy a hallgató bizonyítsa vele, hogy elsajátította az `iOS` programozás alapjait és képes önállóan egy kisebb alkalmazás elkészíteni. Bár alapesetben arra számítunk, hogy a megvalósított alkalmazás a félév során készül el, be lehet adni korábban elkészített programot is, de ennek természetesen a hallgató saját munkájának kell lennie és ezt minden esetben ellenőrizzük. A házi feladatokat az utolsó laboron lehet személyesen bemutatni a laborvezetőnek. A kész feladatok forráskódját is kérjük, de ezt bizalmasan kezeljük (sehol sem publikáljuk).

Minimális követelmények a házifeladat-alkalmazáshoz:

* Natív, `Swift`ben írt alkalmazás (a projekt tartalmazhat `Objective-C` kódot is, de a nagyobb részét `Swift`ben kell megírni).
* Több `View Controller`ből álló felhasználói felülettel rendelkezzen.
* Ha nem játék vagy speciális felhasználói felülettel rendelkező alkalmazás, akkor használjon `Auto Layout`ot (alapvetően elég, ha egy alkalmazás vagy csak `iPhone`-ra vagy csak `iPad`re van optimalizálva, de az univerzális alkalmazásokat plusz munkaként értékeljük)!
* A felhasználói felületen túl használjon **legalább hármat**, az alábbi funkciókból (irányszám):
    * Perzisztens adattárolás a program adataihoz (`Core Data`, `SQLite`, sima fájlok)
    * Hálózati kommunikáció, adatok küldése hálózatra vagy adatok fogadása és prezentálása
    * `MapKit` használata
    * Valamilyen saját, komplexebb nézet/felhasználói felület, gesztusok kihasználása
    * `CoreMotion` kihasználása
    * `CoreLocation` kihasználása
    * Játéklogika és/vagy `SpriteKit` használata
    * `OpenGL`
    * `iCloud` támogatás
    * `App Extension` írása (pl. `Home Screen Extension` ~ `Widget`)
    * `Adaptive Layout` vagy univerzális alkalmazás egyedi `iPhone` + `iPad` felülettel
    * Multimédia: videó vagy hang lejátszás/rögzítés

**A megadott szempontok csak irányvonalak, bármilyen egyéb, kellően komplex alkalmazás beadható (konzultálj a laborvezetőddel)!**

## Házi feladat beadása és elbírálása

Minden, házi feladattal kapcsolatos interakció a `GitHub`on történik, a `labor-username` repository-khoz hasonlóan mindenki létre tud magának hozni egy `homework-username` repository-t a [linkre](https://classroom.github.com/assignment-invitations/b386351ae851af5420b9b1b87c2c6132) kattintva.

### Házi feladat specifikáció
Az első lépés a házi feladat specifikáció feltöltése és elfogadtatása. A specifikáció egy rövid, néhány mondatos leírás vagy felsorolás (maximum `1` A4-es oldal), mely tartalmazza a program célját és megvalósítandó funkciókat, valamint a felhasználandó technológiákat. A házi specifikációkat minden esetben átnézzük és egyenként elfogadjuk/visszautasítjuk. Ha valakinek nem fogadjuk el a specifikációját, arról issue-t fogunk kiírni a GitHub repository-jába. Elfogadás esetén a tényt rögzítjük a `README.md` fájlban.

**A specifikáció feltöltésének határideje a 8. oktatási hét vége, vasárnap éjfél: 2016.** A feltöltés az `GitHub`ra történik a `homework-username` reposityory `README.md` fájljába a sablonnak megfelelően.

<p align="center">
<b>A specifikációt <a href="https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet">Markdown</a> formátumban várjuk!</b>
</p>

### Házi feladat beadása
A kész házi feladatot a szorgalmi időszak utolsó hetében kell beadni, szintén a `homework-username` `GitHub` repository-ba. A beadás menetéről és a beadandó anyagokra vonatkozó követelményekről egy külön leírást fogunk feltölteni, mikor ennek eljön az ideje.
