with Ada.Text_IO; use Ada.Text_IO;
with Greetings;

procedure Main is
begin
   Put_Line ("=====================================");
   Put_Line ("   Witaj w projekcie Ada!           ");
   Put_Line ("=====================================");
   New_Line;

   Greetings.Say_Hello (Name => "Programisto");
end Main;
