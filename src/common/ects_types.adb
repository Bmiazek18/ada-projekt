with Ada.Strings.Fixed;

package body ECTS_Types is

   function To_String (Kind : Item_Kind) return String is
   begin
      case Kind is
         when ECTS_Wyklad        => return "ECTS Wykład (Teoria)";
         when ECTS_Laboratorium => return "ECTS Laboratorium (Praktyka)";
         when ECTS_Projekt      => return "ECTS Projekt (Inżynieria)";
      end case;
   end To_String;

   function To_String (State : Student_State) return String is
   begin
      case State is
         when Wolny                    => return "Wolny (Oczekuje na zaliczenia)";
         when Odbiera_ECTS             => return "Odbiera protokół z portierni";
         when Niesie_Do_Dziekanatu     => return "Biegnie z protokołem do Dziekanatu";
         when Rejestruje_W_Dziekanacie => return "Składa protokół w Dziekanacie";
         when Idzie_Po_Kawe            => return "Brak energii, idzie do bufetu";
         when Pije_Kawe                => return "Pije Espresso w Bufecie [☕]";
         when Zakonczyl_Dzien          => return "Zakończył dyżur na wydziale";
      end case;
   end To_String;

   function Get_Lecturer_Title (Id : Lecturer_Id) return String is
      Id_Str : constant String := Ada.Strings.Fixed.Trim (Positive'Image (Id), Ada.Strings.Both);
   begin
      case Id is
         when 1 => return "Prof. Janusz (Katedra Algorytmiki) [D1]";
         when 2 => return "Dr Kowalski (Zakład Sys. Wbudowanych) [D2]";
         when 3 => return "Mgr Nowak (Katedra Sztucznej Inteligencji) [D3]";
         when 4 => return "Doc. Pośpiech (Katedra Teorii) [D4]";
         when 5 => return "Dr Wiśniewski (Katedra Sieci Komputerowych) [D5]";
         when 6 => return "Prof. Zieliński (Zakład Inżynierii Oprogramowania) [D6]";
         when 7 => return "Dr Lewandowska (Katedra Metod Numerycznych) [D7]";
         when 8 => return "Mgr Wójcik (Katedra Baz Danych) [D8]";
         when others => return "Prowadzący Katedry [D" & Id_Str & "]";
      end case;
   end Get_Lecturer_Title;

   function Get_Student_Title (Id : Student_Id) return String is
      Id_Str : constant String := Ada.Strings.Fixed.Trim (Positive'Image (Id), Ada.Strings.Both);
   begin
      case Id is
         when 1 => return "Student S1 (Starosta Roku)";
         when 2 => return "Student S2 (Wice-starosta)";
         when 3 => return "Student S3 (Stażysta Wydziału)";
         when others => return "Student S" & Id_Str;
      end case;
   end Get_Student_Title;

end ECTS_Types;
