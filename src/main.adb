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
with Random_Utils;

-- Główna procedura symulacji: Fabryka Punktów ECTS / USOS-Web
procedure Main is

   -- Studenci-Starostowie
   S1 : Student_Type (1);
   S2 : Student_Type (2);
   S3 : Student_Type (3);

   -- Wykładowcy dostarczający protokoły ocen z katedr
   D1 : Lecturer_Type (Lecturer_Number => 1, Protocol_Id => 101, Delay_Tenths => 5,   Kind => ECTS_Wyklad,        Amount => 8);
   D2 : Lecturer_Type (Lecturer_Number => 2, Protocol_Id => 102, Delay_Tenths => 8,   Kind => ECTS_Laboratorium,  Amount => 10);
   D3 : Lecturer_Type (Lecturer_Number => 3, Protocol_Id => 103, Delay_Tenths => 11,  Kind => ECTS_Projekt,       Amount => 12);
   D5 : Lecturer_Type (Lecturer_Number => 5, Protocol_Id => 105, Delay_Tenths => 35,  Kind => ECTS_Laboratorium,  Amount => 8);
   D6 : Lecturer_Type (Lecturer_Number => 6, Protocol_Id => 106, Delay_Tenths => 55,  Kind => ECTS_Projekt,       Amount => 14);
   D7 : Lecturer_Type (Lecturer_Number => 7, Protocol_Id => 107, Delay_Tenths => 78,  Kind => ECTS_Wyklad,        Amount => 10);
   D8 : Lecturer_Type (Lecturer_Number => 8, Protocol_Id => 108, Delay_Tenths => 100, Kind => ECTS_Laboratorium,  Amount => 6);

   -- Wykładowca z ograniczonym czasem oczekiwania (Docent Pośpiech)
   D4 : Impatient_Lecturer_Type (Lecturer_Number => 4, Protocol_Id => 104, Delay_Tenths => 13, Kind => ECTS_Wyklad, Amount => 6, Patience_Tenths => 9);

   -- Czas trwania sesji egzaminacyjnej
   Simulation_Duration : constant Duration := 19.0;

   Final_Stock   : Warehouse_Stock_Array;
   Final_Total   : Natural;
   Final_Max     : Natural;
   Succ_Dels     : Natural;
   Rej_Dels      : Natural;

begin
   Random_Utils.Random_Gen.Initialize;

   Put_Line ("=================================================================================");
   Put_Line ("       FABRYKA PUNKTOW ECTS - SYMULACJA SESJI I WYDZIALU W JEZYKU ADA            ");
   Put_Line ("=================================================================================");
   New_Line;

   delay Simulation_Duration;

   Logger.Screen_Logger.Log ("Rozpoczecie procedury zamykania sesji w Dziekanacie...");

   Warehouse.Warehouse_Task.Get_Stock (Final_Stock, Final_Total, Final_Max);
   Delivery_Stats.Stats.Get_Stats (Succ_Dels, Rej_Dels);

   S1.Stop;
   S2.Stop;
   S3.Stop;
   Monitor.Monitor_Task.Stop;
   Unloading_Dock.Unloading_Dock_Task.Stop;
   Coffee_Station.Coffee_Station_Task.Stop;
   Warehouse.Warehouse_Task.Stop;

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
