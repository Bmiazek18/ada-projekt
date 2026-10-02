with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Strings.Fixed;

package body Logger is

   function Get_Timestamp (T_Start : Ada.Calendar.Time) return String is
      Now_Time : constant Time := Clock;
      Elapsed  : Duration := 0.0;
      Seconds  : Natural := 0;
      Fraction : Natural := 0;
      Sec_Str  : String (1 .. 2) := "00";
      Frac_Str : String (1 .. 1) := "0";
   begin
      if Now_Time >= T_Start then
         Elapsed := Now_Time - T_Start;
      else
         Elapsed := 0.0;
      end if;

      Seconds := Natural (Float'Floor (Float (Elapsed)));
      Fraction := Natural (Float'Floor ((Float (Elapsed) - Float (Seconds)) * 10.0));

      if Seconds < 10 then
         Sec_Str := "0" & Ada.Strings.Fixed.Trim (Natural'Image (Seconds), Ada.Strings.Both);
      else
         declare
            Raw_Sec : constant String := Ada.Strings.Fixed.Trim (Natural'Image (Seconds), Ada.Strings.Both);
         begin
            if Raw_Sec'Length >= 2 then
               Sec_Str := Raw_Sec (Raw_Sec'First .. Raw_Sec'First + 1);
            else
               Sec_Str := "0" & Raw_Sec;
            end if;
         end;
      end if;

      Frac_Str := Ada.Strings.Fixed.Trim (Natural'Image (Fraction mod 10), Ada.Strings.Both);
      return "[" & Sec_Str & "." & Frac_Str & "]";
   exception
      when others =>
         return "[00.0]";
   end Get_Timestamp;

   function Caffeine_Bar (Level : Natural) return String is
      Blocks : constant Natural := Level / 10;
      Result : String (1 .. 10) := (others => '-');
   begin
      for I in 1 .. Blocks loop
         if I in Result'Range then
            Result (I) := '#';
         end if;
      end loop;
      return "[" & Result & "] " & Ada.Strings.Fixed.Trim (Natural'Image (Level), Ada.Strings.Both) & "%";
   end Caffeine_Bar;

   function Student_Role (Id : Student_Id) return String is
   begin
      case Id is
         when 1 => return "Student S1 (Starosta)   ";
         when 2 => return "Student S2 (Wice-star.) ";
         when 3 => return "Student S3 (Stażysta)   ";
         when others => return "Student S" & Natural'Image (Id) & "             ";
      end case;
   end Student_Role;

   protected body Screen_Logger is

      procedure Log (Msg : String) is
         Stamp : constant String := Get_Timestamp (Start_Time);
      begin
         Put_Line (Stamp & " " & Msg);
      end Log;

      procedure Log_Highlighted (Prefix : String; Msg : String) is
         Stamp : constant String := Get_Timestamp (Start_Time);
      begin
         Put_Line (Stamp & " >>> " & Prefix & ": " & Msg);
      end Log_Highlighted;

      procedure Log_Status_Table (
         Stock         : Warehouse_Stock_Array;
         Total_Stock   : Natural;
         Max_Capacity  : Natural;
         Pending_Docks : Natural;
         Students      : Students_Info_Array;
         Completed_Del : Natural;
         Rejected_Del  : Natural
      ) is
         Stamp : constant String := Get_Timestamp (Start_Time);
         Progress_Pct : constant Natural := (Total_Stock * 100) / Max_Capacity;
      begin
         New_Line;
         Put_Line ("=================== SYSTEM USOS-WEB - STAN SESJI " & Stamp & " ===================");
         Put_Line (" [BAZA USOS - DZIEKANAT]    Zarejestrowano: " &
                   Natural'Image (Total_Stock) & " /" & Natural'Image (Max_Capacity) &
                   " ECTS (" & Natural'Image (Progress_Pct) & "% roku zaliczone)");
         Put_Line ("   * Wykłady (Teoria):        " & Natural'Image (Stock (ECTS_Wyklad)) & " ECTS");
         Put_Line ("   * Laboratoria (Praktyka):  " & Natural'Image (Stock (ECTS_Laboratorium)) & " ECTS");
         Put_Line ("   * Projekty (Inżynieria):   " & Natural'Image (Stock (ECTS_Projekt)) & " ECTS");
         Put_Line ("---------------------------------------------------------------------------------");
         Put_Line (" [PORTIERNIA WYDZIAŁU]      Oczekujące teczki w skrzynce: " & Natural'Image (Pending_Docks));
         Put_Line (" [STATYSTYKA PROTOKOŁÓW]    Wprowadzone: " & Natural'Image (Completed_Del) &
                   " | Odrzucone / Wykładowca uciekł: " & Natural'Image (Rejected_Del));
         Put_Line ("---------------------------------------------------------------------------------");
         Put_Line (" [STAROSTOWIE NA DYŻURZE (MODUŁ 2)]");
         for I in Students'Range loop
            Put_Line ("   * " & Student_Role (Students (I).Id) &
                      " | Kofeina: " & Caffeine_Bar (Students (I).Energy) &
                      " | Stan: " & To_String (Students (I).State));
         end loop;
         Put_Line ("=================================================================================");
         New_Line;
      end Log_Status_Table;

   end Screen_Logger;

end Logger;
