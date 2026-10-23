with Unloading_Dock;
with Warehouse;
with Coffee_Station;
with Logger;
with Random_Utils;

package body Students is

   -- Implementacja obiektu chronionego Student_Registry
   protected body Student_Registry is

      procedure Update_Status (
         Id     : Student_Id;
         State  : Student_State;
         Energy : Natural
      ) is
      begin
         if Id in Info_Array'Range then
            Info_Array (Id) := (Id => Id, State => State, Energy => Energy);
         end if;
      end Update_Status;

      function Get_All_Info return Students_Info_Array is
      begin
         return Info_Array;
      end Get_All_Info;

   end Student_Registry;

   -- Implementacja zadania Student_Type (Moduł 2 & Moduł E)
   task body Student_Type is
      Initial_Energy           : constant Natural  := 100;
      Caffeine_Low_Threshold   : constant Natural  := 25;
      Energy_Cost_Per_Delivery : constant Natural  := 25;
      Walk_To_Cafe_Time        : constant Duration := 0.5;
      Deanery_Timeout          : constant Duration := 1.5;
      Idle_Wait_Time           : constant Duration := 0.4;

      Energy     : Natural := Initial_Energy;
      Running    : Boolean := True;
      Order      : Delivery_Record;
      Has_Order  : Boolean := False;
      Accepted   : Boolean := False;
      New_Eng    : Natural := Initial_Energy;
      S_Name     : constant String := Get_Student_Title (Id);
   begin
      Logger.Screen_Logger.Log ("[" & S_Name & "] Gotowy do dyzuru. Poziom kofeiny: 100%");
      Student_Registry.Update_Status (Id, Wolny, Energy);

      while Running loop
         -- Nieblokujące sprawdzenie sygnału zatrzymania
         select
            accept Stop do
               Running := False;
            end Stop;
         else
            null;
         end select;

         if Running then
            -- Moduł E: regeneracja kofeiny w bufecie, gdy spadnie <= 25%
            if Energy <= Caffeine_Low_Threshold then
               Student_Registry.Update_Status (Id, Idzie_Po_Kawe, Energy);
               Logger.Screen_Logger.Log ("[" & S_Name & "] Spadek kofeiny (" &
                                         Natural'Image (Energy) & "%), idzie do bufetu po kawe");

               delay Walk_To_Cafe_Time;

               Student_Registry.Update_Status (Id, Pije_Kawe, Energy);
               Coffee_Station.Coffee_Station_Task.Drink_Coffee (Id, Energy, New_Eng);
               Energy := New_Eng;

               Student_Registry.Update_Status (Id, Wolny, Energy);
               Logger.Screen_Logger.Log ("[" & S_Name & "] Zregenerowany (" &
                                         Natural'Image (Energy) & "% kofeiny), powrot do obowiazkow");
            end if;

            -- Conditional Entry Call: próba pobrania teczki z portierni bez blokowania
            Has_Order := False;
            select
               Unloading_Dock.Unloading_Dock_Task.Take_Work_Order (Order, Has_Order);
            else
               Has_Order := False;
            end select;

            -- Transport i rejestracja protokołu w Dziekanacie
            if Has_Order then
               Student_Registry.Update_Status (Id, Odbiera_ECTS, Energy);
               Logger.Screen_Logger.Log (
                  "[" & S_Name & "] Odebral z portierni protokol na " &
                  Natural'Image (Order.Amount) & " ECTS (" &
                  To_String (Order.Kind) & ") od wykladowcy D" &
                  Natural'Image (Order.Origin_Lecturer)
               );

               Student_Registry.Update_Status (Id, Niesie_Do_Dziekanatu, Energy);
               delay Random_Utils.Random_Delay (0.8, 1.3);

               Logger.Screen_Logger.Log ("[" & S_Name & "] Biegnie z protokolem do Dziekanatu");
               delay Random_Utils.Random_Delay (0.5, 0.9);

               Student_Registry.Update_Status (Id, Rejestruje_W_Dziekanacie, Energy);

               -- Rezygnacja w przypadku zablokowania dziekanatu (pelny limit)
               select
                  Warehouse.Warehouse_Task.Store_Items (Order, Accepted);
               or
                  delay Deanery_Timeout;
                  Accepted := False;
                  Logger.Screen_Logger.Log (
                     "[" & S_Name & "] Dziekanat niedostepny lub osiagnal pelny limit (timeout) - protokol odrzucony"
                  );
               end select;

               if Accepted then
                  Logger.Screen_Logger.Log ("[" & S_Name & "] Zlozyl protokol w Dziekanacie");
               else
                  Logger.Screen_Logger.Log ("[" & S_Name & "] Dziekanat odmowil przyjecia (limit 60 ECTS roku wyczerpany)");
               end if;

               -- Zużycie energii po kursie
               if Energy >= Energy_Cost_Per_Delivery then
                  Energy := Energy - Energy_Cost_Per_Delivery;
               else
                  Energy := 0;
               end if;

               Student_Registry.Update_Status (Id, Wolny, Energy);
               Logger.Screen_Logger.Log (
                  "[" & S_Name & "] Jest ponownie wolny (Kofeina: " &
                  Natural'Image (Energy) & "%)"
               );
            else
               -- Jeśli brak teczek, oczekiwanie z możliwością natychmiastowego przerwania przez Stop
               select
                  accept Stop do
                     Running := False;
                  end Stop;
               or
                  delay Idle_Wait_Time;
               end select;
            end if;
         end if;
      end loop;

      Student_Registry.Update_Status (Id, Zakonczyl_Dzien, Energy);
      Logger.Screen_Logger.Log ("[" & S_Name & "] Zakonczyl dyzur na wydziale.");
   end Student_Type;

end Students;
