with Ada.Text_IO; use Ada.Text_IO;
with ECTS_Types; use ECTS_Types;
with Logger;
with Delivery_Stats;
with Warehouse;
with Unloading_Dock;
with Coffee_Station;
with Students; use Students;
with Lecturers; use Lecturers;
with Impatient_Lecturers; use Impatient_Lecturers;
with Monitor;

-- Główna procedura symulacji: Fabryka Punktów ECTS / USOS-Web
procedure Main is

   -- Moduł 2 & E: Studenci-Starostowie (odpowiednik robotów transportowych AGV)
   S1 : Student_Type (1); -- Starosta Roku
   S2 : Student_Type (2); -- Wice-starosta
   S3 : Student_Type (3); -- Stażysta Wydziału

   -- Moduł 1: Wykładowcy dostarczający protokoły ocen z katedr (odpowiednik samochodów dostawczych)
   D1 : Lecturer_Type (Id => 1, Delay_Tenths => 5,   Kind => ECTS_Wyklad,        Amount => 8);
   D2 : Lecturer_Type (Id => 2, Delay_Tenths => 8,   Kind => ECTS_Laboratorium,  Amount => 10);
   D3 : Lecturer_Type (Id => 3, Delay_Tenths => 11,  Kind => ECTS_Projekt,       Amount => 12);
   D5 : Lecturer_Type (Id => 5, Delay_Tenths => 35,  Kind => ECTS_Laboratorium,  Amount => 8);
   D6 : Lecturer_Type (Id => 6, Delay_Tenths => 55,  Kind => ECTS_Projekt,       Amount => 14);
   D7 : Lecturer_Type (Id => 7, Delay_Tenths => 78,  Kind => ECTS_Wyklad,        Amount => 10);
   D8 : Lecturer_Type (Id => 8, Delay_Tenths => 100, Kind => ECTS_Laboratorium,  Amount => 6);

   -- Moduł H: Zniecierpliwiony Wykładowca (Docent Pośpiech - Timed Entry Call)
   D4 : Impatient_Lecturer_Type (Id => 4, Delay_Tenths => 13, Kind => ECTS_Wyklad, Amount => 6, Patience_Tenths => 9);

   -- Zmienne na podsumowanie końcowe
   Final_Stock   : Warehouse_Stock_Array;
   Final_Total   : Natural;
   Final_Max     : Natural;
   Succ_Dels     : Natural;
   Rej_Dels      : Natural;

begin
   Put_Line ("=================================================================================");
   Put_Line ("       FABRYKA PUNKTOW ECTS - SYMULACJA SESJI I WYDZIALU W JEZYKU ADA            ");
   Put_Line ("=================================================================================");
   Put_Line (" Moduly podstawowe (src/base_modules/):");
   Put_Line ("   1. Wykladowcy i Portiernia (Dostawy protokołów ocen z katedr)");
   Put_Line ("   2. Studenci-Kurierzy ECTS (Starostowie S1..S3 - transport teczek do Dziekanatu)");
   Put_Line ("   3. Baza USOS / Dziekanat (Centralny serwer - limit roku: 60 ECTS)");
   Put_Line (" Moduly dodatkowe (src/extra_modules/):");
   Put_Line ("   * MODUL E: Bufet Studencki / Automat z kawa (Regeneracja kofeiny - 1 ekspres)");
   Put_Line ("   * MODUL G: Kontroler / Monitor centrum (System USOS-Web na zywo)");
   Put_Line ("   * MODUL H: Zniecierpliwiony Wykladowca (Doc. Pospiech - Timed Entry Call)");
   Put_Line ("=================================================================================");
   New_Line;

   -- Czas trwania symulacji
   delay 19.0;

   Logger.Screen_Logger.Log ("Rozpoczecie procedury zamykania sesji w Dziekanacie...");

   -- Pobranie statystyk przed zatrzymaniem zadań
   Warehouse.Warehouse_Task.Get_Stock (Final_Stock, Final_Total, Final_Max);
   Delivery_Stats.Stats.Get_Stats (Succ_Dels, Rej_Dels);

   -- Zatrzymanie aktywnych zadań
   S1.Stop;
   S2.Stop;
   S3.Stop;
   Monitor.Monitor_Task.Stop;
   Unloading_Dock.Unloading_Dock_Task.Stop;
   Coffee_Station.Coffee_Station_Task.Stop;
   Warehouse.Warehouse_Task.Stop;

   -- Raport końcowy
   New_Line;
   Put_Line ("=================================================================================");
   Put_Line ("             PODSUMOWANIE KONCOWE SESJI EGZAMINACYJNEJ (USOS)                    ");
   Put_Line ("=================================================================================");
   Put_Line (" Stan koncowy bazy USOS: " & Natural'Image (Final_Total) & " /" & Natural'Image (Final_Max) & " ECTS");
   Put_Line ("   - Wyklady (Teoria):        " & Natural'Image (Final_Stock (ECTS_Wyklad)) & " ECTS");
   Put_Line ("   - Laboratoria (Praktyka):  " & Natural'Image (Final_Stock (ECTS_Laboratorium)) & " ECTS");
   Put_Line ("   - Projekty (Inzynieria):   " & Natural'Image (Final_Stock (ECTS_Projekt)) & " ECTS");
   Put_Line (" Protokoly pomyslnie wprowadzone do USOS: " & Natural'Image (Succ_Dels));
   Put_Line (" Wykladowcy, ktorzy zrezygnowali (NZAL / timeout): " & Natural'Image (Rej_Dels));
   Put_Line ("=================================================================================");
   Put_Line (" Symulacja ukonczona z sukcesem. Wszyscy prowadzacy i studenci zakonczyli prace.");
   Put_Line ("=================================================================================");
end Main;
