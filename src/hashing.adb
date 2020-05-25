package body hashing is

   procedure cvacio (s: out conjunto) is
       dt: dispersion_table renames s.dt;
   begin
      for i in 0..b-1 loop
         dt(i):= null;
      end loop;
   end cvacio;

   procedure poner (s: in out conjunto; k: in key; x: in item) is
      dt: dispersion_table renames s.dt;
      i: Natural;
      p: pnodo;
   begin
      i:=hash(k, b); p:=dt(i);
      --recorrer la lista, que sea diferente de null y
      --no encontrar la clave
      while p/=null and then p.k/=k loop
         p:=p.sig;
      end loop;
      if p/=null then
         raise ya_existe;
      end if;
      p:= new node;            -- crear celda
      p.all:=(k, x, null);     -- llenar celda
      p.sig:=dt(i); dt(i):=p;  -- insertar al principio de la lista
   exception
      when Storage_Error => raise espacio_desbordado;   
   end poner;
   
   procedure consultar (s: in conjunto; k: in key; x: out item) is
      dt: dispersion_table renames s.dt;
      i: natural;
      p: pnodo;
   begin
      i:= hash(k, b); p:= dt(i);
      while p/=null and then p.k/=k loop
         p:= p.sig;
      end loop;
      if p=null then
         raise no_existe;
      end if ;   
      x:= p.x;  -- p.x:= x; para actualizar
   end consultar; 
   
   procedure borrar (s: in out conjunto; k: in key) is
      dt: dispersion_table renames s.dt;
      i: natural;
      p, pp: pnodo;
   begin
      i:=hash(k, b);
      p:= dt(i);
      pp:= null;
      while p/=null and then p.k/=k loop
         pp:= p;
         p:= p.sig;
      end loop;
      if p=null then
         raise no_existe;
      end if;
      if pp=null then
         dt(i) := p.sig; --principio lista
      else 
         pp.sig := p.sig;
      end if ;
   end borrar;
   
   --procedure actualiza (s:in out conjunto; k: in key; x: in item) is begin end actualiza;

   
   --iterador
   procedure primero (s: in conjunto; it: out iterador) is
      dt: dispersion_table renames s.dt;
      i: natural renames it.i;
      p: pnodo renames it.p;
   begin
      --busca primer elemento no nulo
      i:= 0;
      while i<b-1 and dt(i)=null loop
         i:= i+1;
      end loop;
      p:= dt(i);
   end primero;
   
   procedure siguiente (s: in conjunto; it: in out iterador) is
      dt: dispersion_table renames s.dt;
      i: natural renames it.i;
      p: pnodo renames it.p;
   begin
      if p=null then
         raise bad_use;
      end if;
      p:= p.next; --si está dentro de lista enlazada
      if p=null and i<b-1 then --sino, siguiente posición de la td
         i:= i+1;
         while i<b-1 and dt(i)=null loop
            i:= i+1;
         end loop;
         p:= dt(i);
      end if;
   end siguiente;  
   
   function es_valido (it: in iterador) return boolean is
      p: pnodo renames it.p;
   begin
      return p/=null;
   end es_valido;
   
   procedure obtener (s: in conjunto; it: in iterador; k: out key; x: out item) is
      p: pnodo renames it.p;
   begin
      k:= p.k;
      x:= p.x;
   end obtener;
   
end hashing;
