with Unloading_Dock;
with Delivery_Stats;
with Logger;
with Ada.Strings.Fixed;

package body Impatient_Lecturers is

   task body Impatient_Lecturer_Type is
      Lecturer      : constant String := Get_Lecturer_Title (Id);
      Delay_Before  : constant Duration := Duration (Delay_Tenths) / 10.0;
      Patience_Time : constant Duration := Duration (Patience_Tenths) / 10.0;
      Was_Accepted  : Boolean := False;
   begin
      -- Czas dojazdu zniecierpliwionego wykładowcy
      delay Delay_Before;

      Logger.Screen_Logger.Log (
         "Przyjazd zniecierpliwionego wykładowcy: " & Lecturer & " [" &
         To_String (Kind) & ", " &
         Natural'Image (Amount) & " ECTS, cierpliwosc: " &
         Ada.Strings.Fixed.Trim (Duration'Image (Patience_Time), Ada.Strings.Both) & "s]"
      );
      Logger.Screen_Logger.Log (
         Lecturer & ": 'Jak okienko nie zejdzie w " &
         Ada.Strings.Fixed.Trim (Duration'Image (Patience_Time), Ada.Strings.Both) &
         "s, wpisuje wszystkim NZAL i ide na urlop!'"
      );

      -- Moduł H: Timed Entry Call (wywołanie terminowane spotkania)
      select
         Unloading_Dock.Unloading_Dock_Task.Request_Unload (
            Delivery => (
               Id              => Id,
               Kind            => Kind,
               Amount          => Amount,
               Origin_Lecturer => Id
            ),
            Accepted => Was_Accepted
         );

         if Was_Accepted then
            Delivery_Stats.Stats.Register_Success;
            Logger.Screen_Logger.Log (Lecturer & " zlozyl protokol w ostatniej chwili i odjechal");
         else
            Delivery_Stats.Stats.Register_Timeout;
            Logger.Screen_Logger.Log (Lecturer & " nie zlozyl protokolu - odjazd");
         end if;

      or
         delay Patience_Time;

         -- Klauzula timeoutu - rezygnacja z oczekiwania
         Delivery_Stats.Stats.Register_Timeout;
         Logger.Screen_Logger.Log (
            Lecturer & " ZREZYGNOWAL Z OCZEKIWANIA (brak wolnego okienka po " &
            Ada.Strings.Fixed.Trim (Duration'Image (Patience_Time), Ada.Strings.Both) &
            "s) - Wszyscy dostaja NZAL, odjazd na konferencje!"
         );
      end select;

   end Impatient_Lecturer_Type;

end Impatient_Lecturers;
