with ECTS_Types; use ECTS_Types;

package Students is

   -- Moduł 2: Zadanie studenta-kuriera ECTS (odpowiednik robota AGV)
   task type Student_Type (Id : Student_Id) is
      entry Stop;
   end Student_Type;

   -- Obiekt chroniony: rejestr stanów i poziomów kofeiny studentów (dla Monitora)
   protected Student_Registry is
      procedure Update_Status (
         Id     : Student_Id;
         State  : Student_State;
         Energy : Natural
      );
      function Get_All_Info return Students_Info_Array;
   private
      Info_Array : Students_Info_Array := [
         1 => (Id => 1, State => Wolny, Energy => 100),
         2 => (Id => 2, State => Wolny, Energy => 100),
         3 => (Id => 3, State => Wolny, Energy => 100)
      ];
   end Student_Registry;

end Students;
