with Unloading_Dock;
with Delivery_Stats;
with Logger;

package body Lecturers is

   task body Lecturer_Type is
      Lecturer     : constant String := Get_Lecturer_Title (Id);
      Delay_Before : constant Duration := Duration (Delay_Tenths) / 10.0;
      Was_Accepted : Boolean := False;
   begin
      -- Czas dojazdu wykładowcy na wydział
      delay Delay_Before;

      Logger.Screen_Logger.Log (
         "Przyjazd wykładowcy: " & Lecturer & " [" &
         To_String (Kind) & ", " &
         Natural'Image (Amount) & " ECTS w protokole]"
      );
      Logger.Screen_Logger.Log (Lecturer & " oczekuje w kolejce do Portierni / Okienka");

      -- Zwykłe spotkanie (rendezvous) - wykładowca czeka na wolne okienko
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
         Logger.Screen_Logger.Log (Lecturer & " zlozyl protokol i odjechal na wyklad");
      else
         Delivery_Stats.Stats.Register_Timeout;
         Logger.Screen_Logger.Log (Lecturer & " nie zlozyl protokolu - odjazd");
      end if;

   end Lecturer_Type;

end Lecturers;
