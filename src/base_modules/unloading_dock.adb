with Logger;

package body Unloading_Dock is

   -- Moduł 1: Stanowisko Rozładunkowe / Portiernia Wydziału (bufor FIFO)
   task body Unloading_Dock_Task is
      Max_Buffer : constant Natural := 6;
      type Buffer_Array is array (1 .. Max_Buffer) of Delivery_Record;
      Buffer     : Buffer_Array;
      Head       : Positive := 1;
      Tail       : Positive := 1;
      Count      : Natural  := 0;
      Running    : Boolean  := True;

      -- Pomocnicza procedura do przesuwania wskaźnika bufora cyklicznego
      procedure Advance (Index : in out Positive) is
      begin
         if Index = Max_Buffer then
            Index := 1;
         else
            Index := Index + 1;
         end if;
      end Advance;

   begin
      Logger.Screen_Logger.Log ("[PORTIERNIA] Okienko podawcze wydzialu otwarte.");

      while Running loop
         select
            -- Przyjęcie protokołu od wykładowcy (dozór: tylko gdy jest miejsce w buforze)
            when Count < Max_Buffer =>
               accept Request_Unload (
                  Delivery : in  Delivery_Record;
                  Accepted : out Boolean
               ) do
                  Logger.Screen_Logger.Log (
                     "[PORTIERNIA] Rozpoczeto przyjmowanie teczki od wykladowcy D" &
                     Natural'Image (Delivery.Origin_Lecturer) & " (" &
                     To_String (Delivery.Kind) & ", " &
                     Natural'Image (Delivery.Amount) & " ECTS)"
                  );

                  -- Czas weryfikacji i stemplowania
                  delay 1.2;

                  Buffer (Tail) := Delivery;
                  Advance (Tail);
                  Count := Count + 1;
                  Accepted := True;

                  Logger.Screen_Logger.Log (
                     "[PORTIERNIA] Protokol od D" &
                     Natural'Image (Delivery.Origin_Lecturer) &
                     " ostemplowany i przekazany do skrzynki odbioru starostow"
                  );
               end Request_Unload;

         or
            -- Wydanie protokołu studentowi (dozór: tylko gdy są oczekujące teczki)
            when Count > 0 =>
               accept Take_Work_Order (
                  Order     : out Delivery_Record;
                  Has_Order : out Boolean
               ) do
                  Order     := Buffer (Head);
                  Advance (Head);
                  Count     := Count - 1;
                  Has_Order := True;
               end Take_Work_Order;

         or
            -- Pobranie liczby oczekujących teczek (dla Monitora)
            accept Get_Pending_Count (Count : out Natural) do
               Count := Unloading_Dock_Task.Count;
            end Get_Pending_Count;

         or
            -- Zatrzymanie zadania
            accept Stop do
               Running := False;
            end Stop;

         or
            terminate;
         end select;
      end loop;

      Logger.Screen_Logger.Log ("[PORTIERNIA] Okienko podawcze zostalo zamkniete.");
   end Unloading_Dock_Task;

end Unloading_Dock;
