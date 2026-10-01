package Greetings is

   -- Procedura wyswietlajaca powitanie
   procedure Say_Hello (Name : in String);

   -- Funkcja pomocnicza zwracajaca sformatowany tekst
   function Format_Greeting (Name : in String) return String;

end Greetings;
