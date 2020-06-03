with graph_exceptions;
package body d_graph is

   procedure empty (g: out graph) is
   begin
      g(1).all:=(1, infty, null);
   end empty;
   
   procedure put_edge (g: in out graph; x,y: in vertex; d: in distance) is 
      p: pcell;
   begin
      p:= new cell;
      p.all:=(y, d, null);
      g(x):=p;
      p.x:=(x);
      g(y):=p:
   end put_edge;
   
   procedure remove_edge (g: in out graph; x,y: in vertex) is
      
   begin
      null;
   end remove_edge;
   
   function get_distance (g: in graph; x,y : in vertex) return distance is
   begin
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
