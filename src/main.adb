with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Hash;
with hashing; with d_graph; with d_mapa;
procedure Main is

   --Segunda semana-------------------------
   nombre_max_length: Positive := 30;
   type Municipio is record
      nombre: String (1 .. nombre_max_length);
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
   cant_municipios: Positive := 67;

   function igual(x1, x2: in Municipio) return Boolean is
   begin
      return x1.nombre(1..x1.length)=x2.nombre(1..x2.length);
   end igual;

   package municipios_hashing is new hashing
     (key => Municipio, item => Float, hash => Hash, size => cant_municipios, "=" => igual);
   use municipios_hashing;

   datos: String := "municipis_superficie_mallorca.txt";
   s: municipios_hashing.conjunto;

   procedure Obtener_Datos (file: String; separator: Character; mostrarDatos: Boolean) is
      muni: Municipio; -- Nombre del municipio
      area: Float;     -- Area/superficie del municipio
      idx: Integer;
      fichero: File_Type;
      aux: String(1..nombre_max_length+20);
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
            Ada.Text_IO.Set_Col
              (Standard_Output, count(nombre_max_length+1));  -- Separación de datos
            put(area, 0, 2, 0); New_Line;              -- Area del municipio
         end if;
         poner(s, muni, area);
      end loop;
      Close(fichero);
   end Obtener_Datos;
   -----------------------------------------

   --Tercera semana-------------------------
   -- La tercera semana usa 4 verices
   package municipios_graph is new d_graph (size_vertices => 4);
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

   --  Mallorca tiene 67 municipios
   --  cant_municipios: Positive := 67;
   package mallorca_d_mapa is new d_mapa (num_ciutats => cant_municipios);
   use mallorca_d_mapa;

   mallorca: mapa;
   ciudad1, ciudad2: t_ciutat;
   distancia: mallorca_d_mapa.distance;

   procedure Semana_4 (s1,s2: String; separator: Character) is
      fichero: File_Type;
      ciudad1, ciudad2: t_ciutat;
      idx1, idx2: Integer;
      distancia: mallorca_d_mapa.distance;

      aux: String(1..2*nombre_max_length+20);
      length: Natural;
   begin
      --  Iniciamos el mapa
      mapa_buit(mallorca);

      --  Leemos los municipios
      Open(fichero, In_File, s1);
      while not End_Of_File(fichero) loop
         Get_Line(fichero, aux, length);  -- Nombre y longitud del mismo
         ciudad1.nombre(1..length) := aux(1..length);
         ciudad1.longitud:=length;
         --  Rellenamos el nombre
         for I in ciudad1.longitud+1..ciudad1.nombre'Last loop
            ciudad1.nombre(I) := ' ';
         end loop;
         Put_Line("Introducimos la ciudad " & ciudad1.nombre(1..ciudad1.longitud));

         put_ciutat(m      => mallorca,
                    ciutat => ciudad1);  -- Los cargamos en el mapa
      end loop;
      Close(fichero);

      --  Leemos las carreteras
      Open(fichero, In_File, s2);
      while not End_Of_File(fichero) loop
         Get_Line(fichero, aux, length);  --  Leemos los datos
         idx1:= 1;

         --  Separamos los datos

         --  Obtenemos la primera ciudad
         while aux(idx1)/=separator loop
            idx1:= idx1+1;
         end loop;
         -- Guardamos la primera ciudad
         ciudad1.nombre(1..idx1-1) := aux(1..idx1-1);
         ciudad1.longitud := idx1-1;
         --  Rellenamos el nombre
         for I in ciudad1.longitud+1..ciudad1.nombre'Last loop
            ciudad1.nombre(I) := ' ';
         end loop;

         --  Obtenemos la segunda ciudad
         idx2:= idx1+1;
         while aux(idx2)/=separator loop
            idx2:= idx2+1;
         end loop;
         -- Guardamos la segunda ciudad
         ciudad2.nombre(1..idx2-idx1) := aux(idx1+1..idx2);
         ciudad2.longitud := idx2-idx1-1;
         --  Rellenamos el nombre
         for I in ciudad2.longitud+1..ciudad2.nombre'Last loop
            ciudad2.nombre(I) := ' ';
         end loop;

         --  Obtenemos la distancia de la carretera
         distancia:=Float'Value(aux(idx2+1..length));

         --  Añadimos la carretera
         Put("Unimos las ciudades " & ciudad1.nombre(1..ciudad1.longitud)
                  & " y " & ciudad2.nombre(1..ciudad2.longitud)
                  & " con una carretera de longitud ");
         Put(Float(distancia), 0, 2, 0); Put("km."); New_Line;

         put_carretera(m       => mallorca,
                       ciutat1 => ciudad1,
                       ciutat2 => ciudad2,
                       km      => distancia);

      end loop;
      Close(fichero);

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

   --  Carga de datos

   Semana_4 (municipios, distancias, ';');

   --  Distancia minima
   New_Line;
   ciudad1:=(nombre => "Felanitx                      ", longitud => 8);
   ciudad2:=(nombre => "Sineu                         ", longitud => 5);
   distancia_min(mallorca, ciudad1, ciudad2, distancia);

   --  Imprimir vecinos
   New_Line;
   ciudad1:=(nombre => "Felanitx                      ", longitud => 8);
   imprimir_veinats(mallorca, ciudad1);
   delete_ciutat(mallorca, ciudad1);


end Main;
