program connect6; {Pierwszy program zaliczeniowy laboratorium WPI Franciszek Jemiolo}
const 
  LICZBA_KOLUMN=20; {stala przechowujaca informacje dotyczace ilosci kolumn}
  POCZATKOWA_KOLUMNA=0; {jaki jest indeks pierwszej kolumny}
  POCZATKOWY_WIERSZ=0; {jaki jest indeks pierwszego wiersza}
  LICZBA_WIERSZY=20; {stala przechowujaca informacje dotyczace ilosci wierszy}
  mala_litera_ascii=116; {stala przechowujaca wartosc liczbowa w kodzie ascii litery t jako ze ta jest pierwsza po s}
  duza_litera_ascii=64; {stala przechowujaca wartosc liczbowa w kodzie ascii pierwszego znaku przed A}
  LICZBA_ZNAKOW_DO_WYGRANIA=6; {ile znakow potrzebujemy by wygrac}
  ROZNICA_MIEDZY_ZNAKAMI=20; {ilosc znakow od A do S  +1}
  MAX_ILOSC_RUCHOW=(((LICZBA_WIERSZY-1)*(LICZBA_KOLUMN-1)) div 2);
type
  PLANSZE =array [POCZATKOWY_WIERSZ..LICZBA_WIERSZY] of array[POCZATKOWA_KOLUMNA..LICZBA_KOLUMN] of char; {Definiuje wlasny typ tablicy dla planszy}
var
  plansza:PLANSZE; {plansza-plansza na, ktorej rozgrywana jest gra}

  game,czy_pierwsza,gracz,wygralx,wygralo,remis:boolean;{game - wartosc true gdy gra nadal trwa, false gdy sie skonczyla. czypierwsza- zmienna
  przechowujaca wartosc nt tego czy zostal wykonany pierwszy ruch, gracz-true jesli jest to gracz X,false jesli gracz O. wygralx- true jesli
  wygral X. wygralo- true jesli wygral O. remis-true jesli nastapil remis}

  wejscie:string;{zmienna, za pomoca ktorej, wczytuje podane koordynaty wejsciowe}

  duzawspolrzedna1,malawspolrzedna1,duzawspolrzedna2,malawspolrzedna2:char;{duzawspolrzedna1-pierwsza wspolrzedna od A-S , malawspolrzedna1-
  pierwszawspolrzedna od a-s ,duzawspolrzedna2 i malawspolrzedna2 analogicznie}

  indekswiersza,indekskolumny,indekspomocniczy,ilosc_kropek,ilosc_znakow,ilosc_ruchow,wartosc_malawspolrzedna1,wartosc_malawspolrzedna2,
  wartosc_duzawspolrzedna1,wartosc_duzawspolrzedna2:integer;{indekswiersza,indekskolumny,indekspomocniczy- iteratory w pętlach, ilosc_znakow- 
  zmienna w ktorej pzechowujemy wystapienia x, ilosc_kropek-przechowuje ilosc kropek znalezionych w tablicy, ilosc_ruchow- przechowuje ile 
  nastapilo ruchow w grze, wartosc_* przechowuje wartosci liczbowe wspolrzednych w kodzie ASCII}
  {w programie korzystam z funkcji ord(char) ktora zwraca wartosc znaku w kodzie ASCII}

procedure rysuj_plansze; {procedura rysujaca plansze w terminalu}
  begin
               for indekswiersza:=POCZATKOWY_WIERSZ to LICZBA_WIERSZY do
                   begin
                   for indekskolumny:=POCZATKOWA_KOLUMNA to LICZBA_KOLUMN do
                       begin
		       if((indekswiersza=POCZATKOWY_WIERSZ)and(indekskolumny<LICZBA_KOLUMN-1)and(indekskolumny>POCZATKOWA_KOLUMNA)) then
		       write(plansza[indekswiersza][indekskolumny],'-') {poniewaz jest dwa razy wiecej znakow - w gornej ramce
		       niz znakow w innych czesciach planszy ale ostatni juz jest + dlatego indekskolumny<LICZBA_KOLUMN-1 bo ostatnie dwie 			       kolumny nie sa oddzielone spacja oraz pierwsze dwie dlatego +1}
		       else if((indekskolumny=POCZATKOWA_KOLUMNA)or(indekskolumny>=LICZBA_KOLUMN-1)) then
		       write(plansza[indekswiersza][indekskolumny]){poniewaz nie oddzielamy spacja 1 i 2 kolumny oraz dwoch ostatnich }
                       else {wypisujemy znak w tablicy i oddzielamy go spacja}
                       write(plansza[indekswiersza][indekskolumny],' ');
                       end;
                   writeln;
                   end;
  end;

procedure inicjalizuj_gre;{procedura zmienne logiczne gry}
  begin
       gracz:=true;
       game:=true;
       czy_pierwsza:=true;
       wygralx:=false;
       wygralo:=false;
       remis:=false;
       ilosc_ruchow:=0;
       
  end;
{do POCZATKOWY_WIERSZ dodajemy jeden aby uzyskac pierwsze wiersz w ktorym jest rozgrywana gra, to samo dla POCZATKOWA_KOLUMNA. 
 dla LICZBA_KOLUMN oraz LICZBA_WIERSZY odejmujemy jeden aby uzyskac ostatnia kolumne badz wiersz w ktorym rozgrywana jest gra}
procedure inicjalizuj_plansze; {procedura tworzaca plansze do gry}
  begin
  plansza[POCZATKOWY_WIERSZ][LICZBA_KOLUMN]:='+';
  plansza[LICZBA_WIERSZY][POCZATKOWA_KOLUMNA]:=' ';
  for indekskolumny:=POCZATKOWA_KOLUMNA to LICZBA_KOLUMN-1 do {tworzymy gorna granice planszy}
      begin
      plansza[POCZATKOWY_WIERSZ][indekskolumny]:='-';
      end;
  for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY do {tworzymy granice z prawej strony planszy}
      begin
      plansza[indekswiersza][LICZBA_KOLUMN]:='|';
      end;
  for indekskolumny:=POCZATKOWA_KOLUMNA+1 to LICZBA_KOLUMN-1 do {tworzymy oznaczenia kolumn planszy}
      begin
      plansza[LICZBA_WIERSZY][indekskolumny]:=char(duza_litera_ascii+indekskolumny);
      end;
  for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-1 do {tworzymy oznaczenia wierszy planszy}
      begin
      plansza[indekswiersza][POCZATKOWA_KOLUMNA]:=char(mala_litera_ascii-indekswiersza);
      end;
  for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-1 do {zapisujemy wolne pola kropkami '.'}
      begin
      for indekskolumny:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-1 do
          begin
          plansza[indekswiersza][indekskolumny]:='.';
          end;
      end;
  end;

procedure pierwsza_gra; {procedura wywolywana dla pierwszego ruchu w grze}
  begin
       if(gracz)then writeln('gracz X') else writeln('gracz O'); {w zaleznosci od tego kto wykonuje pierwszy ruch wypisuje danego gracza}
       readln(wejscie); {wczytanie wspolrzednych}
       if(length(wejscie)=0)then begin game:=false;end; {sprawdzamy czy wczytany zostal znak pusty,jesli tak to konczymy gre}
       if(length(wejscie)=2)then {jesli wejscie jest poprawnej dlugosci}
          begin
               duzawspolrzedna1:=wejscie[1]; {przypisujemy zmiennej duzawspolrzedna1 wspolrzedna wielkiej litery(A-S)}
               malawspolrzedna1:=wejscie[2]; {przypisujemy zmiennej malawspolrzedna1 wspolrzedna malej litery(a-s)}
	       wartosc_malawspolrzedna1:=ord(malawspolrzedna1);
	       wartosc_duzawspolrzedna1:=ord(duzawspolrzedna1);
               if (((wartosc_duzawspolrzedna1>duza_litera_ascii)and (wartosc_duzawspolrzedna1<duza_litera_ascii+ROZNICA_MIEDZY_ZNAKAMI )) and
               ((wartosc_malawspolrzedna1>mala_litera_ascii-ROZNICA_MIEDZY_ZNAKAMI)and (wartosc_malawspolrzedna1<mala_litera_ascii )))
 	       then{sprawdzamy czy dane wspolrzednych sa poprawne}
                  begin
                  if (plansza[mala_litera_ascii-wartosc_malawspolrzedna1][wartosc_duzawspolrzedna1-duza_litera_ascii]='.') then 
		  {sprawdzamy czy nie ma zadnego znaku postawionego na miejscu wspolrzednych}
                     begin
                     czy_pierwsza:=false; {wykonywany jest wlasnie piewszy ruch wiec kolejny nie jest juz pierwszy}
		     ilosc_ruchow:=ilosc_ruchow+1; {zwiekszam ilosc ruchow w grze}
                     if (gracz) then {stawiamy X badz O na planszy}
                        plansza[mala_litera_ascii-wartosc_malawspolrzedna1][wartosc_duzawspolrzedna1-duza_litera_ascii]:='X'
                     else
                        plansza[mala_litera_ascii-wartosc_malawspolrzedna1][wartosc_duzawspolrzedna1-duza_litera_ascii]:='O';
                     if(gracz)then gracz:=false else gracz:=true; {zmieniamy gracza}
                     end;
                  end;
          end;
  end;

procedure kolejna_gra; {procedura wywolywana dla kazdego kolejnego ruchu w grze az do skonczonej gry}
  begin

       if(gracz)then writeln('gracz X') else writeln('gracz O'); {analogicznie do czypierwsza}
       readln(wejscie);
       if(length(wejscie)=0)then begin game:=false; end;
       if(length(wejscie)=4)then {tak samo jak w czy pierwsza tylko dla dwoch wspolrzednych}
          begin
          {duzawspolrzedna1 i malawspolrzedna1 oznacza to samo co w pierwsza_gra, analogicznie dla duzawspolrzedna2 i malawspolrzedna2}
          duzawspolrzedna1:=wejscie[1]; 
          malawspolrzedna1:=wejscie[2];
          duzawspolrzedna2:=wejscie[3];
          malawspolrzedna2:=wejscie[4];
	  wartosc_malawspolrzedna1:=ord(malawspolrzedna1);
	  wartosc_malawspolrzedna2:=ord(malawspolrzedna2);
	  wartosc_duzawspolrzedna1:=ord(duzawspolrzedna1);
	  wartosc_duzawspolrzedna2:=ord(duzawspolrzedna2);
	  {sprawdzamy czy poprawne dane}
          if (((wartosc_duzawspolrzedna1>duza_litera_ascii)and (wartosc_duzawspolrzedna1<duza_litera_ascii+ROZNICA_MIEDZY_ZNAKAMI)) and 
	  ((wartosc_malawspolrzedna1>mala_litera_ascii-ROZNICA_MIEDZY_ZNAKAMI)and (wartosc_malawspolrzedna1<mala_litera_ascii )) and
	  ((wartosc_duzawspolrzedna2>duza_litera_ascii)and (wartosc_duzawspolrzedna2<duza_litera_ascii+ROZNICA_MIEDZY_ZNAKAMI)) and 
	  ((wartosc_malawspolrzedna2>mala_litera_ascii-ROZNICA_MIEDZY_ZNAKAMI)and (wartosc_malawspolrzedna2<mala_litera_ascii ))) 
          then 
               begin
	       {sprawdzamy czy pierwsze wspolrzedne sa rozne od drugich i czy pola o tych wspolrzednych nie maja ani X ani O}
               if (((wartosc_duzawspolrzedna1<>wartosc_duzawspolrzedna2)or(wartosc_malawspolrzedna1<>wartosc_malawspolrzedna2))and
	       (plansza[mala_litera_ascii-wartosc_malawspolrzedna1][wartosc_duzawspolrzedna1-duza_litera_ascii]='.')and
	       (plansza[mala_litera_ascii-wartosc_malawspolrzedna2][wartosc_duzawspolrzedna2-duza_litera_ascii]='.')) then 
                  begin
		  ilosc_ruchow:=ilosc_ruchow+1; {zwiekszam ilosc ruchow w grze}
                  if (gracz) then {i stawiamy X-y badz O w zaleznosci od gracza}
                     begin
                     plansza[mala_litera_ascii-wartosc_malawspolrzedna1][wartosc_duzawspolrzedna1-duza_litera_ascii]:='X';
                     plansza[mala_litera_ascii-wartosc_malawspolrzedna2][wartosc_duzawspolrzedna2-duza_litera_ascii]:='X';
                     end
                  else
                     begin
                     plansza[mala_litera_ascii-wartosc_malawspolrzedna1][wartosc_duzawspolrzedna1-duza_litera_ascii]:='O';
                     plansza[mala_litera_ascii-wartosc_malawspolrzedna2][wartosc_duzawspolrzedna2-duza_litera_ascii]:='O';
                     end;
                  if(gracz)then gracz:=false else gracz:=true;
                  end;
               end;
          end;
  end;

procedure wygral_O; {procedura wywolywana, gdy gre wygral O, konczymy gre}
  begin
  game:=false;
  wygralo:=true;
  end;

procedure wygral_X; {procedura wywolywana, gdy gre wygral X, konczymy gre}
  begin
  game:=false;
  wygralx:=true;
  end;

procedure sprawdz_kolumny; {sprawdzamy wystepowanie znakow na planszy w jednej kolumnie}
  begin
  for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-LICZBA_ZNAKOW_DO_WYGRANIA do {ostatni wiersz z ktorego sprawdzamy
      LICZBA_ZNAKOW_DO_WYGRANIA-1 kolejnych znakow to jest wlasnie LICZBA_WIERSZY-LICZBA_ZNAKOW_DO_WYGRANIA tak samo w kolejnych petlach jest }
      begin
      for indekskolumny:=POCZATKOWA_KOLUMNA+1 to LICZBA_KOLUMN-1 do
          begin
          if (plansza[indekswiersza][indekskolumny]='O') then {jesli natrafimy na O na planszy}
             begin
             ilosc_znakow:=1; {jedynkujemy ilosc natrafionych O}
	     {sprawdzamy czy w kolumnie natrafimy na 6 O pod rzad}
	     for indekspomocniczy:=indekswiersza+1 to indekswiersza+LICZBA_ZNAKOW_DO_WYGRANIA-1 do 
                 begin
                 if(plansza[indekspomocniczy][indekskolumny]='O') then ilosc_znakow:=ilosc_znakow+1;
                 end;
             if (ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA) then 
		{jesli LICZBA_ZNAKOW_DO_WYGRANIA(6) razy pod rzad sie powtorzylo O to konczymy gre i wygranym jest O}
                begin
                wygral_O;
                break;
                end;
             end
          else if (plansza[indekswiersza][indekskolumny]='X') then {analogicznie do poprzedniej petli dla O robimy dla X}
              begin
              ilosc_znakow:=1; {jedynkujemy ilosc natrafionych X}
	      {sprawdzamy czy w kolumnie natrafimy na 6 X pod rzad}
	      for indekspomocniczy:=indekswiersza+1 to indekswiersza+LICZBA_ZNAKOW_DO_WYGRANIA-1 do 
                  begin
                  if(plansza[indekspomocniczy][indekskolumny]='X') then ilosc_znakow:=ilosc_znakow+1;
                  end;
              if (ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA) then
		 {jesli LICZBA_ZNAKOW_DO_WYGRANIA(6) razy pod rzad sie powtorzylo X to konczymy gre i wygranym jest X}
                 begin
                 wygral_X;
                 break;
                 end;
             end;
          end;
      end;
  end;

procedure sprawdz_wiersze; {sprawdzamy wystepowanie znakow na planszy w jednym wierszu}
  begin
  for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-1 do
      begin
      for indekskolumny:=POCZATKOWA_KOLUMNA+1 to LICZBA_KOLUMN-LICZBA_ZNAKOW_DO_WYGRANIA do
          begin
          if (plansza[indekswiersza][indekskolumny]='O') then {jesli natrafimy na O na planszy}
             begin
             ilosc_znakow:=1; {jedynkujemy ilosc natrafionych O}
	     {sprawdzamy czy w wierszu natrafimy na 6 O pod rzad}
	     for indekspomocniczy:=indekskolumny+1 to indekskolumny+LICZBA_ZNAKOW_DO_WYGRANIA-1 do 
                 begin
                 if(plansza[indekswiersza][indekspomocniczy]='O') then ilosc_znakow:=ilosc_znakow+1;
                 end;
             if (ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA) then 
		{jesli LICZBA_ZNAKOW_DO_WYGRANIA(6) razy pod rzad sie powtorzylo O to konczymy gre i wygranym jest O}
                begin
                wygral_O;
                break;
                end;
             end
          else if (plansza[indekswiersza,indekskolumny]='X') then {analogicznie do poprzedniej petli dla O robimy dla X}
              begin
              ilosc_znakow:=1; {jedynkujemy ilosc natrafionych X}
	      {sprawdzamy czy w wierszu natrafimy na 6 X pod rzad}
	      for indekspomocniczy:=indekskolumny+1 to indekskolumny+LICZBA_ZNAKOW_DO_WYGRANIA-1 do 
                  begin
                  if(plansza[indekswiersza][indekspomocniczy]='X') then ilosc_znakow:=ilosc_znakow+1;
                  end;
              if (ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA) then 
		 {jesli LICZBA_ZNAKOW_DO_WYGRANIA(6) razy pod rzad sie powtorzylo X to konczymy gre i wygranym jest X}
                 begin
                 wygral_X;
                 break;
                 end;
             end;
          end;
      end;
  end;

procedure sprawdz_skosy; {sprawdzamy wystepowania znakow po skosie na planszy}
  begin
  {sprawdzamy po skosie takie ze prawa strona skierowana jest do dolu}
  for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-LICZBA_ZNAKOW_DO_WYGRANIA do 
      begin
      for indekskolumny:=POCZATKOWA_KOLUMNA+1 to LICZBA_KOLUMN-LICZBA_ZNAKOW_DO_WYGRANIA do
          begin
          if (plansza[indekswiersza][indekskolumny]='O') then {jesli natrafimy na O na planszy}
             begin
             ilosc_znakow:=1;
             for indekspomocniczy:=1 to LICZBA_ZNAKOW_DO_WYGRANIA-1 do {sprawdzamy czy po skosie natrafimy na 6 O pod rzad}
                 begin
                 if(plansza[indekswiersza+indekspomocniczy][indekskolumny+indekspomocniczy]='O')then ilosc_znakow:=ilosc_znakow+1;
                 end;
             if(ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA)then
               begin
               wygral_O;
               break;
               end;
             end
          else if (plansza[indekswiersza][indekskolumny]='X') then {analogicznie do poprzedniej petli dla O robimy dla X}
             begin
             ilosc_znakow:=1;
             for indekspomocniczy:=1 to LICZBA_ZNAKOW_DO_WYGRANIA-1 do {sprawdzamy czy po skosie natrafimy na 6 X pod rzad}
                 begin
                 if(plansza[indekswiersza+indekspomocniczy][indekskolumny+indekspomocniczy]='X')then ilosc_znakow:=ilosc_znakow+1;
                 end;
             if(ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA)then
               begin
               wygral_X;
               break;
               end;
             end;
          end;
      end;
  {sprawdzamy po skosie takie ze z prawej strony rosna}
  for indekswiersza:=LICZBA_WIERSZY-1 downto LICZBA_ZNAKOW_DO_WYGRANIA do
      begin
      for indekskolumny:=POCZATKOWA_KOLUMNA+1 to LICZBA_KOLUMN-LICZBA_ZNAKOW_DO_WYGRANIA do
          begin
          if (plansza[indekswiersza][indekskolumny]='O') then {jesli natrafimy na O na planszy}
             begin
             ilosc_znakow:=1;
             for indekspomocniczy:=1 to LICZBA_ZNAKOW_DO_WYGRANIA-1 do {sprawdzamy czy po skosie natrafimy na 6 O pod rzad}
                 begin
                 if(plansza[indekswiersza-indekspomocniczy][indekskolumny+indekspomocniczy]='O')then ilosc_znakow:=ilosc_znakow+1;
                 end;
             if(ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA)then
               begin
               wygral_O;
               break;
               end;
             end
          else if (plansza[indekswiersza][indekskolumny]='X') then {analogicznie do poprzedniej petli dla O robimy dla X}
             begin
             ilosc_znakow:=1;
             for indekspomocniczy:=1 to LICZBA_ZNAKOW_DO_WYGRANIA-1 do {sprawdzamy czy po skosie natrafimy na 6 X pod rzad}
                 begin
                 if(plansza[indekswiersza-indekspomocniczy][indekskolumny+indekspomocniczy]='X')then ilosc_znakow:=ilosc_znakow+1;
                 end;
             if(ilosc_znakow=LICZBA_ZNAKOW_DO_WYGRANIA)then
               begin
               wygral_X;
               break;
               end;
             end;
          end;
      end;
  end;
procedure kto_wygral;{procedura przeszukajaca plansze w poszukiwaniu 6 badz wiecej X czy O pod rzad i zwracajaca wygranego}
  begin
  sprawdz_wiersze;
  sprawdz_kolumny;
  sprawdz_skosy;
  end;

procedure czy_remis; {w tej procedurze sprawdzam czy nie nastapil remis czyli nie zostaly zapelnione wszystkie pola przez X i O}
  begin {teoretycznie nie ma potrzeby sprawdzania pol bo po ilosci ruchu wiemy kiedy jest remis, jednak w taki sposob mamy dwukrotna pewnosc
 	ze remis na pewno nastapil}
       ilosc_kropek:=0;
       {poniewaz wiem ze kazde pole na poczatku zostalo zainicjalizowane przez . , musze je po prostu policzyc}
       for indekswiersza:=POCZATKOWY_WIERSZ+1 to LICZBA_WIERSZY-1 do 
           begin
                for indekskolumny:=POCZATKOWA_KOLUMNA to LICZBA_KOLUMN-1 do
                    begin
                         if(plansza[indekswiersza,indekskolumny]='.')then ilosc_kropek:=ilosc_kropek+1;
                    end;
           end;
       if(ilosc_kropek=0)then {i jesli ilosc'.'jest rowna 0 oznacza to ze wszystkie pola w planszy zostaly zapelnione czyli nastapil remis.}
          begin
               remis:=true;
               game:=false;
          end;
  end;

{Glowna petla programu}
begin
  inicjalizuj_gre;    {procedura inicjalizujace zmienne logiczne gry oraz licznik ruchow}
  inicjalizuj_plansze; {tworzymy plansze}
  while(game)do {glowna petla gry, wykonywana dopoki nie nastapi wygrana, remis badz uzytkownik nie poda pustego znaku}
               begin

                    rysuj_plansze; {wypisuje na ekranie plansze po ostatnim ruchu}
                    if (czy_pierwsza) then {sprawdzamy czy zostal wykonany pierwszy ruch w grze}
                       begin
                       pierwsza_gra; {procedura wczytujaca wspolrzedne w pierwszej grze i zapisujaca je na planszy}
                       end
                    else begin {jesli jest to kolejny ruch w grze}
                         kolejna_gra; {procedura wczytujaca wspolrzedne w kolejnych grach na zmiane gracza X i O i zapisujaca je na planszy}
			 if (ilosc_ruchow>=LICZBA_ZNAKOW_DO_WYGRANIA) then kto_wygral;
			 {procedura sprawdzajaca czy ktorys z graczy wygral po ostatnim ruchu, 
			 a najszybsza wygrana moze nastapic po lacznie LICZBA_ZNAKOW_DO_WYGRANIA(6) ruchach}
                         if (ilosc_ruchow>MAX_ILOSC_RUCHOW-1) then czy_remis; {procedura sprawdzajaca czy nie nastapil przypadkiem remis,
			 moze nastapic tylko po maksymalnej ilosci poprawnych ruchow}
                         end;
               end;
  {wypisanie ostatniego ukladu planszy oraz podanie zwyciezcy badz remisu badz niczego jesli gra nie skonczyla sie ani remisem ani wygrana}
  if((remis)or(wygralx)or(wygralo)) then rysuj_plansze;
  if(remis) then writeln('remis')
  else if(wygralx)then writeln('wygral X')
  else if(wygralo)then writeln('wygral O')
end.

