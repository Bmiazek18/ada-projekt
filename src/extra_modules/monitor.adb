with Warehouse;
with Unloading_Dock;
with Students;
with Delivery_Stats;
with Logger;
with ECTS_Types; use ECTS_Types;

package body Monitor is

   task body Monitor_Task is
      Running         : Boolean := True;
      Stock           : Warehouse_Stock_Array;
      Total_Stock     : Natural;
      Max_Capacity    : Natural;
      Pending_Count   : Natural;
      Success_Dels    : Natural;
      Timeout_Dels    : Natural;
      Students_Status : Students_Info_Array;
   begin
      Logger.Screen_Logger.Log ("[MONITOR] Kontroler stanu centrum ECTS uruchomiony.");

      while Running loop
         select
            accept Stop do
               Running := False;
            end Stop;
         or
            delay 3.0;

            -- Pobranie danych ze wszystkich komponentow
            Warehouse.Warehouse_Task.Get_Stock (Stock, Total_Stock, Max_Capacity);
            Unloading_Dock.Unloading_Dock_Task.Get_Pending_Count (Pending_Count);
            Delivery_Stats.Stats.Get_Stats (Success_Dels, Timeout_Dels);
            Students_Status := Students.Student_Registry.Get_All_Info;

            -- Atomowe wyswietlenie raportu statusowego
            Logger.Screen_Logger.Log_Status_Table (
               Stock         => Stock,
               Total_Stock   => Total_Stock,
               Max_Capacity  => Max_Capacity,
               Pending_Docks => Pending_Count,
               Students      => Students_Status,
               Completed_Del => Success_Dels,
               Rejected_Del  => Timeout_Dels
            );
         end select;
      end loop;

      Logger.Screen_Logger.Log ("[MONITOR] Kontroler centrum zakonczyl monitorowanie.");
   end Monitor_Task;

end Monitor;
