with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Hash;
with hashing; with d_graph;
procedure Main is

   --Segunda semana-------------------------
   Length: Positive := 30;
   subtype Municipio is String (1 .. Length);

   --Metodo para rellenar el String Municipio hasta su rango máximo
   procedure Llena_Municipio (m: out Municipio; idx: in Positive) is
   begin
      for I in idx..m'Last loop
         m(I):= ' ';
      end loop;
   end Llena_Municipio;

   --Hash
   function Hash (k: in Municipio; b: in Positive) return Natural is
      h: Ada.Containers.Hash_Type;
      s: natural;
   begin
      h:= Ada.Strings.Hash(k) mod Hash_Type(b);
      s:= Natural(h);
      return s;
   end Hash;

   --Mallorca tiene 67 municipios, el siguiente número primo mayor o igual es 67
   primo: Integer := 67;

   function igual(x1, x2: in Municipio) return Boolean is
   begin
      return x1=x2;
   end igual;

   package municipios_hashing is new hashing
     (key => Municipio, item => Float, hash => Hash, size => primo, "=" => igual);
   use municipios_hashing;

   datos: String := "municipis_superficie_mallorca.txt";
   s: municipios_hashing.conjunto;

   procedure Obtener_Datos (file: String; separator: Character; mostrarDatos: Boolean) is
      c: Character;
      separatorFound: boolean;
      name: Municipio; -- Nombre del municipio
      area: Float;     -- Area/superficie del municipio
      idx: Integer;
      fichero: File_Type;
   begin
      cvacio(s);
      Open(fichero, In_File, file);
      while not End_Of_File(fichero) loop
         idx:=1;
         get(fichero, c);
         separatorFound:= c=separator;
         while not separatorFound loop
            name(idx):=c;
            idx:= idx+1;
            get(fichero, c);
            separatorFound:= c=separator;
         end loop;
         Get(fichero, area);
         Llena_Municipio(name, idx);
         if mostrarDatos then
            Put(name & " "); put(area, 0, 2, 0); New_Line;
         end if;
         poner(s, name, area);
      end loop;
      Close(fichero);
   end Obtener_Datos;
   -----------------------------------------

   --Tercera semana-------------------------



   -----------------------------------------

begin

   --Segunda semana-------------------------
   New_Line;
   Put_Line("Segunda Semana");
   Obtener_Datos(datos, ';', true);
   -----------------------------------------

   --Tercera semana-------------------------
   New_Line;
   Put_Line("Tercera Semana");

   -----------------------------------------

end Main;
