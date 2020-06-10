generic

   size_vertices: Positive;

package d_graph is

   type vertex is new Positive range 1 .. size_vertices;
   type graph is limited private;
   type iterator is private;
   type distance is new float range 0.0 .. float'last;
   nv: constant positive:= size_vertices;
   infty: constant distance:= distance'last; -- si no existe la arista devolverá infty
   
   procedure empty (g: out graph);
   procedure put_edge (g: in out graph; x,y: in vertex; d: in distance);
   procedure remove_edge (g: in out graph; x,y: in vertex);
   function get_distance (g: in graph; x,y: in vertex) return distance;
   
   procedure first (g: in graph; x: in vertex; it: out iterator);
   procedure next (g: in graph; it: in out iterator);
   function is_valid(it: in iterator) return boolean;
   procedure get (g: in graph; it: in iterator;  y: out vertex);
   procedure get (g: in graph; it: in iterator;  y: out vertex;  d: out distance);
      
   type single_s_path_register is limited private;
   
   type path_array is array (1..nv) of vertex;
   type path is record
      length: distance;
      steps: natural;
      p: path_array;
   end record;
   
   procedure shortest_paths_sparse(g: in graph; v0: in vertex; pthr: out single_s_path_register);
   procedure get_path(pthr: in single_s_path_register; x: in vertex; pth: out path);
   procedure print_path(pth: in path);
   function get_length(pth: in path) return distance;
      
   package d_min_register is
      type min_register is limited private;
      
      space_overflow: exception;
      bad_use: exception;
      
      procedure empty(minr: out min_register; pathr: out single_s_path_register);
      procedure put(minr: in out min_register; pathr: in out single_s_path_register;
                    x, predx: in vertex; dx: in distance);
      procedure delete_min(minr: in out min_register; pathr: in single_s_path_register);
      function get_min(minr: in min_register) return vertex;
      function is_empty(minr: in min_register) return boolean;
            
   private
      
      type heap_space is array(1..nv) of vertex;
      type pos_heap is array (vertex) of natural;
      type min_register is record
         nh: natural;
         h: heap_space;
         ph: pos_heap;
      end record;
      
   end d_min_register;
   
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
   
   type dist_table is array (vertex) of distance;
   type pred_table is array (vertex) of vertex;
   type single_s_path_register is record
      td: dist_table;
      tp: pred_table;
   end record;
   
end d_graph;
