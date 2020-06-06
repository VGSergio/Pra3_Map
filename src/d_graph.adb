with graph_exceptions; use graph_exceptions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
package body d_graph is

   -- Creates empty graph
   procedure empty (g: out graph) is
   begin
      for I in vertex'Range loop
         g(I):=null; -- Set each cell in the array to null
      end loop;
   end empty;
   
   -- Creates an edge connecting two vertices.
   procedure put_edge(g: in out graph; x,y: in vertex; d: in distance) is
      p: pcell;
   begin
      
      -- We first check if the edge already exists. As we place each edge twice,
      -- there is no necessity to check y->x as well.
      p:= g(x);
      while p/=null loop
         if p.x=y then raise already_exists; end if;
         p:=p.next;
      end loop;
      
      -- x -> y
      p:= new cell;
      p.all:=(y, d, g(x));
      g(x):=p;
      -- y -> x
      p:= new cell;
      p.all:=(x, d, g(y));
      g(y):=p;
   end put_edge;
   
   -- Removes an edge connecting two vertices.
   procedure remove_edge (g: in out graph; x,y: in vertex) is
      curr, prev: pcell; -- Current and previous cells to iterate through lists
      found: boolean:= false;
   begin
      if g(x)=null or g(y)=null then raise does_not_exist; end if;
      curr:= g(x);
      prev:= null;
      -- x -> y
      while curr/=null and not found loop -- While not end of list
         if curr.x/=y then          -- If vertex was not found
            prev:= curr;               -- We iterate through the list.
            curr:= curr.next;
         else                       -- If vertex was found
            found:= true;
            curr.d:= infty;         -- Distance is set to infinity for good
                                    -- measure.
            if prev = null then        -- if it was the first one, the array g
               g(x) := curr.next;      -- is updated directly.
            else
               prev.next := curr.next; -- Otherwise, the list is updated.
            end if;
         end if;
      end loop;
      if not found then raise does_not_exist; end if;
      -- y -> x
      curr:= g(y);
      prev:= null;
      found:= false;
      while curr/=null and not found loop -- While not end of list and not found
         if curr.x/=x then          -- If vertex was not found
            prev:= curr;               -- We iterate through the list.
            curr:= curr.next;
         else                       -- If vertex was found
            found:= true;
            curr.d:= infty;         -- Distance is set to infinity for good
                                    -- measure.
            if prev = null then        -- if it was the first one, the array g
               g(y) := curr.next;      -- is updated directly.
            else
               prev.next := curr.next; -- Otherwise, the list is updated.
            end if;
         end if;
      end loop;
      if not found then raise does_not_exist; end if;
   end remove_edge;
   
   -- Gets the distance between two vertices
   function get_distance (g: in graph; x,y : in vertex) return distance is
      aux: pcell;
      d: distance := infty;   -- If it stays as infinity, edge does not exist
   begin
      if g(x)=null or g(y)=null then return d; end if;
      aux:= g(x);
      while aux /= null loop  -- We iterate through the list of edges
         if aux.x /= y then
            aux:= aux.next;
         else
            d:= aux.d;
            aux:=null;        -- Set aux to null so we can exit the loop.
         end if;
      end loop;
      return d;
   end get_distance;   
   
   -- Returns first not null vertex connected to a given vertex.
   procedure first (g: in graph; x: in vertex; it: out iterator) is
      p: pcell renames it.p;
   begin
--      if g(x)=null then raise bad_use; end if;
      p:= g(x);
   end first;
   
   -- Returns the next not null vertex on the iterator.
   procedure next (g: in graph; it: in out iterator) is
      p: pcell renames it.p;
   begin
      if p=null then raise bad_use; end if;
      p:= p.next;
   end next;
   
   -- Returns whether the iterator is in a valid location of the edge list.
   function is_valid(it: in iterator) return boolean is
      p: pcell renames it.p;
   begin
      if p=null then
         return false;
      else
         return true;
      end if;
   end is_valid;
   
   -- Gets the vertex that is connected through the edge in which the iterator
   -- is located.
   procedure get (g: in graph; it: in iterator; y: out vertex) is
      p: pcell renames it.p;
   begin
      if p=null then raise bad_use; end if;
      y:=p.x;
   end get;

   -- Gets the vertex that is connected through the edge in which the iterator
   -- is located and the edge's distance.
   procedure get (g: in graph; it: in iterator;  y: out vertex;  d: out distance) is 
      p: pcell renames it.p;
   begin
      if p=null then raise bad_use; end if;
      y:=p.x;
      d:=p.d;
   end get;
   
   procedure shortest_paths_sparse(g: in graph; v0: in vertex; pthr: out single_s_path_register) is
      use d_min_register;
      td : dist_table renames pthr.td;
      minr : min_register;
      x, y : vertex;
      it : iterator;
      dx, dy : distance; -- de v0 a x y a y en caminos especiales mínimos
      dxy : distance; -- de x a y
      dyn : distance; -- de v0 a y en el nuevo camino especial mínimo
   begin
      empty(minr, pthr); --distancias a infinito y predecesor a si mismo, número de elementos en el heap a 0
      put(minr, pthr, v0, v0, 0.0); -- guarda v0 como origen (x y pred son v0)
      delete_min(minr, pthr); -- borrarlo del cálculo de min
      first(g, v0, it); -- sucesores de v0
      while is_valid(it) loop
         get(g, it, x, dx); next(g, it);
         put(minr, pthr, x, v0, dx);
      end loop;
      while not is_empty(minr) loop -- no hay más vértices en V-S o no son accesibles de v0
           x:= get_min(minr); dx:= td(x);
         delete_min(minr, pthr);
         first(g, x, it);
         while is_valid(it) loop
            get(g, it, y, dxy); next(g, it);
            dy:= td(y);
            dyn:= dx+dxy;
            if dyn < dy then put(minr, pthr, y, x, dyn); end if ;
         end loop;
      end loop;
   end shortest_paths_sparse;
   
   procedure get_path(pthr: in single_s_path_register; x: in vertex; pth: out path) is
      td : dist_table renames pthr.td;
      tp : pred_table renames pthr.tp;
      length : distance renames pth.length;
      steps : natural renames pth.steps;
      p : path_array renames pth.p;
      z : vertex;
      i, j : positive;
   begin
      length:= td(x); -- distancia calculada de x
      if length = infty then steps:= 0;
      else
         z:= x; steps:= 1; p(steps):= z;
         while tp(z)/=z loop -- no llegar al inicio v0
            z:= tp(z); steps:= steps+1; p(steps):= z;
         end loop;
         i:= 1; j:= steps; -- construir imagen espejo para poner path de forma directa
         while i<j loop
            z:= p(i); p(i):= p(j); p(j):= z;
            i:= i+1; j:= j-1;
         end loop;
      end if ;
   end get_path;
   
   procedure print_path(pth: in path) is
      length: distance renames pth.length;
      steps: natural renames pth.steps;
      p: path_array renames pth.p;
   begin
      Put("· Distancia mínima: "); Put(Float(length), 0 ,2, 0); Put_Line(" km.");
      Put("· Recorrido: ");
      for I in 1..steps-1 loop
         Put(p(I)'Image & " -");
      end loop;
      Put(p(steps)'Image & "."); New_Line;
   end print_path;
   
   function get_length(pth: in path) return distance is
      l: distance renames pth.length;
   begin
      return l;
   end get_length;
   
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
   
      procedure delete_min(minr: in out min_register; pathr: in single_s_path_register) is
         td: dist_table renames pathr.td;
         ph: pos_heap renames minr.ph;
         h: heap_space renames minr.h;
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
         ci:= i*2;
         if ci<nh and then td(h(ci+1))<td(h(ci)) then 
            ci:= ci+1; 
         end if;
         while ci<=nh and then td(h(ci)) < dx loop
            h(i):= h(ci);  
            ph(h(i)):= i;
            i:= ci; 
            ci:= i*2;
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
   
end d_graph;
