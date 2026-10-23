with Logger;
with Random_Utils;

package body Coffee_Station is

   task body Coffee_Station_Task is
      Full_Energy_Recovery : constant Natural := 100;
      Running              : Boolean := True;
   begin
      Logger.Screen_Logger.Log ("[BUFET] Ekspres ciśnieniowy [1 stanowisko] gotowy do parzenia kawy.");

      while Running loop
         select
            accept Drink_Coffee (
               S_Id       : in  Student_Id;
               Energy_In  : in  Natural;
               Energy_Out : out Natural
            ) do
               Logger.Screen_Logger.Log (
                  "[BUFET] Student S" & Natural'Image (S_Id) &
                  " zamawia podwojne Espresso (energia: " &
                  Natural'Image (Energy_In) & "%)..."
               );

               delay Random_Utils.Random_Delay (1.6, 2.2);

               Energy_Out := Full_Energy_Recovery;
               Logger.Screen_Logger.Log (
                  "[BUFET] Student S" & Natural'Image (S_Id) &
                  " wypil kawe! Energia zregenerowana do 100%. Zwolniono ekspres."
               );
            end Drink_Coffee;

         or
            accept Stop do
               Running := False;
            end Stop;

         or
            terminate;
         end select;
      end loop;

      Logger.Screen_Logger.Log ("[BUFET] Bufet studencki zakonczyl prace na dzis.");
   end Coffee_Station_Task;

end Coffee_Station;
