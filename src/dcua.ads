generic
   
   type elem is private;

package dcua is

   type cola is limited private;
   
   mal_uso: exception;
   espacio_desbordado: exception;
   
   procedure cvacia (qu: out cola);
   procedure poner (qu: in out cola; x: in elem);
   procedure borrar_primero(qu: in out cola);
   function coger_primero (qu: in cola) return elem;
   function esta_vacia(qu: in cola) return boolean;
   
private
   
   type nodo;
   type pnodo is access nodo;
   type nodo is record
      x: elem;
      sig: pnodo;
   end record;
   type cola is record 
      p, q: pnodo; 
   end record;
      
end dcua;
