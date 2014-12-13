program system_lindenmayera;
{ustalam za maksymalna ilosc znakow w linijce kodu 80 oraz tabulacje na 2 znaki}
const
	MAX_LICZBA_ZNAKOW=100001;
	{maksymalna liczba znakow w wyprowadzeniu}
	MAX_LICZBA_WIERSZY_WEJSCIA=257;
	{zakladam 256 jako maksymalna ilosci wierszy na wejsciu dla regul i
	interpretacji poniewaz tyle znakow jest w kodzie ASCII}
type
	Ciag_znakow = array [1..MAX_LICZBA_ZNAKOW] of Char;
	{wlasny typ przechowujacy slowo podczas wyprowadzania}
	Typ_wejscia = array [1..MAX_LICZBA_WIERSZY_WEJSCIA] of String; 
	{tab slow z wejscia oraz interpretacji}
	Typ_wejscia_znak = array [1..MAX_LICZBA_WIERSZY_WEJSCIA] of Char; 
	{tab pierwszych znakow interpretacji}
var
	it_wiersza_interpretacji,it_wiersza_wejscia:LongInt;
	it_pomoc1,it_wiersza,wsk_znaku,licznik:LongInt;
	it_pomoc,dlugosc_wyprowadzenia:LongInt;
	{dlugosc_wyprowadzenia - liczba podawana na wejsciu oznaczajaca ilosc krokow
	wyprowadzania od 0 do konca, it_wiersza_* - wskazuje na dany wiersz w
	interpretacji/wejsciu, it_wiersza,it_pomoc,it_pomoc1- iteratory,
	wsk_znaku-wskazuje na dany znak w ciagu znakow,
	licznik-iterator petli dlugosci wyprowadzania slowa}
	dl_wiersza:Integer;
	{przechowujemy w tej zmiennej dlugosc interpretacji dla znaku}
	slowo_pomoc:Typ_wejscia;
	{slowo_pomocnicze-przechowuje ciag znakow interpretacji litery}
	stop:Boolean;
	{stop-zmienna potrzebna do wyjscia z petli while we wlasciwym miejscu}
	znak_pomoc:Typ_wejscia_znak;
	{znak_pomoc-tablica przechowujaca pierwsze znaki interpretacji}
	wiersz_wejscia,tab_interpretacji:Typ_wejscia; 
	{wiersz_wejscia-tablica przechowujaca wiersze wejscia,
	tab_interpretacji - przechowujemy interpretacje w tej tablicy}
	wiersz_logu:String; 
	{poniewaz nie ma potrzeby zapamietywania wierszy prologu i epilogu
	starczy nam jeden string}
	wyp_slowo,kopia_wyp_slowo:Ciag_znakow; 
	{kopia_*,*- tu przechowujemy wyprowadzane slowo}


procedure wczytanie_wejscia; 
begin
	readln(dlugosc_wyprowadzenia); 
	it_wiersza_wejscia:=1;
	{wczytujemy po kolei wiersze przy czym pierwszy to aksjomat}
	readln(wiersz_wejscia[it_wiersza_wejscia]);
	it_wiersza_wejscia:=it_wiersza_wejscia+1;
	repeat
	begin
		readln(wiersz_wejscia[it_wiersza_wejscia]);
		it_wiersza_wejscia:=it_wiersza_wejscia+1;
	end
	until(length(wiersz_wejscia[it_wiersza_wejscia-1])=0);
	it_wiersza_wejscia:=it_wiersza_wejscia-1;
	{poniewaz n-1 wiersz jest pusty a kolejny nie wczytany}
end;	

procedure wczytaj_i_wypisz_prolog_lub_epilog;
begin
	repeat 
	begin 
		readln(wiersz_logu);
		if(length(wiersz_logu)>0) then writeln(wiersz_logu);
		{jesli wiersz nie jest pusty to go wypisujemy od razu}
	end until (length(wiersz_logu)=0);
end;

procedure wczytanie_interpretacji; 
begin
	it_wiersza_interpretacji:=1;
	repeat
	begin
		readln(tab_interpretacji[it_wiersza_interpretacji]);
		it_wiersza_interpretacji:=it_wiersza_interpretacji+1;
	end until (length(tab_interpretacji[it_wiersza_interpretacji-1])=0);
	it_wiersza_interpretacji:=it_wiersza_interpretacji-1;
	{poniewaz n-1 wiersz jest pusty a kolejny nie wczytany}
end;

procedure wyprowadz_slowo; 
begin
	
	for it_pomoc:=1 to length(wiersz_wejscia[1]) do
	{wczytujemy aksjomat}
	begin
		wyp_slowo[it_pomoc]:=wiersz_wejscia[1][it_pomoc];	
	end;
	for licznik:=1 to dlugosc_wyprowadzenia do
	{teraz wyprowadzamy slowo}
	begin
		wsk_znaku:=1;
		it_pomoc:=1;
		stop:=false;
		while(wyp_slowo[it_pomoc]<>#0) do
		begin
			stop:=false;
			it_wiersza:=2;	
			while((it_wiersza<=it_wiersza_wejscia)and (not stop)) do
			begin
				if(wyp_slowo[it_pomoc]=wiersz_wejscia[it_wiersza][1]) then
				begin
					stop:=true;
					for it_pomoc1:=2 to length(wiersz_wejscia[it_wiersza]) do 
					{przypisujemy kopia_wyp_slowo znaki wyprowadzone z regul}
					begin
						kopia_wyp_slowo[wsk_znaku]:=wiersz_wejscia[it_wiersza][it_pomoc1];
						wsk_znaku:=wsk_znaku+1;
					end;
				end
				else
				begin 
					it_wiersza:=it_wiersza+1;
				end;
			end;

			if(not stop) then
			{jesli dla znaku nie ma reguly to zostawiamy go w swojej kolejnosci}
			begin
				kopia_wyp_slowo[wsk_znaku]:=wyp_slowo[it_pomoc];
				wsk_znaku:=wsk_znaku+1;
			end;
			it_pomoc:=it_pomoc+1;
		end;
		it_pomoc:=1;
		it_pomoc1:=1;
		if(kopia_wyp_slowo[it_pomoc]=#0)then wyp_slowo[it_pomoc]:=#0
		else
		begin
			while(wyp_slowo[it_pomoc1]<>#0) do {czyscimy wyp slowo}
			begin
				wyp_slowo[it_pomoc1]:=#0;
				it_pomoc1:=it_pomoc1+1;
			end;
			while(kopia_wyp_slowo[it_pomoc]<>#0) do 
			{wyprowadzane slowo staje sie slowem ktore powstalo z zastosowanych regul}
			begin
				wyp_slowo[it_pomoc]:=kopia_wyp_slowo[it_pomoc];
				kopia_wyp_slowo[it_pomoc]:=#0; {czyscimy kopie}
				it_pomoc:=it_pomoc+1;
			end;
		end;
	end;
end;

procedure stworz_interpretacje;
begin
	for it_wiersza:=1 to it_wiersza_interpretacji-1 do
	begin
		znak_pomoc[it_wiersza]:=tab_interpretacji[it_wiersza][1];
		{tutaj wczytujemy znak poczatkowy interpretacji}
		dl_wiersza:=length(tab_interpretacji[it_wiersza])-1;
		slowo_pomoc[it_wiersza]:=Copy(tab_interpretacji[it_wiersza],2,dl_wiersza);
		{a tutaj interpretacje tego znaku}
	end;
end;

procedure interpretuj_slowo;
begin
	it_pomoc:=1;
	while(wyp_slowo[it_pomoc]<>#0) do
	begin
		it_pomoc1:=1; 
		{zaczynamy od pierwszego wiersza interpretacji}
		stop:=false;
		while((it_pomoc1<it_wiersza_interpretacji)and(not stop)) do 
		{jesli istnieje interpretacja dla znaku}
		begin
			if(wyp_slowo[it_pomoc]=znak_pomoc[it_pomoc1]) then
			begin
				stop:=true;
				writeln(slowo_pomoc[it_pomoc1]);
				{wypisujemy interpretacje dla tego znaku i wychodzimy z petli}
			end
			else
			it_pomoc1:=it_pomoc1+1;
		end;
		it_pomoc:=it_pomoc+1;
	end;
end;

{poczatek glownego programu}
begin
	wczytanie_wejscia;
	{dlugosc wyprowadzenia, aksjomat oraz reguly}
	wczytaj_i_wypisz_prolog_lub_epilog;
	{prolog}
	wczytanie_interpretacji;
	wyprowadz_slowo;
	stworz_interpretacje;
	interpretuj_slowo;
	wczytaj_i_wypisz_prolog_lub_epilog;
	{epilog}

end.
