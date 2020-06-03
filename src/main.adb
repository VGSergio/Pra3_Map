with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Hash;
with hashing;
procedure Main is

   --Primera semana-------------------------
   Length: Positive := 30;
   subtype Municipio is String (1 .. Length);

   --Metodo para rellenar el String Municipio hasta su rango máximo
   procedure Llena_Municipio (s: in String; m: out Municipio) is
      idx: Integer;
   begin
      for N in s'Range loop
         m(N):=s(N);
         idx:=N;
      end loop;
      for I in idx+1..Length loop
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

   --Mallorca tiene 67 municipios, el número primo mayor o igual el 67
   primo: Integer := 67;

   function igual(x1, x2: in Municipio) return Boolean is
   begin
      return x1=x2;
   end igual;

   package municipios_hashing is new hashing
     (key => Municipio, item => Float, hash => Hash, size => primo, "=" => igual);
   use municipios_hashing;

   datos: String := "municipis_superficie_mallorca.txt";
   fichero: File_Type;

   s: municipios_hashing.conjunto;

   procedure Obtener_Datos (file: String) is
      c: Character;
      separatorFound: boolean := false;
      name: Municipio; -- Nombre del municipio
      area: Float;     -- Area/superficie del municipio
      aux: String(1..Length);
      idx: Integer := 1;
   begin
      cvacio(s);
      Open(fichero, In_File, file);
      while not End_Of_File(fichero) loop
         get(fichero, c);
         while not separatorFound loop
            aux(idx):=c;
            idx:= idx+1;
            get(fichero, c);
            separatorFound:= c=';';
         end loop;
         --Put(aux(1..idx-1) & " ");
         Get(fichero, area); --put(area, 0, 2, 0);
         New_Line;
         Llena_Municipio(aux(1..idx-1), name);
         Put(name & " "); put(area, 0, 2, 0);
         poner(s, name, area);
         for I in 1..Length loop
            aux(I):= ' ';
         end loop;
         idx:=1;
         separatorFound:=false;
      end loop;
      Close(fichero);
   end Obtener_Datos;
   -----------------------------------------

   --m1,m2,m3: Municipio;
   --c: Boolean;
   --h: Hash_Type;
   --n: Natural;

begin

   --Llena_Municipio("Caca", m1);
   --Llena_Municipio("acac", m2);
   --Llena_Municipio("Caca", m3);
   --c:= igual(m1, m2); Put_Line(c'Image);
   --c:= igual(m1, m3); Put_Line(c'Image);
   --c:= igual(m2, m3); Put_Line(c'Image);
   --Put_Line(m1);

   --h:=Ada.Strings.Hash(m1); Put_Line(h'Image);
   --h:=Ada.Strings.Hash(m3); Put_Line(h'Image);

   --n:= Hash(m1, Length); Put_Line(n'Image);
   --n:= Hash(m2, Length); Put_Line(n'Image);
   Obtener_Datos(datos);
end Main;
