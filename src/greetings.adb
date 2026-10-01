with Ada.Text_IO; use Ada.Text_IO;

package body Greetings is

   function Format_Greeting (Name : in String) return String is
   begin
      return "Czesc, " & Name & "! Twoje srodowisko Ada dziala poprawnie.";
   end Format_Greeting;

   procedure Say_Hello (Name : in String) is
   begin
      Put_Line (Format_Greeting (Name));
   end Say_Hello;

end Greetings;
