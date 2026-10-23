with ECTS_Types; use ECTS_Types;

package Warehouse is

   Annual_ECTS_Capacity : constant Natural := 60;

   -- Magazyn punktow ECTS w Dziekanacie
   task Warehouse_Task is
      entry Store_Items (
         Delivery : in  Delivery_Record;
         Accepted : out Boolean
      );

      entry Get_Stock (
         Out_Stock    : out Warehouse_Stock_Array;
         Total_Points : out Natural;
         Capacity     : out Natural
      );

      entry Stop;
   end Warehouse_Task;

end Warehouse;
