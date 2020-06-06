package general_defs is

   --m�ximo n�mero de identificadores
   max_id: constant integer:= 67 ;
   --m�ximo n�mero de caracteres entre todos los nombres
   max_ch: constant integer:= 67*30 ;
   type name_id is new integer range 0..max_id;
   null_id: constant name_id:= 0;

end general_defs;
