with hashing; with d_graph;
generic
   
   num_ciutats: Natural;
   
package d_mapa is

   type mapa is limited private; -- tipus corresponent al TAD
   subtype distance is float;
   type t_ciutat is new String;
   
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
   
private

   package graph is new d_graph(size_vertices => num_ciutats); use graph;
   
   type mapa is record
      null;
   end record;
   
   
end d_mapa;
