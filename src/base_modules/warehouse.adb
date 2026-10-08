with Logger;

package body Warehouse is

   -- Moduł 3: Implementacja Centralnej Bazy USOS Dziekanatu
   task body Warehouse_Task is
      Stock        : Warehouse_Stock_Array := [others => 0];
      Max_Capacity : constant Natural := 60;
      Current_Total: Natural := 0;
      Running      : Boolean := True;
   begin
      Logger.Screen_Logger.Log ("[USOS-DZIEKANAT] Centralny Serwer Ocen zainicjalizowany. Limit roku: " &
                                Natural'Image (Max_Capacity) & " ECTS");

      while Running loop
         select
            -- Spotkanie selektywne z dozorem (guard WHEN): przyjmowanie dopóki limit roku nie jest pełny
            when Current_Total + 1 <= Max_Capacity =>
               accept Store_Items (
                  Delivery : in  Delivery_Record;
                  Accepted : out Boolean
               ) do
                  if Current_Total + Delivery.Amount <= Max_Capacity then
                     Stock (Delivery.Kind) := Stock (Delivery.Kind) + Delivery.Amount;
                     Current_Total := Current_Total + Delivery.Amount;
                     Accepted := True;

                     Logger.Screen_Logger.Log (
                        "[USOS] Zarejestrowano w bazie " & Natural'Image (Delivery.Amount) &
                        " ECTS (" & To_String (Delivery.Kind) &
                        ") | Postęp roku: " & Natural'Image (Current_Total) &
                        "/" & Natural'Image (Max_Capacity) & " ECTS"
                     );
                  else
                     Accepted := False;
                     Logger.Screen_Logger.Log (
                        "[USOS] BLAD ZAPISU: Przekroczono limit roczny! Nie zmieszczono " &
                        Natural'Image (Delivery.Amount) & " ECTS (" &
                        To_String (Delivery.Kind) & ")"
                     );
                  end if;
               end Store_Items;

         or
            -- Odczyt stanu magazynu (dla Monitora i podsumowania końcowego)
            accept Get_Stock (
               Stock        : out Warehouse_Stock_Array;
               Total_Stock  : out Natural;
               Max_Cap      : out Natural
            ) do
               Stock       := Warehouse_Task.Stock;
               Total_Stock := Current_Total;
               Max_Cap     := Max_Capacity;
            end Get_Stock;

         or
            -- Sygnał zatrzymania
            accept Stop do
               Running := False;
            end Stop;

         or
            terminate;
         end select;
      end loop;

      Logger.Screen_Logger.Log ("[USOS-DZIEKANAT] Serwer USOS zakonczyl sesje na dzis.");
   end Warehouse_Task;

end Warehouse;
