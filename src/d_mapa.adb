package body d_mapa is

   procedure mapa_buit(m: out mapa) is
   begin
   end mapa_buit;
   
   procedure put_ciutat(m: in out mapa; ciutat: in t_ciutat) is
   begin
   end put_ciutat;
   
   procedure delete_ciutat(m: in out mapa; ciutat: in t_ciutat) is
   begin
   end delete_ciutat;
   
   procedure put_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat;
                           km: in distance) is
   begin
   end put_carretera;
   
   procedure delete_carretera(m: in out mapa; ciutat1, ciutat2: int_ciutat) is
   begin
   end delete_carretera;
   
   procedure distancia_min(m: in mapa; ciutat1, ciutat2: in t_ciutat;
                           km: out distance) is
   begin 
   end distancia_min;
   
   procedure imprimir_veinats(m: in mapa; ciutat: in t_ciutat) is
   begin
   end imprimir_veinats;

end d_mapa;
