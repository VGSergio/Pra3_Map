generic

   size_vertices: Positive;

package d_graph is

   type vertex is new positive range 1 .. size_vertices;
   type graph is limited private;
   type iterator is private;
   type distance is new float range 0.0 .. float'last;
   nv: constant positive:= size_vertices;
   infty: constant distance:= distance'last; -- si no existe la arista devolverá infty
   
   procedure empty (g: out graph);
   procedure put_edge (g: in out graph; x,y: in vertex; d: in distance);
   procedure remove_edge (g: in out graph; x,y: in vertex);
   function get_distance (g: in graph; x,y: in vertex) return distance;
   
   procedure first (g: in  graph; x: in vertex; it: out iterator);
   procedure next (g: in graph; it: in out iterator);
   function is_valid(it: in iterator) return boolean;
   procedure get (g: in graph; it: in iterator;  y: out vertex);
   procedure get (g: in graph; it: in iterator;  y: out vertex;  d: out distance);
   
--     type path is array (Natural range <>) of vertex;
--     
--     procedure shortest_path(g: in graph; v0, v: in vertex; p: out path);
   
private
   
   type cell;
   type pcell is access cell;
   type cell is record
      x: vertex;
      d: distance;
      next : pcell;
   end record;
   type graph is array (vertex) of pcell;
   type iterator is record
      p : pcell;
   end record;
   
end d_graph;
