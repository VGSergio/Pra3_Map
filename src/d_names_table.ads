package d_names_table is

   type names_table is limited private;
   
   procedure empty(tn: out names_table);
   procedure put(tn: in out names_table; name: in string; id: out name_id);
   function consult(tn: in names_table; id: in name_id) return string;
   
   --  procedure save_name (name: in string; tc: in out characters_table; nc: in out natural);
   function equal (name: in string; tn: in names_table; p: in name_id) return boolean;
   
private
   
   b: constant Ada.Containers.Hash_Type:= Ada.Containers.Hash_Type(max_id);
   subtype hash_index is Ada.Containers.Hash_Type range 0..b;
   type list_item is record
      psh: name_id; -- puntero sucesor sinónimo, name_id : range 0..max_id;
      ptc: natural; -- puntero a la tabla de carácteres
   end record;
   type id_table is array(name_id) of list_item;
   type disp_table is array(hash_index) of name_id;
   --  subtype characters_table is string(1..max_ch);
   type names_table is record
      td: disp_table;
      tid: id_table;
      nid: name_id; -- número de identificadores asignados
      nc: natural; -- número carácteres almacenados
   end record;

end d_names_table;
