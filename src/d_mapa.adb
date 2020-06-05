with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Hash;
package body d_mapa is

   procedure mapa_buit(m: out mapa) is
   begin
      null;
   end mapa_buit;
   
   procedure put_ciutat(m: in out mapa; ciutat: in t_ciutat) is
   begin
      null;
   end put_ciutat;
   
   procedure delete_ciutat(m: in out mapa; ciutat: in t_ciutat) is
   begin
      null;
   end delete_ciutat;
   
   procedure put_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat;
                           km: in distance) is
   begin
      null;
   end put_carretera;
   
   procedure delete_carretera(m: in out mapa; ciutat1, ciutat2: in t_ciutat) is
   begin
      null;
   end delete_carretera;
   
   procedure distancia_min(m: in mapa; ciutat1, ciutat2: in t_ciutat;
                           km: out distance) is
   begin
      null; 
   end distancia_min;
   
   procedure imprimir_veinats(m: in mapa; ciutat: in t_ciutat) is
   begin
      null;
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
