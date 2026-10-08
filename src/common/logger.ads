with Ada.Calendar;
with ECTS_Types; use ECTS_Types;

package Logger is

   protected Screen_Logger is
      procedure Log (Msg : String);
      procedure Log_Highlighted (Prefix : String; Msg : String);
      procedure Log_Status_Table (
         Stock         : Warehouse_Stock_Array;
         Total_Stock   : Natural;
         Max_Capacity  : Natural;
         Pending_Docks : Natural;
         Students      : Students_Info_Array;
         Completed_Del : Natural;
         Rejected_Del  : Natural
      );
   private
      Start_Time : Ada.Calendar.Time := Ada.Calendar.Clock;
   end Screen_Logger;

   function Get_Timestamp (T_Start : Ada.Calendar.Time) return String;

end Logger;
