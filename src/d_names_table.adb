package body d_names_table is

   procedure empty(tn: out names_table) is
      td: disp_table renames tn.td;
      tid: id_table renames tn.tid;   
      nid: name_id renames tn.nid;   
      nc: natural renames tn.nc;
   begin
      for i in hash_index loop
         td(i):= null_id; 
      end loop;
      nid:= 0; nc:= 0;   --para que la búsqueda para id=1 no de excepciones (pq buscaría tid(0))   
      tid(null_id):= (null_id, nc); 
   end empty;

   procedure put(tn: in out names_table; name: in string; id: out name_id) is
      td: disp_table renames tn.td;  
      tid: id_table renames tn.tid;
      tc: characters_table renames tn.tc; 
      nid: name_id renames tn.nid;  
      nc: natural renames tn.nc;   
      i: hash_type;  
      p: name_id;
   begin  
      i:= hash(name) mod b;
      p:= td(i);
      while p/=null_id and then not equal(name, tn, p) loop --busca lista de sinónimos
         p:= tid(p).psh;
      end loop;
      if p=null_id then -- no lo ha encontrado
         if nid=name_id(max_id) then 
            raise space_overflow; 
         end if; --comprueba tamaño utilizado
         if nc+name'Length>max_ch then 
            raise space_overflow;
         end if ; --comprueba espacio tc   
         save_name(name, tc, nc);--aumento, añado principio lista   
         nid:= nid+1; tid(nid):= (td(i), nc); --succ, nc. Será el primero   
         td(i):= nid; p:= nid; --td apunta nuevo elemento
      end if;  
      id:= p;
   end put;
      
   function consult(tn: in names_table; id: in name_id) return string is  
      tid: id_table renames tn.tid; 
      tc: characters_table renames tn.tc;   
      nid: name_id renames tn.nid;  
      pi, pf: natural; --pos inicial y final en tc
   begin
      if id=null_id or id>nid then
         raise bad_use;
      end if;  
      pi:= tid(id-1).ptc+1;
      pf:= tid(id).ptc;
      return tc(pi..pf);
   end consult;   
   
   procedure save_name (name: in string; tc: in out characters_table; nc: in out natural) is
   begin
      for i in name'range loop  
         nc:= nc+1;
         tc(nc):= name(i);
      end loop;
   end save_name;
   
   function equal (name: in string; tn: in names_table; p: in name_id) return boolean is
      tid: id_table renames tn.tid; 
      tc: characters_table renames tn.tc;  
      pi, pf: natural; -- posición inicial y final en tc  
      i, j: natural; -- índices sobre el nombre (i) y en tc (j)
   begin 
      pi:= tid(p-1).ptc+1; 
      pf:= tid(p).ptc; 
      i:= name'first; 
      j:= pi;
      while name(i)=tc(j) and i<name'last and j<pf loop 
         i:= i+1; j:= j+1;
      end loop;--igualdad de final, último caracter name y final de la palabra comparada
      return name(i)=tc(j) and i=name'last and j=pf;
   end equal;   

end d_names_table;
