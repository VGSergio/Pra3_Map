package body d_min_register is

   procedure empty(minr: out min_register; pathr: out single_s_path_register) is
      td: dist_table renames pathr.td;
      tp: pred_table renames pathr.tp;
      nh: natural renames minr.nh;
   begin
      for x in vertex loop
         td(x):= infty;
         tp(x):= x; --distancia y predecesor
      end loop;
      nh:= 0;
   end empty;
   
   procedure put(minr: in out min_register; pathr: in out single_s_path_register;
                 x, predx: in vertex; dx: in distance) is
      td: dist_table renames pathr.td;
      tp: pred_table renames pathr.tp;
      ph: pos_heap renames minr.ph;
      h: heap_space renames minr.h;
      nh: natural renames minr.nh;
      i: natural;  --índicea un nodo en el heap
      pi: natural; --índiceal padre del nodo i 
   begin
      if td(x)=infty then
         nh:= nh+1; 
         ph(x):= nh;
      end if; --x no está en minr
      td(x):= dx;
      tp(x):= predx;
      i:= ph(x);
      pi:= i/2; --pos en heap y a su padre
      while pi>0 and then td(h(pi))>dx loop --busca el lugardel elemento
         h(i):= h(pi); ph(h(i)):= i; --actualiza vértice en heap y posición
         i:= pi; pi:= i/2;
      end loop;
      h(i):= x; ph(x):= i; --coloca elemento en su sitio
   end put;   
   
   procedure delete_min(minr: in out min_register; pthr: in single_s_path_register) is
      td: dist_tablerenamespthr.td;
      ph: pos_heaprenamesminr.ph;
      h: heap_spacerenamesminr.h;
      nh: natural renames minr.nh;
      i: natural;  --índicea un nodo en el heap 
      ci: natural; --índiceal menor hijo del i
      x: vertex;
      dx: distance;
   begin
      if nh=0 then 
         raise bad_use;
      end if;
      x:= h(nh);
      nh:= nh-1;
      dx:= td(x);i:= 1;  
      ci:= i2;
      if ci<nh and then td(h(ci+1))<td(h(ci)) then 
         ci:= ci+1; 
      end if;
      while ci<=nh and then td(h(ci)) < dx loop
         h(i):= h(ci);  
         ph(h(i)):= i;
         i:= ci; 
         ci:= i2;
         if ci<nh and then td(h(ci+1))<td(h(ci)) then
            ci:= ci+1;
         end if;
      end loop;
      h(i):= x; 
      ph(x):= i;
   end delete_min;   

   function get_min(minr: in min_register) return vertex is 
      h: heap_space renames minr.h;
      nh: natural renames minr.nh;
   begin
      if nh=0 then 
         raise bad_use; 
      end if;
      return h(1);
   end get_min;

   function is_empty(minr: in min_register) return boolean is
      nh: natural renames minr.nh;
   begin
      return nh=0;
   end is_empty;
   
end d_min_register;
