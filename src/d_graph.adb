with graph_exceptions; use graph_exceptions;
with p_priority_queue;
package body d_graph is

   -- Creates empty graph
   procedure empty (g: out graph) is
   begin
      for I in vertex'Range loop
         g(I):=null; -- Set each cell in the array to null
      end loop;
   end empty;
   
   -- Puts an edge connecting two vertices given a distance
   procedure put_edge (g: in out graph; x,y: in vertex; d: in distance) is 
      p: pcell;
      found: Boolean := False;
   begin
      p:= g(x);
      -- x -> y
      while p/=null and not found loop -- While not end of list
         if p.x=y then
            found:= true;
         else
            p:= p.next;
         end if;
      end loop;
      if not found then
         --p.x:=y; p.d:= d; p.next:=null;
         null;
      else
         raise already_exists;
      end if;
      found:= false;
      p:= g(y);
      -- y -> x
      while p/=null and not found loop -- While not end of list
         if p.x=y then
            found:= true;
         else
            p:= p.next;
         end if;
      end loop;
      if not found then
         --p.x:=x; p.d:= d; p.next:=null;
         null;
      else
         raise already_exists;
      end if;
   end put_edge;
   
   -- Removes an edge connecting two vertices.
   procedure remove_edge (g: in out graph; x,y: in vertex) is
      curr, prev: pcell; -- Current and previous cells to iterate through lists
   begin
      if g(x)=null or g(y)=null then raise does_not_exist; end if;
      curr:= g(x);
      prev:= null;
      -- x -> y
      while curr/=null loop -- While not end of list
         if curr.x/=y then          -- If vertex was not found
            prev:= curr;               -- We iterate through the list.
            curr:= curr.next;
         else                       -- If vertex was found
            curr.d:= infty;         -- Distance is set to infinity for good
                                    -- measure.
            if prev = null then        -- if it was the first one, the array g
               g(x) := curr.next;      -- is updated directly.
            else
               prev.next := curr.next; -- Otherwise, the list is updated.
            end if;
         end if;
      end loop;
      -- y -> x
      curr:= g(y);
      prev:= null;
      while curr/=null loop -- While not end of list
         if curr.x/=y then          -- If vertex was not found
            prev:= curr;               -- We iterate through the list.
            curr:= curr.next;
         else                       -- If vertex was found
            curr.d:= infty;         -- Distance is set to infinity for good
                                    -- measure.
            if prev = null then        -- if it was the first one, the array g
               g(y) := curr.next;      -- is updated directly.
            else
               prev.next := curr.next; -- Otherwise, the list is updated.
            end if;
         end if;
      end loop;
   end remove_edge;
   
   -- Gets the distance between two vertices
   function get_distance (g: in graph; x,y : in vertex) return distance is
      aux: pcell;
      d: distance := infty;   -- If it stays as infinity, edge does not exist
   begin
      if g(x)=null or g(y)=null then raise does_not_exist; end if;
      aux:= g(x);
      while aux /= null loop  -- We iterate through the list of edges
         if aux.x /= y then
            aux:= aux.next;
         else
            d:= aux.d;
         end if;
      end loop;
      if d = infty then raise does_not_exist; end if;
      return d;
   end get_distance;   
   
   -- Returns first not null vertex connected to a given vertex.
   procedure first (g: in graph; x: in vertex; it: out iterator) is
      p: pcell renames it.p;
   begin
      if g(x)=null then raise bad_use; end if;
      p:= g(x).next;
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
   
--     -- Calculates the shortest path from v0 to v in a given graph.
--     procedure shortest_path(g: in graph; v0, v: in vertex; p: out path) is
--        
--        -- VD is formed by a vertex and its shortest distance to v0 found.
--        -- It will be used to store each of the vertices which have not yet been  
--        -- visited in the heap.
--        type VD is record
--           v: vertex;
--           d: distance;
--        end record;
--        
--        function lesser(x1,x2: in SD) 
--        
--        package heap is new p_priority_queue(size => ,
--                                             item => ,
--                                             "<"  => ,
--                                             ">"  => ); use heap;
--        
--        
--     begin
--        null;
--     end shortest_path;
   
end d_graph;
