with ECTS_Types; use ECTS_Types;

package Lecturers is

   -- Wykładowca dostarczający protokoły ocen z katedry
   task type Lecturer_Type (
      Id           : Lecturer_Id;
      Delay_Tenths : Natural;
      Kind         : Item_Kind;
      Amount       : Positive
   );

end Lecturers;
