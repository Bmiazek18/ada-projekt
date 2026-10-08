with ECTS_Types; use ECTS_Types;

package Coffee_Station is

   -- MODUŁ E: Automat z kawą / Bufet Studencki (Odpowiednik stacji ładowania robotów)
   -- Posiada 1 stanowisko (ekspres ciśnieniowy) - studenci mogą czekać w kolejce
   task Coffee_Station_Task is
      entry Drink_Coffee (
         S_Id       : in  Student_Id;
         Energy_In  : in  Natural;
         Energy_Out : out Natural
      );

      entry Stop;
   end Coffee_Station_Task;

end Coffee_Station;
