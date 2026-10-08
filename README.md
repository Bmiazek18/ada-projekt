# 🎓 Fabryka Punktów ECTS – Centrum Logistyczne Wydziału (USOS-Web) w języku Ada

Projekt z przedmiotu: **Języki Programowania – Ada (2026/27)**  
Autor: **Bartosz Miazek, Bartosz Łada, Bartłomiej Żebrowski**

---

## 📑 Spis treści
1. [Opis scenariusza](#-1-opis-scenariusza)
2. [Struktura modułów](#-2-struktura-modułów)
3. [Realizacja wymagań technicznych języka Ada](#-3-realizacja-wymagań-technicznych-języka-ada)
4. [Diagramy architektury i przepływu danych](#-4-diagramy-architektury-i-przepływu-danych)
5. [Drzewo plików projektu](#-5-drzewo-plików-projektu)
6. [Instrukcja kompilacji i uruchomienia](#-6-instrukcja-kompilacji-i-uruchomienia)
7. [Przykładowe wyjście symulacji w konsoli](#-7-przykładowe-wyjście-symulacji-w-konsoli)

---

## 🎯 1. Opis scenariusza

Symulacja przedstawia autonomiczne centrum logistyczne sesji egzaminacyjnej na wydziale uczelni, zajmujące się wprowadzaniem i magazynowaniem punktów ECTS w systemie USOS.

W centrum przetwarzane są **3 różne rodzaje punktów ECTS**:
1. 📘 **ECTS Wykład (Teoria)** – oceny z egzaminów i kolokwiów teoretycznych.
2. 🔬 **ECTS Laboratorium (Praktyka)** – zaliczenia wejściówek, ćwiczeń i sprawozdań laboratoryjnych.
3. 💻 **ECTS Projekt (Inżynieria)** – oceny z projektów semestralnych i obron oprogramowania.

### Przebieg procesu:
1. **Prowadzący Katedr** (Profesorowie, Doktorzy, Magistrowie) przywożą teczki z protokołami ocen do **Portierni / Okienka Podawczego Wydziału** (Moduł 1).
2. **Portiernia** przyjmuje wykładowców, stempluje protokoły i umieszcza je w skrzynce podawczej.
3. **Studenci-Starostowie (S1 - Starosta, S2 - Wice-starosta, S3 - Stażysta)** (Moduł 2: Roboty transportowe) pobierają protokoły ze skrzynki, biegną korytarzem i rejestrują je w **Centralnej Bazie USOS w Dziekanacie** (Moduł 3: Magazyn).
4. **Bufet Studencki / Automat z Kawą** (Moduł E: Ładowanie) dba o poziom kofeiny studentów (kurs zużywa 25% energii; przy $\le 25\%$ student idzie na podwójne Espresso).
5. **System USOS-Web na żywo** (Moduł G: Monitor) cyklicznie generuje i wyświetla w terminalu całościowy raport postępu sesji, stanu bazy USOS oraz dyżuru studentów.

---

## 🧩 2. Struktura modułów

Zgodnie z wymaganiami projekt realizuje **3 moduły podstawowe** oraz **3 wybrane moduły dodatkowe**:

### A. Moduły podstawowe (wymagane)
* **MODUŁ 1: Dostawy i stanowisko rozładunkowe (Wykładowcy i Portiernia)** (`src/base_modules/lecturers.adb`, `src/base_modules/unloading_dock.adb`)
  * Wykładowcy (Prof. Janusz, Dr Kowalski, Mgr Nowak...) przywożą protokoły z ocenami (ID, rodzaj ECTS, ilość punktów).
  * Portiernia wydziału działa jako osobne zadanie (`Unloading_Dock_Task`), obsługuje wykładowców i buforuje teczki dla studentów.
* **MODUŁ 2: Studenci-Starostowie ECTS (Roboty transportowe AGV)** (`src/base_modules/students.adb`)
  * 3 współbieżne zadania studentów (`Student_Type`) realizujące cykl: oczekiwanie ➔ pobranie protokołu z portierni ➔ bieg korytarzem ➔ rejestracja w USOS ➔ powrót na dyżur.
* **MODUŁ 3: Baza USOS / Dziekanat (Magazyn Główny ECTS)** (`src/base_modules/warehouse.adb`)
  * Jedno osobne zadanie (`Warehouse_Task`) zarządzające stanem sesji dla 3 rodzajów punktów ECTS z rocznym limitem etapu (60 ECTS).

### B. Wybrane 3 moduły dodatkowe
* **MODUŁ E: Automat z kawą w bufecie (Ładowanie robotów)** (`src/extra_modules/coffee_station.adb`)
  * Studenci posiadają poziom kofeiny (0–100%). Każdy zaniesiony protokół zużywa 25% energii.
  * Gdy poziom energii spadnie do $\le 25\%$, student udaje się do 1-stanowiskowego ekspresu w bufecie `Coffee_Station_Task`, zamawia kawę, regeneruje się do 100% i powraca do pracy.
* **MODUŁ G: Kontroler / Monitor centrum (System USOS-Web)** (`src/extra_modules/monitor.adb`)
  * Osobne zadanie `Monitor_Task` cyklicznie (co 3 sekundy) odpytuje moduły wydziału i wyświetla tabelaryczny raport postępu sesji, portierni, kofeiny studentów oraz statystyk protokołów.
* **MODUŁ H: Zniecierpliwiony Wykładowca (Samochody rezygnujące z oczekiwania)** (`src/extra_modules/impatient_lecturers.adb`)
  * Zaimplementowano zadanie `Impatient_Lecturer_Type` (Docent Pośpiech) wykorzystujące konstrukcję **Timed Entry Call**.
  * Docent Pośpiech z krótkim czasem cierpliwości (0.9s) w razie kolejki do okienka rezygnuje z czekania, wpisuje studentom NZAL i odjeżdża na konferencję.

---

## ⚙️ 3. Realizacja wymagań technicznych języka Ada

### 1. Współbieżność (`task` oraz obiekty chronione `protected`)
* **Zadania współbieżne:** `Lecturer_Type`, `Impatient_Lecturer_Type`, `Student_Type`, `Unloading_Dock_Task`, `Warehouse_Task`, `Coffee_Station_Task`, `Monitor_Task`.
* **Obiekty chronione:** 
  * `Screen_Logger` – wątkowo-bezpieczne wypisywanie komunikatów z formatem czasu `[SS.s]`,
  * `Student_Registry` – bezpieczne odczytywanie statusów i poziomów kofeiny przez monitor,
  * `Delivery_Stats` – zliczanie wprowadzonych i odrzuconych protokołów.

### 2. 3 RÓŻNE rodzaje konstrukcji `select` (Wymóg kluczowy)

1. **Selective Accept z dozorem (`when`) i alternatywami** – w serwerze USOS i Portierni:
   ```ada
   -- Plik: src/base_modules/warehouse.adb
   select
      when Current_Total + 1 <= Max_Capacity =>
         accept Store_Items (Delivery : in Delivery_Record; Accepted : out Boolean) do
            ...
         end Store_Items;
   or
      accept Get_Stock (...) do ... end Get_Stock;
   or
      accept Stop do Running := False; end Stop;
   end select;
   ```

2. **Conditional Entry Call (wywołanie warunkowe `select ... else`)** – w zadaniach studentów:
   ```ada
   -- Plik: src/base_modules/students.adb
   -- Student nie blokuje watku, jesli w portierni nie ma nowych teczek
   select
      Unloading_Dock.Unloading_Dock_Task.Take_Work_Order (Order, Has_Order);
   else
      Has_Order := False;
   end select;
   ```

3. **Timed Entry Call (wywołanie terminowane `select ... or delay`)** – w zniecierpliwionym wykładowcy (Moduł H):
   ```ada
   -- Plik: src/extra_modules/impatient_lecturers.adb
   -- Docent Pośpiech oczekuje na okienko max 0.9s, po czym rezygnuje
   select
      Unloading_Dock.Unloading_Dock_Task.Request_Unload (Delivery, Accepted);
   or
      delay Patience_Time;
      Delivery_Stats.Stats.Register_Timeout;
      Logger.Screen_Logger.Log (Lecturer & " ZREZYGNOWAL Z OCZEKIWANIA - Odjazd!");
   end select;
   ```

### 3. Dozory wejść (`when condition => accept`)
* Zastosowane w `Warehouse_Task` do kontroli limitu 60 ECTS roku akademickiego.
* Zastosowane w `Unloading_Dock_Task` do kontroli pojemności skrzynki podawczej portierni.

---

## 📊 4. Diagramy architektury i przepływu danych

TODO: take prooth diagram

---

## 📁 5. Drzewo plików projektu

```text
ada projekt/
├── alire.toml                              # Konfiguracja pakietu Alire
├── ada_projekt.gpr                         # Plik projektu GNAT (wyszukiwanie rekurencyjne src/**)
├── run.sh                                  # Wykonywalny skrypt Bash (kompilacja + uruchomienie)
├── README.md                               # Pełna dokumentacja projektu
├── .vscode/
│   └── tasks.json                          # Konfiguracja zadań kompilacji w VS Code (Cmd+Shift+B)
│
└── src/
    ├── main.adb                            # Główny program koordynujący symulację
    │
    ├── common/                             # Moduły wspólne
    │   ├── ects_types.ads / .adb           # Definicje typów punktów ECTS, stanów studenta, rekordów
    │   ├── delivery_stats.ads / .adb       # Obiekt chroniony statystyk wprowadzonych/odrzuconych protokołów
    │   └── logger.ads / .adb               # Obiekt chroniony Screen_Logger (wątkowo-bezpieczny, timestampy)
    │
    ├── base_modules/                       # 3 Moduły podstawowe
    │   ├── lecturers.ads / .adb            # MODUŁ 1: Wykładowcy przywożący protokoły ocen
    │   ├── unloading_dock.ads / .adb       # MODUŁ 1: Portiernia / Okienko podawcze (bufor FIFO + dozór)
    │   ├── students.ads / .adb             # MODUŁ 2: Studenci-Starostowie ECTS (S1, S2, S3)
    │   └── warehouse.ads / .adb            # MODUŁ 3: Centralna Baza USOS Dziekanatu (limit 60 ECTS, dozór WHEN)
    │
    └── extra_modules/                      # 3 Wybrane moduły dodatkowe
        ├── coffee_station.ads / .adb       # MODUŁ E: 1-stanowiskowy ekspres do kawy w bufecie studenckim
        ├── monitor.ads / .adb              # MODUŁ G: System USOS-Web (raport stanu sesji na żywo)
        └── impatient_lecturers.ads / .adb  # MODUŁ H: Zniecierpliwiony Wykładowca (Doc. Pośpiech - Timed Entry Call)
```

---

## 🚀 6. Instrukcja kompilacji i uruchomienia

Skryptem Bash 
W głównym katalogu projektu:
```bash
./run.sh
```

---

## 🖥️ 7. Przykładowe wyjście symulacji w konsoli

```text
=================================================================================
       FABRYKA PUNKTOW ECTS - SYMULACJA SESJI I WYDZIALU W JEZYKU ADA            
=================================================================================
 Moduly podstawowe (src/base_modules/):
   1. Dostawy i Stanowisko Rozladunku: Wykladowcy katedr i Portiernia wydzialu
   2. Studenci-Kurierzy ECTS (Starostowie S1..S3 - transport teczek do Dziekanatu)
   3. Baza USOS / Dziekanat (Centralny serwer - limit roku: 60 ECTS)
 Moduly dodatkowe (src/extra_modules/):
   * MODUL E: Bufet Studencki / Automat z kawa (Regeneracja kofeiny - 1 ekspres)
   * MODUL G: Kontroler / Monitor centrum (System USOS-Web na zywo)
   * MODUL H: Zniecierpliwiony Wykladowca (Doc. Pospiech - Timed Entry Call)
=================================================================================

[00.5] Przyjazd wykładowcy: Prof. Janusz (Katedra Algorytmiki) [D1] [ECTS Wykład (Teoria),  8 ECTS w protokole]
[00.5] Prof. Janusz (Katedra Algorytmiki) [D1] oczekuje w kolejce do Portierni / Okienka
[00.5] [PORTIERNIA] Rozpoczeto przyjmowanie teczki od wykladowcy D 1 (ECTS Wykład (Teoria),  8 ECTS)
[00.8] Przyjazd wykładowcy: Dr Kowalski (Zakład Sys. Wbudowanych) [D2] [ECTS Laboratorium (Praktyka),  10 ECTS w protokole]
[01.3] Przyjazd zniecierpliwionego wykładowcy: Doc. Pośpiech (Katedra Teorii) [D4] [ECTS Wykład (Teoria),  6 ECTS, cierpliwosc: 0.9s]
[01.3] Doc. Pośpiech (Katedra Teorii) [D4]: 'Jak okienko nie zejdzie w 0.9s, wpisuje wszystkim NZAL i ide na urlop!'
[01.7] [PORTIERNIA] Protokol od D 1 ostemplowany i przekazany do skrzynki odbioru starostow
[01.7] Prof. Janusz (Katedra Algorytmiki) [D1] zlozyl protokol i odjechal na wyklad
[02.2] Doc. Pośpiech (Katedra Teorii) [D4] ZREZYGNOWAL Z OCZEKIWANIA (brak wolnego okienka po 0.9s) - Wszyscy dostaja NZAL, odjazd na konferencje!

=================== SYSTEM USOS-WEB - STAN SESJI [03.0] ===================
 [BAZA USOS - DZIEKANAT]    Zarejestrowano:  18 / 60 ECTS ( 30% roku zaliczone)
   * Wykłady (Teoria):         8 ECTS
   * Laboratoria (Praktyka):  10 ECTS
   * Projekty (Inżynieria):    0 ECTS
---------------------------------------------------------------------------------
 [PORTIERNIA WYDZIAŁU]      Oczekujące teczki w skrzynce:  1
 [STATYSTYKA PROTOKOŁÓW]    Wprowadzone:  3 | Odrzucone / Wykładowca uciekł:  1
---------------------------------------------------------------------------------
 [STAROSTOWIE NA DYŻURZE (MODUŁ 2)]
   * Student S1 (Starosta)   | Kofeina: [#######---] 75% | Stan: Wolny (Oczekuje na zaliczenia)
   * Student S2 (Wice-star.) | Kofeina: [#######---] 75% | Stan: Biegnie z protokołem do Dziekanatu
   * Student S3 (Stażysta)   | Kofeina: [##--------] 25% | Stan: Pije Espresso w Bufecie [☕]
=================================================================================

[13.2] [Student S3 (Stażysta Wydziału)] Spadek kofeiny ( 25%), idzie do bufetu po kawe
[13.7] [BUFET] Student S 3 zamawia podwojne Espresso (energia:  25%)...
[15.7] [BUFET] Student S 3 wypil kawe! Energia zregenerowana do 100%. Zwolniono ekspres.
[15.7] [Student S3 (Stażysta Wydziału)] Zregenerowany ( 100% kofeiny), powrot do obowiazkow

=================================================================================
             PODSUMOWANIE KONCOWE SESJI EGZAMINACYJNEJ (USOS)                    
=================================================================================
 Stan koncowy bazy USOS:  58 / 60 ECTS
   - Wyklady (Teoria):         8 ECTS
   - Laboratoria (Praktyka):  24 ECTS
   - Projekty (Inzynieria):   26 ECTS
 Protokoly pomyslnie wprowadzone do USOS:  7
 Wykladowcy, ktorzy zrezygnowali (NZAL / timeout):  1
=================================================================================
 Symulacja ukonczona z sukcesem. Wszyscy prowadzacy i studenci zakonczyli prace.
=================================================================================
```
