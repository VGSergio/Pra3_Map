with graph_exceptions; use graph_exceptions;
package body d_graph is

   procedure empty (g: out graph) is
   begin
      g:= new graph;
      for I in vertex'Range loop
         g(I).all:=(I, infty, null);
      end loop;
   end empty;
   
   procedure put_edge (g: in out graph; x,y: in vertex; d: in distance) is 
      p, p1: pcell;
      found: Boolean := False;
   begin
      p:= new cell;
      p1:= new cell;
      p.all:=(y, d, null);
      while not found and g(x).next/=null loop
         p1:= g(x).next;
         found:= p1.x=y;
      end loop;
      if not found then
         p1.next:= p;
      else
         raise already_exists;
      end if;
      p.x:=(x);
      found:= False;
      while not found and g(y).next/=null loop
         p1:= g(y).next;
         found:= p1.x=x;
      end loop;
      if not found then
         p1.next:= p;
      else
         raise already_exists;
      end if;
   end put_edge;
   
   procedure remove_edge (g: in out graph; x,y: in vertex) is
      
   begin
      --if g(x)=null or g(y)=null then raise does_not_exist; end if;
      --while not g(x).next=null loop
      --   if g(x).x=y then g(x).x=null; end if;
      --end loop;
      --while not g(Y).next=null loop
      --   if g(y).x=x then g(y).x=null; end if;
      --end loop;
      null;
   end remove_edge;
   
   function get_distance (g: in graph; x,y : in vertex) return distance is
   begin
      --if g(x)=null or g(y)=null then raise does_not_exist; end if;
      --while not g(x).next=null loop
      --   if g(x).x=y then 
      --      return g(x).d; 
      --   end if;
      --end loop;
      --raise does_not_exist;
      return 0.0;
   end get_distance;   
   

   procedure first (g: in  graph; x: in vertex; it: out iterator) is
   begin
      null;
   end first;
   
   procedure next (g: in graph; it: in out iterator) is
   begin
      null;
   end next;
   
   function is_valid(it: in iterator) return boolean is
   begin
      return True;
   end is_valid;
   
   procedure get (g: in graph; it: in iterator;  y: out vertex) is 
   begin
      null;
   end get;

   procedure get (g: in graph; it: in iterator;  y: out vertex;  d: out distance) is 
   begin
      null;
   end get;
   
end d_graph;
