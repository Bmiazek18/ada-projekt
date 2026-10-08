package body Random_Utils is

   protected body Random_Gen is

      procedure Initialize is
      begin
         Ada.Numerics.Float_Random.Reset (Gen);
         Initialized := True;
      end Initialize;

      procedure Ensure_Init is
      begin
         if not Initialized then
            Ada.Numerics.Float_Random.Reset (Gen);
            Initialized := True;
         end if;
      end Ensure_Init;

      procedure Get_Random_Delay (Min_Sec, Max_Sec : in Float; Result : out Duration) is
         Val : Float;
      begin
         Ensure_Init;
         Val := Min_Sec + (Max_Sec - Min_Sec) * Ada.Numerics.Float_Random.Random (Gen);
         Result := Duration (Val);
      end Get_Random_Delay;

      procedure Get_Random_Amount (Min_Val, Max_Val : in Positive; Result : out Positive) is
         Val     : Float;
         Int_Val : Integer;
      begin
         Ensure_Init;
         Val := Float (Min_Val) + Float (Max_Val - Min_Val) * Ada.Numerics.Float_Random.Random (Gen);
         Int_Val := Integer (Float'Rounding (Val));
         if Int_Val < Min_Val then
            Int_Val := Min_Val;
         elsif Int_Val > Max_Val then
            Int_Val := Max_Val;
         end if;
         Result := Int_Val;
      end Get_Random_Amount;

      procedure Get_Random_Kind (Result : out Item_Kind) is
         Val : Float;
      begin
         Ensure_Init;
         Val := Ada.Numerics.Float_Random.Random (Gen);
         if Val < 0.333 then
            Result := ECTS_Wyklad;
         elsif Val < 0.666 then
            Result := ECTS_Laboratorium;
         else
            Result := ECTS_Projekt;
         end if;
      end Get_Random_Kind;

   end Random_Gen;

   function Random_Delay (Min_Sec, Max_Sec : Float) return Duration is
      Res : Duration;
   begin
      Random_Gen.Get_Random_Delay (Min_Sec, Max_Sec, Res);
      return Res;
   end Random_Delay;

   function Random_Amount (Min_Val, Max_Val : Positive) return Positive is
      Res : Positive;
   begin
      Random_Gen.Get_Random_Amount (Min_Val, Max_Val, Res);
      return Res;
   end Random_Amount;

   function Random_Kind return Item_Kind is
      Res : Item_Kind;
   begin
      Random_Gen.Get_Random_Kind (Res);
      return Res;
   end Random_Kind;

end Random_Utils;
