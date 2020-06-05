with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Hash;
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with graph_exceptions;  use graph_exceptions;
package body d_mapa is

   procedure mapa_buit(m: out mapa) is
   begin
      cvacio(m.ciudades);   --  Iniciamos las ciudades
      empty(m.carreteras);  --  Iniciamos las carreteras entre ciudades
      cvacia(qu);           --  Iniciamos la cola de vertices liberados
   end mapa_buit;
   
   procedure put_ciutat(m: in out mapa; ciutat: in t_ciutat) is
      ciudades: conjunto renames m.ciudades;
      v: vertex;
      Occupied: Boolean := True;
   begin
      --  Si hay vertices liberados
      if not esta_vacia(qu) then
         v:=coger_primero(qu);
         borrar_primero(qu);
      --  Si no cogemos el siguiente vertice libre
      else
         v:= next_vertex;
         next_vertex:= next_vertex+1;
      end if;
      
      --  Introducimos la ciudad
      poner(ciudades, ciutat, v);
      --  Actualizamos la array de ciudades
      lista_ciudades(v):= ciutat;

   exception
      when already_exists => raise city_already_exists;
   end put_ciutat;
   
   procedure delete_ciutat(m: in out mapa; ciutat: in t_ciutat) is
      ciudades: conjunto renames m.ciudades;
      carreteras: graph renames m.carreteras;
      it: iterator;
      v1, v2: vertex;
   begin
      --  Borramos la ciudad
      consultar(ciudades, ciutat, v1);  --  Obtenemos el vertex que ocupaba la ciudad
      poner(qu, v1);                    --  Liberamos el vertex
      borrar(ciudades, ciutat);         --  Borramos la ciudad
      
      --  Borramos sus carreteras
      first(carreteras, v1, it);        --  Obtenemos primera conexión de la ciutat
      while is_valid(it) loop
         get(carreteras, it, v2);       --  Obtenemos el vertice de la ciudad con el que conecta
         remove_edge(carreteras, v1, v2);  --  Borramos la conexion entre ambas
         next(carreteras, it);          --  Siguiente carretera
      end loop;
      
   exception
         when does_not_exist => raise city_doesnt_exists;
   end delete_ciutat;
   
   procedure put_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat;
                           km: in distance) is
      ciudades: conjunto renames m.ciudades;
      carreteras: graph renames m.carreteras;
      v1, v2: vertex;
   begin

      consultar(ciudades, ciutat1, v1);  --  Obtenemos el vertex que ocupa la ciudad1
      consultar(ciudades, ciutat2, v2);  --  Obtenemos el vertex que ocupa la ciudad2
      put_edge(carreteras, v1, v2, mapa_graph.distance(km));  --  Ponemos la carretera entre ambas

   exception
      when no_existe => raise city_doesnt_exists;
      when already_exists => raise road_already_exists;
   end put_carretera;
   
   procedure delete_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat) is
      ciudades: conjunto renames m.ciudades;
      carreteras: graph renames m.carreteras;
      v1, v2: vertex;
   begin
      
      consultar(ciudades, ciutat1, v1);  --  Obtenemos el vertex que ocupaba la ciudad1
      consultar(ciudades, ciutat2, v2);  --  Obtenemos el vertex que ocupaba la ciudad2
      remove_edge(carreteras, v1, v2);   --  ELiminamos la carretera entre ambas                                      
   
   exception
      when no_existe => raise road_doesnt_exists;
   end delete_carretera;
   
   procedure distancia_min(m: in mapa; ciutat1, ciutat2: in t_ciutat;
                           km: out distance) is
   begin

      null; 

   exception
      when no_existe => raise city_doesnt_exists;
   end distancia_min;
   
   procedure imprimir_veinats(m: in mapa; ciutat: in t_ciutat) is
      ciudades: conjunto renames m.ciudades;
      carreteras: graph renames m.carreteras;
      v1, v2: vertex;
      it: iterator;
      

   begin
      --  Obtenemos el vertex de la ciudad
      consultar(ciudades, ciutat, v1);
      
      --  Obtenemos sus vecinos
      first(carreteras, v1, it);
      Put_Line("Vertices vecinos del vértice " & ciutat.nombre(1..ciutat.longitud));
      while is_valid(it) loop
         get(carreteras, it, v2);
         Put_Line("· " & lista_ciudades(v2).nombre(1..lista_ciudades(v2).longitud));
         next(carreteras, it);
      end loop;
      
   exception
      when no_existe => raise city_doesnt_exists;
   end imprimir_veinats;

   
   function Hash (k: in t_ciutat; b: in Positive) return Natural is
      h: Ada.Containers.Hash_Type;
      s: natural;
   begin
      h:= Ada.Strings.Hash(k.nombre) mod Hash_Type(b);
      s:= Natural(h);
      return s;
   end Hash;
   
   function igual(x1, x2: in t_ciutat) return Boolean is
   begin
      return x1.nombre(1..x1.longitud)=x2.nombre(1..x2.longitud);
   end igual;
   
end d_mapa;
