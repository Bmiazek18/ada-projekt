with Ada.Numerics.Float_Random;
with ECTS_Types; use ECTS_Types;

package Random_Utils is

   -- Obiekt chroniony generatora liczb losowych
   protected Random_Gen is
      procedure Initialize;
      procedure Get_Random_Delay (Min_Sec, Max_Sec : in Float; Result : out Duration);
      procedure Get_Random_Amount (Min_Val, Max_Val : in Positive; Result : out Positive);
      procedure Get_Random_Kind (Result : out Item_Kind);
   private
      Gen         : Ada.Numerics.Float_Random.Generator;
      Initialized : Boolean := False;
   end Random_Gen;

   function Random_Delay (Min_Sec, Max_Sec : Float) return Duration;
   function Random_Amount (Min_Val, Max_Val : Positive) return Positive;
   function Random_Kind return Item_Kind;

end Random_Utils;
