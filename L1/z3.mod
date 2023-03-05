# Błażej Wróbel, 250070, zadanie 3, metody optymalizacji, lista 1, W4N

var x1 >= 0; # Ilość surowca pierwszego do kupienia
var x2 >= 0; # Ilość surowca drugiego do kupienia
var x3 >= 0; # Ilość surowca trzeciego do kupienia

var x1a >= 0; # Ilość surowca pierwszego przeznaczonego do produkcji produktu A
var x2a >= 0; # Ilość surowca drugiego przeznaczonego do produkcji produktu A
var x3a >= 0; # Ilość surowca trzeciego przeznaczonego do produkcji produktu A

var x1b >= 0; # Ilość surowca pierwszego przeznaczonego do produkcji produktu B
var x2b >= 0; # Ilość surowca drugiego przeznaczonego do produkcji produktu B
var x3b >= 0; # Ilość surowca trzeciego przeznaczonego do produkcji produktu B

var x1c >= 0; # Ilość surowca 1 przeznaczonego do produkcji produktu C
var x1co >= 0; # Ilość odpadu surowca 1 z produkcji produktu A
var x2co >= 0; # Ilość odpadu surowca 2 z produkcji produktu A
var x3co >= 0; # Ilość odpadu surowca 3 z produkcji produktu A

var x2d >= 0; # Ilość surowca 2 przeznaczonego do produkcji produktu D 
var x1do >= 0; # Ilość odpadu surowca 1 z produkcji produktu B
var x2do >= 0; # Ilość odpadu surowca 2 z produkcji produktu B
var x3do >= 0; # Ilość odpadu surowca 3 z produkcji produktu B

maximize Profit: -2.1*x1-1.6*x2-x3+3*(x1a+x2a+x3a)+2.5*(x1b+x2b+x3b)+0.6*(x1c+x1co+x2co+x3co)+0.5*(x2d+x1do+x2do+x3do)-(0.1*(0.1*x1a-x1co)+0.1*(0.2*x2a-x2co)+0.2*(0.4*x3a-x3co)+
		0.05*(0.2*x1b-x1do)+0.05*(0.2*x2b-x2do)+0.4*(0.5*x3b-x3do)); # Zysk przedsiębiorstwa po odjęciu kosztów utylizacji odpadów itp. - maksymalizowana funkcja celu
		

s.t. quantityX1: 6000 >= x1 >= 2000; # Ograniczenia wynikające z minimalnej i maksymalnej ilości surowców, które można kupić
s.t. quantityX2: 5000 >= x2 >= 3000;
s.t. quantityX3: 7000 >= x3 >= 4000;

s.t. productAc1: 0.8*x1a-0.2*x2a-0.2*x3a >= 0; # Ograniczenia ilości poszczegónych surowców dla produktu A (tabelka na liście)
s.t. productAc2: -0.4*x1a+0.6*x2a-0.4*x3a >= 0;
s.t. productAc3: -0.1*x1a-0.1*x2a+0.9*x3a <= 0;
s.t. productAc4: x1a <= x1; # Ilości surowców przeznaczonych do produkcji nie mogą przekroczyć zakupionej ilości surowców
s.t. productAc5: x2a <= x2;
s.t. productAc6: x3a <= x3;

s.t. productBc1: 0.9*x1b-0.1*x2b-0.1*x3b >= 0; # Ograniczenia ilości poszczegónych surowców dla produktu B (tabelka na liście)
s.t. productBc2: -0.3*x1b-0.3*x2b+0.7*x3b <= 0;
s.t. productBc3: x1b <= x1 - x1a; # Ilości surowców przeznaczonych do produkcji nie mogą przekroczyć ilości, która została po wyprodukowaniu A
s.t. productBc4: x2b <= x2 - x2a;
s.t. productBc5: x3b <= x3 - x3a;

s.t. productCc1: x1co <= 0.1*x1a; # Ograniczenia ilości odpadów pochodzących od poszczególnych surowców z produkcji A (tabelka współczynników strat)
s.t. productCc2: x2co <= 0.2*x2a;
s.t. productCc3: x3co <= 0.4*x3a;
s.t. productCc4: x1c <= x1-x1a-x1b; # Ilość surowca 1 nie może przekroczyć tego co zostało po produkcji A i B
s.t. productCc5: 0.8*x1c-0.2*x1co-0.2*x2co-0.2*x3co = 0; # Surowiec 1 musi stanowić wagowo dokładnie 20% mieszanki

s.t. productDc1: x1do <= 0.2*x1b; # Ograniczenia ilości odpadów pochodzących od poszczególnych surowców z produkcji B (tabelka współczynników strat)
s.t. productDc2: x2do <= 0.2*x2b;
s.t. productDc3: x3do <= 0.5*x3b;
s.t. productDc4: x2d <= x2-x2a-x2b; # Ilość surowca 2 nie może przekroczyć tego co zostało po produkcji A i B
s.t. productDc5: 0.7*x2d-0.3*x1do-0.3*x2do-0.3*x3do = 0; # Surowiec 2 musi stanowić wagowo dokładnie 30% mieszanki

solve;

# Drukowanie rozwiązania

printf "--- Ilość poszczególnych surowców do kupienia: --- \n";
printf "Surowiec 1: %d \n", x1;
printf "Surowiec 2: %d \n", x2;
printf "Surowiec 3: %d \n", x3;

printf "--- Jaką część poszczególnych surowców przeznaczyć do produkcji A: \n";
printf "Surowiec 1: %f \n", x1a/x1;
printf "Surowiec 2: %f \n", x2a/x2;
printf "Surowiec 3: %f \n", x3a/x3;

printf "--- Jaką część poszczególnych surowców przeznaczyć do produkcji B: \n";
printf "Surowiec 1: %f \n", x1b/x1;
printf "Surowiec 2: %f \n", x2b/x2;
printf "Surowiec 3: %f \n", x3b/x3;

printf "--- Jaką część poszczególnych surowców przeznaczyć do produkcji C: \n";
printf "Surowiec 1: %f \n", x1c/x1;

printf "--- Jaką część poszczególnych surowców przeznaczyć do produkcji D: \n";
printf "Surowiec 2: %f \n", x2d/x2;

printf "Część odpadów z produkcji A przeznaczona do produkcji C: \n";
printf "Odpad z surowca 1: %f \n",  x1co/(0.1*x1a);
printf "Odpad z surowca 2: %f \n",  x2co/(0.2*x2a);
printf "Odpad z surowca 3: %f \n",  x3co/(0.4*x3a);

printf "Część odpadów z produkcji B przeznaczona do produkcji D: \n";
printf "Odpad z surowca 1: %f \n",  x1do/(0.2*x1b);
printf "Odpad z surowca 2: %f \n",  x2do/(0.2*x2b);
printf "Odpad z surowca 3: %f \n",  x3do/(0.5*x3b);

printf "Część odpadów z produkcji A przeznaczona do zniszczenia: \n";
printf "Odpady z surowca 1: %f \n", (0.1*x1a-x1co)/(0.1*x1a);
printf "Odpady z surowca 2: %f \n", (0.2*x2a-x2co)/(0.2*x2a);
printf "Odpady z surowca 3: %f \n", (0.4*x3a-x3co)/(0.4*x3a);

printf "Część odpadów z produkcji B przeznaczona do zniszczenia: \n";
printf "Odpady z surowca 1: %f \n", (0.2*x1b-x1do)/(0.2*x1b);
printf "Odpady z surowca 2: %f \n", (0.2*x2b-x2do)/(0.2*x2b);
printf "Odpady z surowca 3: %f \n", (0.5*x3b-x3do)/(0.5*x3b);

printf "Osiągnięty zysk: %f \n", Profit;

end;
