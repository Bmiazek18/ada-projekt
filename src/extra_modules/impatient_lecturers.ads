with ECTS_Types; use ECTS_Types;

package Impatient_Lecturers is

   -- Wykladowca z ograniczonym czasem oczekiwania (timed entry call)
   task type Impatient_Lecturer_Type (
      Lecturer_Number : Lecturer_Id;
      Protocol_Id     : Positive;
      Delay_Tenths    : Natural;
      Kind            : Item_Kind;
      Amount          : Positive;
      Patience_Tenths : Positive
   );

end Impatient_Lecturers;
