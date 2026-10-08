with ECTS_Types; use ECTS_Types;

package Unloading_Dock is

   task Unloading_Dock_Task is
      -- Zgloszenie samochodu do rozladunku
      entry Request_Unload (
         Delivery : in  Delivery_Record;
         Accepted : out Boolean
      );

      -- Pobranie zlecenia transportowego przez robota
      entry Take_Work_Order (
         Order     : out Delivery_Record;
         Has_Order : out Boolean
      );

      -- Sprawdzenie liczby oczekujacych paczek w buforze
      entry Get_Pending_Count (Count : out Natural);

      -- Zatrzymanie zadania
      entry Stop;
   end Unloading_Dock_Task;

end Unloading_Dock;
