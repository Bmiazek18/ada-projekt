with ECTS_Types; use ECTS_Types;

package Impatient_Lecturers is

   -- Moduł H: Zniecierpliwiony wykładowca rezygnujący z oczekiwania (odpowiednik samochodu rezygnującego)
   -- Wykorzystuje Timed Entry Call (select ... or delay ...) do rezygnacji po przekroczeniu limitu czasu
   task type Impatient_Lecturer_Type (
      Id              : Lecturer_Id;
      Delay_Tenths    : Natural;
      Kind            : Item_Kind;
      Amount          : Positive;
      Patience_Tenths : Positive
   );

end Impatient_Lecturers;
