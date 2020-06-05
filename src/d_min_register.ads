package d_min_register is

   type min_register is limited private;
   
   type single_s_path_register is limited private;
   
   space_overflow: exception;
   bad_use: exception;
   
   procedure empty(minr: out min_register; pathr: out single_s_path_register);
   procedure put(minr: out min_register);
   
   
private
   
   type heap_space is array (1 .. nv) of vertex;
   type pos_heap is array(vertex) of natural;
   type min_register is record
      nh: natural;
      h: heap_space;
      ph: pos_heap;
   end record;
   
   
   type dist_table is record
      null;
   end record;
   type pred_table is array (vertex) of vertex;
   type single_s_path_register is record
      td: dist_table;
      tp: pred_table;
   end record;
                 
end d_min_register;
