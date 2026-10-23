with ECTS_Types; use ECTS_Types;

package Unloading_Dock is

   Max_Dock_Buffer : constant Natural := 6;

   -- MODUŁ 1: Portiernia / Okienko podawcze (bufor cykliczny FIFO)
   task Unloading_Dock_Task is
      -- Przyjecie protokolu od wykladowcy
      entry Request_Unload (
         Delivery : in  Delivery_Record;
         Accepted : out Boolean
      );

      -- Pobranie protokolu przez studenta
      entry Take_Work_Order (
         Order     : out Delivery_Record;
         Has_Order : out Boolean
      );

      -- Liczba oczekujacych protokolow w portierni
      entry Get_Pending_Count (Pending_Count : out Natural);

      entry Stop;
   end Unloading_Dock_Task;

end Unloading_Dock;
