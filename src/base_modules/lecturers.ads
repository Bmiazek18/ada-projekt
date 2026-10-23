with ECTS_Types; use ECTS_Types;

package Lecturers is

   -- Wykładowca dostarczający protokoły ocen z katedry
   task type Lecturer_Type (
      Lecturer_Number : Lecturer_Id;
      Protocol_Id     : Positive;
      Delay_Tenths    : Natural;
      Kind            : Item_Kind;
      Amount          : Positive
   );

end Lecturers;
