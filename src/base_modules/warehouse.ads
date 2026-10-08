with ECTS_Types; use ECTS_Types;

package Warehouse is

   -- Moduł 3: Magazyn Główny ECTS / Centralna Baza USOS Dziekanatu
   task Warehouse_Task is
      -- Rejestracja punktów ECTS z protokołu dostarczonego przez studenta
      entry Store_Items (
         Delivery : in  Delivery_Record;
         Accepted : out Boolean
      );

      -- Pobranie aktualnego stanu magazynu (dla Monitora i procedury Main)
      entry Get_Stock (
         Stock        : out Warehouse_Stock_Array;
         Total_Stock  : out Natural;
         Max_Cap      : out Natural
      );

      -- Zatrzymanie zadania
      entry Stop;
   end Warehouse_Task;

end Warehouse;
