package Delivery_Stats is

   -- Obiekt chroniony rejestrujacy statystyki dostaw
   protected Stats is
      procedure Register_Success;
      procedure Register_Timeout;
      procedure Get_Stats (Success : out Natural; Timeouts : out Natural);
   private
      Completed : Natural := 0;
      Rejected  : Natural := 0;
   end Stats;

end Delivery_Stats;
