# Fabryka Punktów ECTS – Centrum Logistyczne Wydziału (USOS-Web)

Projekt z przedmiotu: **Języki Programowania – Ada**  
Autorzy: **Bartosz Miazek, Bartosz Łada, Bartłomiej Żebrowski**

---

## 1. Opis projektu

Projekt przedstawia współbieżną symulację obiegu protokołów zaliczeniowych i punktów ECTS na wydziale uczelni.

W systemie przetwarzane są 3 typy punktów:
* **ECTS Wykład (Teoria)** – oceny z egzaminów i kolokwiów teoretycznych,
* **ECTS Laboratorium (Praktyka)** – zaliczenia ćwiczeń laboratoryjnych,
* **ECTS Projekt (Inżynieria)** – oceny z projektów semestralnych.

### Przebieg symulacji
1. **Wykładowcy** przywożą protokoły ocen do **Portierni / Okienka Podawczego**.
2. **Portiernia** przyjmuje wykładowców, weryfikuje dokumenty i umieszcza je w kolejce FIFO (skrzynce podawczej).
3. **Studenci-Starostowie (S1, S2, S3)** pobierają protokoły ze skrzynki i rejestrują je w **Centralnej Bazie USOS w Dziekanacie**.
4. **Bufet Studencki** pozwala studentom uzupełnić poziom kofeiny (każdy kurs zużywa 25% energii; poniżej lub przy 25% student idzie na kawę).
5. **Monitor USOS-Web** cyklicznie wyświetla raport z przebiegu sesji, stanu bazy USOS oraz statusu studentów.

---

## 2. Zrealizowane moduły

Projekt składa się z 3 modułów podstawowych oraz 3 modułów dodatkowych:

### Moduły podstawowe
* **Moduł 1: Wykładowcy i Portiernia** (`src/base_modules/lecturers.adb`, `src/base_modules/unloading_dock.adb`)
  * Wykładowcy dostarczają protokoły z określonym rodzajem i liczbą punktów ECTS.
  * Portiernia działa jako osobne zadanie (`Unloading_Dock_Task`), obsługuje wykładowców i buforuje protokoły w kolejce FIFO.
* **Moduł 2: Studenci-Starostowie** (`src/base_modules/students.adb`)
  * 3 współbieżne zadania studentów (`Student_Type`) realizujące pobieranie protokołów, przenoszenie ich do dziekanatu oraz rejestrację.
* **Moduł 3: Baza USOS / Dziekanat** (`src/base_modules/warehouse.adb`)
  * Zadanie `Warehouse_Task` przechowujące stan punktów ECTS z ograniczeniem rocznym (60 ECTS).

### Moduły dodatkowe
* **Moduł E: Bufet studencki (Automat z kawą)** (`src/extra_modules/coffee_station.adb`)
  * 1-stanowiskowy ekspres (`Coffee_Station_Task`), w którym studenci regenerują energię do 100%.
* **Moduł G: Monitor stanu sesji (USOS-Web)** (`src/extra_modules/monitor.adb`)
  * Zadanie `Monitor_Task` cyklicznie (co 3 sekundy) zbiera dane z systemu i wypisuje status w terminalu.
* **Moduł H: Zniecierpliwiony wykładowca** (`src/extra_modules/impatient_lecturers.adb`)
  * Zadanie `Impatient_Lecturer_Type` (Docent Pośpiech) oczekujące na wolne okienko przez ograniczony czas (Timed Entry Call). W razie braku wolnego miejsca rezygnuje z kolejki.

---

## 3. Elementy współbieżności w języku Ada

* **Zadania (`task`):** `Lecturer_Type`, `Impatient_Lecturer_Type`, `Student_Type`, `Unloading_Dock_Task`, `Warehouse_Task`, `Coffee_Station_Task`, `Monitor_Task`.
* **Obiekty chronione (`protected`):**
  * `Screen_Logger` – wątkowo-bezpieczne logowanie z timestampami,
  * `Student_Registry` – rejestr stanów i poziomu energii studentów dla monitora,
  * `Delivery_Stats` – zliczanie przyjętych i odrzuconych protokołów,
  * `Random_Gen` – generator liczb losowych oparty o `Ada.Numerics.Float_Random`.

### Wykorzystane konstrukcje `select`
1. **Selective Accept z dozorem (`when`)**:
   * w `Warehouse_Task` (blokada przyjęcia powyżej limitu 60 ECTS),
   * w `Unloading_Dock_Task` (przyjmowanie wykładowców tylko przy wolnym miejscu w buforze).
2. **Conditional Entry Call (`select ... else`)**:
   * w zadaniach studentów przy sprawdzaniu, czy w portierni czeka nowy protokół.
3. **Timed Entry Call (`select ... or delay`)**:
   * w zadaniu zniecierpliwionego wykładowcy przy oczekiwaniu na okienko portierni,
   * w zadaniach studentów przy rejestracji w dziekanacie (ochrona przed zablokowaniem w przypadku wyczerpania limitu bazy).

---

## 4. Struktura plików

```text
.
├── alire.toml
├── ada_projekt.gpr
├── run.sh
├── README.md
└── src/
    ├── main.adb
    ├── common/
    │   ├── ects_types.ads / .adb
    │   ├── delivery_stats.ads / .adb
    │   ├── random_utils.ads / .adb
    │   └── logger.ads / .adb
    ├── base_modules/
    │   ├── lecturers.ads / .adb
    │   ├── unloading_dock.ads / .adb
    │   ├── students.ads / .adb
    │   └── warehouse.ads / .adb
    └── extra_modules/
        ├── coffee_station.ads / .adb
        ├── monitor.ads / .adb
        └── impatient_lecturers.ads / .adb
```

---

## 5. Kompilacja i uruchomienie

Uruchomienie za pomocą skryptu:
```bash
./run.sh
```

Lub bezpośrednio za pomocą Alire:
```bash
alr build
alr run
```
