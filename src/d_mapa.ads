with hashing; with d_graph;
generic
   
   num_ciutats: Natural;
   
package d_mapa is

   type mapa is limited private; -- tipus corresponent al TAD
   subtype distance is float;
   type t_ciutat is record
      nombre: String(1..30);
      longitud: Natural;
   end record;
   
   city_already_exists: exception;
   city_doesnt_exists: exception;
   road_doesnt_exists: exception;
   
   procedure mapa_buit(m: out mapa);
   procedure put_ciutat(m: in out mapa; ciutat: in t_ciutat);
   procedure delete_ciutat(m: in out mapa; ciutat: in t_ciutat);
   procedure put_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat;
                           km: in distance);
   procedure delete_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat);
   procedure distancia_min(m: in mapa; ciutat1, ciutat2: in t_ciutat;
                           km: out distance);
   procedure imprimir_veinats(m: in mapa; ciutat: in t_ciutat);
   
   function Hash (k: in t_ciutat; b: in Positive) return Natural;   
   function igual(x1, x2: in t_ciutat) return Boolean;

private

   package mapa_hashing is new hashing
     (key => t_ciutat, item => distance, hash => Hash, size => num_ciutats, "=" => igual);
   use mapa_hashing;
   
   package mapa_graph is new d_graph (size_vertices => num_ciutats);
   use mapa_graph;   

   type mapa is record
      ciudad: conjunto;
      conexiones: graph;
   end record;

end d_mapa;
