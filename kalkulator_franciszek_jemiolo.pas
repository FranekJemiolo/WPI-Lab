program kalkulator;
{ustalam 80 za maksymalna ilosc znakow w wierszu i tabulacje na 2 znaki				 }
const
  il_wiersz = 50;
  {ilosc wierszy w bloku pamieci                                               }
  il_kol = 16;
  {ilosc kolumn w bloku pamieci                                                }
  podstawa = 1000;
  {podstawa systemu liczbowego na ktorym operuje kalkulator                    }

type
  blok_pam = Array [0..il_wiersz,1..il_kol] of LongInt;
  {blok pamieci kalkulatora, w 0 wierszu sa adresy poczatkowe dla zmiennych    }
  blok_zm = Array [1..il_wiersz] of Char;
  {blok w ktorym przechowujemy jaka zmienna jest zapisana w ktorym wierszu     }
  blok_kol = Array['a'..'p',1..il_wiersz] of 0..il_wiersz;
  {blok w ktorym zapamietujemy kolejnosc zapisu zmiennej w pamieci             }
var
  pamiec:blok_pam;
  {tutaj jest nasz blok pamieci kalkulatora                                    }
  pam_zm:blok_zm;
  {tutaj pamietamy ktora zmienna gdzie jest zapisana                           }
  kol_zm:blok_kol;
  {tutaj kolejnosc zapisu zmiennej w poszczegolnych blokach                    }


function chr_int(znak:Char):LongInt;
{funkcja zamieniajaca liczbe w char na liczbe w LongIntze                      }
begin
  chr_int:=Ord(znak)-48;
end;


procedure wyczysc_pam;
{w tej procedurze czyscimy blok pamieci i blok zmiennych oraz blok kolejnosci  }
var
  it_w,it_k,it_z:LongInt;
  {iteratory wierszy i kolumn oraz znakow                                      }
begin
  for it_w:=0 to il_wiersz do
  begin
    for it_k:=1 to il_kol do
    begin
			{tu czyscimy blok pamieci																								 }
      pamiec[it_w,it_k]:=0;
    end;
  end;
  for it_w:=1 to il_wiersz do
  begin
		{tu czyscimy przypisanie wierszow do zmiennych														 }
    pam_zm[it_w]:=#0;
  end;
  for it_z:=Ord('a') to Ord('p') do
  begin
    for it_w:=1 to il_wiersz do
    begin
			{a tu czyscimy kolejnosc zapisu dla kazdej zmiennej											 }
      kol_zm[Chr(it_z),it_w]:=0;
    end;
  end;
end;


procedure wypisz_pam;
{procedura wypisujaca aktualny caly blok pamieci                               }
var
  it_w,it_k,it_b,ile_wb:LongInt;
  {it_w-iterator wiersza bloku pamieci,it_k-iterator kolumny, it_b-iterator w  }
  {pojedynczym bloku ile_wb-ile komorek jest zajetych w pojedynczym bloku      }
begin
  for it_w:=0 to il_wiersz do
  begin
		if(it_w<10)then
		begin
			write(' ',it_w,':');
		end
		else
		begin    
			write(it_w,':');
		end;
    for it_k:=1 to il_kol do
    begin
      if(pamiec[it_w,it_k]>99)then ile_wb:=3
      else if(pamiec[it_w,it_k]>9)then ile_wb:=2
      else ile_wb:=1;
      for it_b:=3 downto ile_Wb do
      {wypisujemy spacje                                                       }
      begin
        write(' ');
      end;
      {a teraz liczbe w komorce                                                }
      write(pamiec[it_w,it_k]);
    end;
    writeln;
  end;
end;


procedure wypisz_zm(zm:Char);
{procedura wypisujaca dana zmienna																						 }
var
  ind_w,ind_k:LongInt;
  {ind_w- indeks wiersza, w ktorym zapisana jest zmienna, ind_k-indeks kolumny }
begin
  ind_w:=1;
  if(kol_zm[zm,ind_w]=0)then
	{jesli zmienna jest pusta																										 }
  begin
  write(0);
  end
	else
	begin
  while(kol_zm[zm,ind_w]<>0)do
  {idziemy do ostatniego wiersza                                               }
  begin
    inc(ind_w);
  end;
  ind_w:=ind_w-1;
  ind_k:=il_kol-1;
  while(pamiec[kol_zm[zm,ind_w],ind_k]=0)and(ind_k>1)do
  begin
    ind_k:=ind_k-1;
  end;
	write(pamiec[kol_zm[zm,ind_w],ind_k]);
	ind_k:=ind_k-1;
	{poniewaz pierwsze cyfry sa bez prefiksow (0)																 }
  while(ind_w>0)do
  begin
    while(ind_k>0)do
    begin
      if(pamiec[kol_zm[zm,ind_w],ind_k]>99)then
      {jesli liczba ma wiecej niz 2 cyfry                                      }
      begin
        write(pamiec[kol_zm[zm,ind_w],ind_k]);
      end
      else if(pamiec[kol_zm[zm,ind_w],ind_k]>9)then
      {jesli liczba ma 2 cyfry                                                 }
      begin
        write(0,pamiec[kol_zm[zm,ind_w],ind_k]);
      end
			else
      begin
        write(0,0,pamiec[kol_zm[zm,ind_w],ind_k]);
      end;
      ind_k:=ind_k-1;
    end;
    {startujemy od ostatniej kolumny i nizszego wiersza                        }
    ind_k:=il_kol-1;
    ind_w:=ind_w-1;
  end;
	end;
  writeln;
end;


procedure wyczysc_zm(zm:Char);
{procedura w ktorej, zerujemy przypisanie zmiennej                             }
var
  it_w:LongInt;
begin
  pamiec[0,Ord(zm)-96]:=0;
  {czyscimy wiersz zerowy bloku pamieci                                        }
  for it_w:=1 to il_wiersz do
  begin
    if(pam_zm[it_w]=zm)then
    begin
      {zerujemy przypisanie wierszy                                            }
      pam_zm[it_w]:=#0;
    end;
		kol_zm[zm,it_w]:=0;
  end;
end;


procedure wyczysc_wiersz(wiersz:LongInt);
{w tej procedurze zerujemy wiersz                                              }
var
  it_k:LongInt;
  {iterator kolumny                                                            }
begin
  for it_k:=1 to il_kol do
  begin
    pamiec[wiersz,it_k]:=0;
  end;
end;


procedure dodaj_jeden(zm:Char);
{procedura w ktorej dodajemy do zmiennej jeden																 }
var
  it_w,it_w_pom,it_w1:LongInt;
  {iteratory w pętlach                                                         }
  liczba_pom,liczba_pom1,reszta:LongInt;
  {liczba w ktorej przechowujemy dzialania na pojedynczych komorkach           }
	
procedure dodaj(i_w,i_k:LongInt; var przeszlo:LongInt);
{procedura rekurencyjna dodwania do zmiennej jedynki													 }
begin
	liczba_pom1:=pamiec[kol_zm[zm,i_w],i_k];
	liczba_pom:=(liczba_pom1+przeszlo)mod podstawa;
	pamiec[kol_zm[zm,i_w],i_k]:=liczba_pom;
	{w komorce zostaje reszta z dzielenia																				 }
	przeszlo:=(liczba_pom1+przeszlo)div podstawa;
	if(przeszlo>0)then
	begin
		if(i_k>il_kol-2)and(i_w<il_wiersz)then
		begin
			{jesli doszlismy do ostatniej mozliwej do zapisu kolumny sprawdzamy czy  }
			{musimy przejsc do kolejnego wiersza i gdzie ten wiersz jest						 }
			if(kol_zm[zm,i_w+1]=0)then
			begin
				it_w1:=1;
      	while(it_w1<il_wiersz)and(pam_zm[it_w1]<>#0)do
      	begin
      	 	{szukamy pierwszego wolnego wiersza w bloku pamieci                  }
      	 	inc(it_w1);
     		end;
     		wyczysc_wiersz(it_w1);
     		{poniewaz musimy wyczyscic to co znajduje sie w wolnym bloku           }
     		pamiec[kol_zm[zm,i_w],il_kol]:=it_w1;
				pam_zm[it_w1]:=zm;
     		{zapisujemy adres wiersza                                              }
				kol_zm[zm,i_w+1]:=it_w1;
				dodaj(i_w+1,1,przeszlo);
			end
			else
			{wiemy ze kolejny wiersz zmiennej jest niepusty													 } 
			begin
				dodaj(i_w+1,1,przeszlo);
			end;
		end
		else if(i_k<il_kol-1)then
		{przechodzimy do kolejnej kolumny w tym samym wierszu											 }
		begin
			dodaj(i_w,i_k+1,przeszlo);
		end;
	end
end;

begin
  it_w:=1;
  if(kol_zm[zm,it_w]=0)then
  {musimy przypisac najblizszy wolny wiersz danej liczbie pierwszej            }
  begin
    it_w_pom:=1;
    while(pam_zm[it_w_pom]<>#0)do
    begin
      inc(it_w_pom);
    end;
    wyczysc_wiersz(it_w_pom);
    {poniewaz musimy wyczyscic pamiec zapisana w tym wierszu                   }
    pamiec[0,ord(zm)-96]:=it_w_pom;
		pam_zm[it_w_pom]:=zm;
    kol_zm[zm,it_w]:=it_w_pom;
  end;
	liczba_pom1:=0;
	liczba_pom:=0;
	reszta:=1;
	{poniewaz dodajemy jedynkę																									 }
	dodaj(1,1,reszta);
	{uruchamiamy procedure dodawania dla pierwszego wiersza i kolumny dla liczby }
end;


procedure dodaj_zm(zm1,zm2:Char);
{procedura w ktorej dodajemy dwie zmienne                                      }
var
  it_w,it_w_pom,it_w1:LongInt;
  {iteratory w pętlach                                                         }
  liczba_pom,liczba_pom1,liczba_pom2,reszta:LongInt;
  {liczba w ktorej przechowujemy dzialania na pojedynczych komorkach           }

procedure dodaj(i_w,i_k:LongInt; var przeszlo:LongInt);
{procedura rekurencyjna dodwania dwoch zmiennych															 }
begin
	liczba_pom1:=pamiec[kol_zm[zm1,i_w],i_k];
	if(kol_zm[zm2,i_w]=0)then
	begin
		liczba_pom2:=0
	end
	else
	begin
		liczba_pom2:=pamiec[kol_zm[zm2,i_w],i_k];
	end;
	liczba_pom:=(liczba_pom1+liczba_pom2+przeszlo)mod podstawa;
	pamiec[kol_zm[zm1,i_w],i_k]:=liczba_pom;
	{w komorce zostaje reszta z dzielenia																				 }
	przeszlo:=(liczba_pom1+liczba_pom2+przeszlo)div podstawa;
	if(i_k>il_kol-2)and(i_w<il_wiersz)then
	begin
		{jesli doszlismy do ostatniej mozliwej do zapisu kolumny sprawdzamy czy 	 }
		{musimy przejsc do kolejnego wiersza i gdzie ten wiersz jest							 }
		if(kol_zm[zm1,i_w+1]=0)and((przeszlo>0)or(kol_zm[zm2,i_w+1]<>0))then
		begin
			it_w1:=1;
      while(it_w1<il_wiersz)and(pam_zm[it_w1]<>#0)do
      begin
       	{szukamy pierwszego wolnego wiersza w bloku pamieci                  	 }
       	inc(it_w1);
     	end;
     	wyczysc_wiersz(it_w1);
     	{poniewaz musimy wyczyscic to co znajduje sie w wolnym bloku           	 }
     	pamiec[kol_zm[zm1,i_w],il_kol]:=it_w1;
			pam_zm[it_w1]:=zm1;
     	{zapisujemy adres wiersza                                              	 }
			kol_zm[zm1,i_w+1]:=it_w1;
			dodaj(i_w+1,1,przeszlo)
		end
		else if(kol_zm[zm1,i_w+1]<>0)or(przeszlo>0)then
		begin
			dodaj(i_w+1,1,przeszlo);
		end
		else if(pamiec[kol_zm[zm2,i_w],il_kol]<>0)then
		begin
			dodaj(i_w+1,1,przeszlo);
		end;
	end
	else if(i_k<il_kol-1)then
	begin
		{przechodzimy do kolejnej kolumny w tym samym wierszu											 }
		dodaj(i_w,i_k+1,przeszlo);
	end;
end;

begin
  it_w:=1;
  if(kol_zm[zm1,it_w]=0)and(kol_zm[zm2,it_w]>0)then
  {musimy przypisac najblizszy wolny wiersz danej liczbie pierwszej          	 }
  begin
    it_w_pom:=1;
    while(pam_zm[it_w_pom]<>#0)do
    begin
      inc(it_w_pom);
    end;
    wyczysc_wiersz(it_w_pom);
    {poniewaz musimy wyczyscic pamiec zapisana w tym wierszu                   }
    pamiec[0,ord(zm1)-96]:=it_w_pom;
		pam_zm[it_w_pom]:=zm1;
    kol_zm[zm1,it_w]:=it_w_pom;
  end;
	it_w:=1;
	if(kol_zm[zm2,it_w]<>0)then
	begin
		liczba_pom1:=0;
		liczba_pom2:=0;
		liczba_pom:=0;
		reszta:=0;
		{uruchamiamy procedura dodawania dla pierwszej kolumny i pierwszego wiersza}
		dodaj(1,1,reszta);
	end;
	
end;


procedure instrukcja(wejscie:String);
var
  it_znak,it_znak_p,it_znak_p1,it_pow,il_nawl,il_nawp:LongInt;
  {it_znak -iterator w wierszu wejscia, it_pow-iterator powtorzen instrukcji   }
  {il_nawl-ilosc nawiasow (, il_nawp- ilosc nawiasow )                         }
  licz_pow,dl_wiersza:LongInt;
  {liczba powtorzen instrukcji, dl_wiersza-przechowujemy w niej dlugosc wejscia}
begin
  it_znak:=1;
	dl_wiersza:=length(wejscie);
  while(it_znak<=dl_wiersza) do
  begin
    if(wejscie[it_znak]='#')then
    {wypisujemy pamiec                                                         }
    begin
      wypisz_pam;
      inc(it_znak);
    end
    else if(wejscie[it_znak]='@')then
    {wypisujemy zmienna                                                        }
    begin
      wypisz_zm(wejscie[it_znak+1]);
      it_znak:=it_znak+2;
    end
    else if(wejscie[it_znak]='^')then
    {dodajemy do zmiennej 1                                                    }
    begin
      dodaj_jeden(wejscie[it_znak+1]);
      it_znak:=it_znak+2;
    end
    else if(wejscie[it_znak]='\')then
    {czyscimy przypisanie adresow dla zmiennej                                 }
    begin
      wyczysc_zm(wejscie[it_znak+1]);
      it_znak:=it_znak+2;
    end
    else if(Ord(wejscie[it_znak])>47)and(Ord(wejscie[it_znak])<58)then
    {jesli natrafimy na liczbe                                                 }
    begin
      licz_pow:=chr_int(wejscie[it_znak]);
      it_znak_p:=it_znak;
      while(Ord(wejscie[it_znak_p])>47)and(Ord(wejscie[it_znak_p])<58)do
      begin
        inc(it_znak_p);
      end;
        if(wejscie[it_znak_p]='(')then
        {musimy wykonac dzialanie nawiasowe                                    }
        begin
          il_nawl:=1;
          il_nawp:=0;
          it_znak_p1:=it_znak_p+1;
          while(il_nawl>il_nawp)do
          {wiemy ze dopoki nie ma tylu samu nawiasow ( co ) to znaczy ze       }
          {wszystko jest instrukcja w tym obszarze pomiedzy                    }
          begin
            if(wejscie[it_znak_p1]='(')then
            begin
              inc(il_nawl);
            end
            else if(wejscie[it_znak_p1]=')')then
            begin
              inc(il_nawp);
            end;
            inc(it_znak_p1);
          end;
          it_znak_p1:=it_znak_p1-1;
					for it_pow:=1 to licz_pow do
      		begin
          	instrukcja(Copy(wejscie,it_znak+1,it_znak_p1-it_znak));
					end;
        end
        else if(wejscie[it_znak_p]='#')then
        {jest to jedyne dzialanie skladajace sie z jednego znaku            	 }
        begin
					for it_pow:=1 to licz_pow do
      		begin
          	instrukcja(Copy(wejscie,it_znak+1,it_znak_p-it_znak));
					end;
        end
        else
        begin
          {wiemy ze instrukcja sklada sie z dwoch znakow                    	 }
					for it_pow:=1 to licz_pow do
      		begin
          	instrukcja(Copy(wejscie,it_znak+1,it_znak_p+1-it_znak));
					end;
        end;
			{musimy teraz przeskoczyc it_znak za wykonana instrukcje								 }
			if(wejscie[it_znak_p]='#')then
			begin
				it_znak:=it_znak_p+1;
			end
			else if(wejscie[it_znak_p]='(')then
			begin
				it_znak:=it_znak_p1+1;
			end
			else
			begin
				it_znak:=it_znak_p+2;
			end;
    end
    else if(wejscie[it_znak]='(')then
    {wyrazenie nawiasowe                                                       }
      begin
        il_nawl:=1;
        il_nawp:=0;
        it_znak_p:=it_znak+1;
        while(il_nawl>il_nawp)do
        {wiemy ze dopoki nie ma tylu samu nawiasow ( co ) to znaczy ze         }
        {wszystko jest instrukcja w tym obszarze pomiedzy                      }
        begin
          if(wejscie[it_znak_p]='(')then
          begin
            inc(il_nawl);
          end
          else if(wejscie[it_znak_p]=')')then
          begin
            inc(il_nawp);
          end;
          inc(it_znak_p);
        end;
        it_znak_p:=it_znak_p-2;
				{wykonujemy instrukcje ktora jest w nawiasie													 }
        instrukcja(Copy(wejscie,it_znak+1,it_znak_p-it_znak));
        it_znak:=it_znak_p+2;
      end
    else if(Ord(wejscie[it_znak])>96)and(Ord(wejscie[it_znak])<113)then
    {dodawanie zmiennych                                                       }
    begin
      dodaj_zm(wejscie[it_znak],wejscie[it_znak+1]);
      it_znak:=it_znak+2;
    end
		else
			{jesli by byla bledna instrukcja przerywamy wykonywanie instrukcji			 }
			break;
  end;
end;


procedure start;
{w tej procedurze wczytujemy polecenia i stosujemy do nich instrukcje					 }
var
  w_wejscia:String;
  {w tej zmiennej przechowujemy wiersz wejscia, mozemy tak zrobic bo nie ma    }
  {potrzeby zapamietywania wszystkich wierszy wejscia                          }
begin
  wyczysc_pam;
  {czyscimy pamiec kalkulatora na poczatku programu                            }
  {zaczynamy od pierwszego wiersza instrukcji                                  }
	readln(w_wejscia);
  while(length(w_wejscia)>0) do
  begin
    instrukcja(w_wejscia);
		readln(w_wejscia);
  end;
end;


begin
	{uruchamiamy kalkulator																											 }
  start;
end.
