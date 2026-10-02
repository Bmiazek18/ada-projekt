package ECTS_Types is

   -- Rodzaje punktów ECTS
   type Item_Kind is (ECTS_Wyklad, ECTS_Laboratorium, ECTS_Projekt);

   -- Liczniki i identyfikatory
   subtype Item_Count is Natural;
   subtype Lecturer_Id is Positive;
   subtype Student_Id is Positive;

   -- Rekord pojedynczej dostawy punktów ECTS
   type Delivery_Record is record
      Id              : Positive;
      Kind            : Item_Kind;
      Amount          : Positive;
      Origin_Lecturer : Lecturer_Id;
   end record;

   -- Stany studenta-kuriera podczas dyżuru
   type Student_State is (
      Wolny,
      Odbiera_ECTS,
      Niesie_Do_Dziekanatu,
      Rejestruje_W_Dziekanacie,
      Idzie_Po_Kawe,
      Pije_Kawe,
      Zakonczyl_Dzien
   );

   -- Informacje diagnostyczne o studencie dla Monitora
   type Student_Info is record
      Id     : Student_Id;
      State  : Student_State;
      Energy : Natural; -- Poziom energii/kofeiny (0 .. 100%)
   end record;

   type Students_Info_Array is array (1 .. 3) of Student_Info;

   -- Stan magazynu w Dziekanacie dla poszczególnych rodzajów ECTS
   type Warehouse_Stock_Array is array (Item_Kind) of Natural;

   -- Funkcje pomocnicze do formatowania napisów
   function To_String (Kind : Item_Kind) return String;
   function To_String (State : Student_State) return String;
   function Get_Lecturer_Title (Id : Lecturer_Id) return String;
   function Get_Student_Title (Id : Student_Id) return String;

end ECTS_Types;
