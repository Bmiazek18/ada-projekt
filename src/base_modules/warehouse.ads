with ECTS_Types; use ECTS_Types;

package Warehouse is

   -- Magazyn punktow ECTS w Dziekanacie
   task Warehouse_Task is
      entry Store_Items (
         Delivery : in  Delivery_Record;
         Accepted : out Boolean
      );

      entry Get_Stock (
         Stock        : out Warehouse_Stock_Array;
         Total_Stock  : out Natural;
         Max_Cap      : out Natural
      );

      entry Stop;
   end Warehouse_Task;

end Warehouse;
