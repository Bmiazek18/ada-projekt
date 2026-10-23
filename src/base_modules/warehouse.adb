with Logger;

package body Warehouse is

   task body Warehouse_Task is
      Stock        : Warehouse_Stock_Array := [others => 0];
      Max_Capacity : constant Natural := Annual_ECTS_Capacity;
      Current_Total: Natural := 0;
      Running      : Boolean := True;
   begin
      Logger.Screen_Logger.Log ("[USOS-DZIEKANAT] Centralny Serwer Ocen zainicjalizowany. Limit roku: " &
                                Natural'Image (Max_Capacity) & " ECTS");

      while Running loop
         select
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
            accept Get_Stock (
               Out_Stock    : out Warehouse_Stock_Array;
               Total_Points : out Natural;
               Capacity     : out Natural
            ) do
               Out_Stock    := Stock;
               Total_Points := Current_Total;
               Capacity     := Max_Capacity;
            end Get_Stock;

         or
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
