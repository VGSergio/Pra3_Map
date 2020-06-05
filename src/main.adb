with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Hash;
with hashing; with d_graph; --with d_mapa;
procedure Main is

   --Segunda semana-------------------------
   type Municipio is record
      nombre: String (1 .. 30);
      length: Natural;
   end record;

   function Hash (k: in Municipio; b: in Positive) return Natural is
      h: Ada.Containers.Hash_Type;
      s: natural;
   begin
      h:= Ada.Strings.Hash(k.nombre) mod Hash_Type(b);
      s:= Natural(h);
      return s;
   end Hash;

   --Mallorca tiene 67 municipios, el siguiente número primo mayor o igual es 67
   primo: Integer := 67;

   function igual(x1, x2: in Municipio) return Boolean is
   begin
      return x1.nombre(1..x1.length)=x2.nombre(1..x2.length);
   end igual;

   package municipios_hashing is new hashing
     (key => Municipio, item => Float, hash => Hash, size => primo, "=" => igual);
   use municipios_hashing;

   datos: String := "municipis_superficie_mallorca.txt";
   s: municipios_hashing.conjunto;

   procedure Obtener_Datos (file: String; separator: Character; mostrarDatos: Boolean) is
      muni: Municipio; -- Nombre del municipio
      area: Float;     -- Area/superficie del municipio
      idx: Integer;
      fichero: File_Type;
      aux: String(1..50);
      length: Natural;
   begin
      cvacio(s);
      Open(fichero, In_File, file);
      while not End_Of_File(fichero) loop
         Get_Line(fichero, aux, length);
         idx:=1;
         -- Obtenemos posicion del separador
         while aux(idx)/=separator loop
            idx:= idx+1;
         end loop;
         --  Nombre del municipio y longitud del nombre
         muni.nombre(1..idx-1):= aux(1..idx-1);
         muni.length:=idx-1;
         --  Area del municipio
         area:=Float'Value(aux(idx+1..length));
         if mostrarDatos then
            Put(muni.nombre(1..muni.length));          -- Nombre municipio
            Ada.Text_IO.Set_Col(Standard_Output, 31);  -- Separación de datos
            put(area, 0, 2, 0); New_Line;              -- Area del municipio
         end if;
         poner(s, muni, area);
      end loop;
      Close(fichero);
   end Obtener_Datos;
   -----------------------------------------

   --Tercera semana-------------------------
   prueba: Integer := 4;
   package municipios_graph is new d_graph (size_vertices => prueba);
   use municipios_graph;

   grafo: graph;

   procedure Semana_3 (g: out graph) is
      --min: distance;
      it: iterator;
      v: vertex;
      d: distance;
   begin
      -- Initialize vertices
      empty(g);
      put_edge(g, 1, 2, 3.0);
      put_edge(g, 1, 3, 1.0);
      put_edge(g, 1, 4, 5.0);
      put_edge(g, 2, 4, 1.0);
      put_edge(g, 3, 2, 1.0);

      -- TO-DO: Shortest path from 4 to 1


      -- Print the vertices connected to 4.
      first(g, 4, it);
      Put_Line("Vertices vecinos del vértice 4");
      while is_valid(it) loop
         get(g, it, v, d);
         Put("· Vértice" & v'Image & " (a "); put(Float(d), 0, 1, 0); Put(" km)"); New_Line;
         next(g, it);
      end loop;

   end Semana_3;
   -----------------------------------------

   --Cuarta semana--------------------------
   municipios: String := "municipis_mallorca.txt";
   distancias: String := "distancies_mallorca.txt";

   procedure Semana_4 (s1,s2: String) is
      fichero: File_Type;
   begin
      null;
   end Semana_4;
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
   Semana_3 (grafo);
   -----------------------------------------

   --Cuarta semana--------------------------
   New_Line;
   Put_Line("Cuarta Semana");
   Semana_4 (municipios, distancias);
   -----------------------------------------

end Main;
