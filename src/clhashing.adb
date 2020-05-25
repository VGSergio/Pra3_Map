package body clhashing is

   procedure cvacio (s: out conjunto) is
      d: dispersion_table renames s.dt;
      ne: Natural renames s.ne;
   begin
      for i in 0..b-1 loop
         d(i).st:= libre;
      end loop;
      ne:=0;
   end cvacio;

   procedure poner (s: in out conjunto; k: in key; x: in item) is
      d: dispersion_table renames s.dt;
      ne: natural renames s.ne;
      i0, i: natural; -- posicion inicial y actual
      na: natural; -- número de intentos
   begin
      i0:= hash(k, b);
      i:= i0;
      na:= 0;
      while d(i).st=usada and then d(i).k/=k loop
         na:= na+1;
         i:= (i0+na*na) mod b;
      end loop;
      if d(i).st=used then
         raise ya_existe;
      end if;
      if ne=max ne then
         raise espacio_desbordado;
      end if;
      d(i).st:= usada; -- marcar celda como utilizada
      d(i).k:= k; d(i).x:= x; -- rellenar celdan
      e:= ne+1; -- contar celda   
   end poner;
   
   procedure consultar (s: in conjunto; k: in key; x: out item) is
      d: dispersion_table renames s.dt;
      i0, i: natural; -- posición inicial y actual
      na: natural; -- número de intentos
   begin
      i0:= hash(k, b); i:= i0; na:= 0;
      while d(i).st=usada and then d(i).k/=k loop
         na:= na+1;
         i:= (i0+na*na) mod b;
      end loop;
      if d(i).st=libre then
         raise no_existe;
      end if;
      x:= d(i).x; -- d(i).x:= x; para el actualizar
   end consultar; 
   
   --borrar no hecho
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
   begin
      i:= 0;
      while i < b and then dt(i).st=free loop
         i:= i+1;
      end loop;
   end primero;
   
   procedure siguiente (s: in conjunto; it: in out iterador) is
      dt: dispersion_table renames s.dt;
      i: natural renames it.i;
   begin
      if i=b then
         raise bad_use;
      end if;
      i:= i+1;
      while i < b and then dt(i).st=free loop
         i:= i+1;
      end loop;
   end siguiente;  
   
   function es_valido (it: in iterador) return boolean is
      i: natural renames it.i;
   begin
      return i<b;
   end es_valido;
   
   procedure obtener (s: in conjunto; it: in iterador; k: out key; x: out item) is
      dt: dispersion_table renames s.dt;
      i: natural renames it.i;
   begin
      if i=b then
         raise bad_use;
      end if;
      k:=dt(i).k;
      x:= dt(i).x;
   end obtener;

end clhashing;
