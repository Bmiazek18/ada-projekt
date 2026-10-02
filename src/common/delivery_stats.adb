package body Delivery_Stats is

   protected body Stats is
      procedure Register_Success is
      begin
         Completed := Completed + 1;
      end Register_Success;

      procedure Register_Timeout is
      begin
         Rejected := Rejected + 1;
      end Register_Timeout;

      procedure Get_Stats (Success : out Natural; Timeouts : out Natural) is
      begin
         Success  := Completed;
         Timeouts := Rejected;
      end Get_Stats;
   end Stats;

end Delivery_Stats;
