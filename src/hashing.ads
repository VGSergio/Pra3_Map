generic
   
   type key is private;
   type item is private;
   with function hash (k: in key; b: in Positive) return Natural;
   size: Positive; --número primo
   with function "=" (k1: in key; k2: in key) return  boolean;

package hashing is

   type conjunto is limited private;
   type iterador is limited private;
   
   ya_existe: exception;
   no_existe: exception;
   espacio_desbordado: exception;
   mal_uso: exception;
   
   procedure cvacio (s: out conjunto);
   procedure poner (s: in out conjunto; k: in key; x: in item);
   procedure consultar (s: in conjunto; k: in key; x: out item);
   procedure borrar (s: in out conjunto; k: in key);
   --procedure actualiza (s: in out conjunto; k: in key; x: in item);

   procedure primero (s: in conjunto; it: out iterador);
   procedure siguiente (s: in conjunto; it: in out iterador);
   function es_valido (it: in iterador) return boolean;
   procedure obtener (s: in conjunto; it: in iterador; k: out key; x:out item);

private

   b: constant natural := size;
   type nodo;
   type pnodo is access nodo;
   type nodo is record
      k: key;
      x: item;
      sig: pnodo;
   end record;
   type dispersion_table is array (Natural range 0..b-1) of pnodo;
   type conjunto is record
      dt: dispersion_table;
   end record;
   type iterador is record
      i: Natural; --posición en tabla dispersión
      p: pnodo;   --puntero al nodo
   end record;
   
end hashing;
