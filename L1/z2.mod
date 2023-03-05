# Błażej Wróbel, 250070, W4N, zadanie 2, metody optymalizacji, lista 1

set Cities;	# Zbiór miast, w których firma ma swoje oddziały
set Campers;	# Zbiór kamperów, które są wynajmowane

param Deficiency{i in Cities, c in Campers}, integer, >= 0; # Niedobory poszczególnych kamperów w poszczególnych miastach
param Surplus{i in Cities, c in Campers}, integer, >= 0; # Niedobory poszczególnych kamperów w poszczególnych miastach
param CostCoefficients{Campers}, >= 0; # Współczynniki kosztów: standard - 1, vip - 1.15
param Costs{i in Cities, j in Cities}, integer, >= 0; # Koszty transportu kampera standard
param CouldReplace symbolic in Campers; # Kamper, który może zastąpić
param CouldntReplace symbolic in Campers; # Kamper, który nie może być zastąpiony

var x{c in Campers, i in Cities, j in Cities: i != j}, integer, >= 0;	# Zmienne decyzyjne, które wyrażają ile kamperów, skąd i dokąd przewieźć

minimize TransportCost: sum{c in Campers, i in Cities, j in Cities: i != j} Costs[i, j]*CostCoefficients[c]*x[c, i, j]; # Funkcja kosztu - koszt transportu poszczególnych kamperów z miasta i do j

s.t. SurplusConstraint{c in Campers, i in Cities}: sum{j in Cities: j != i} x[c, i, j] <= Surplus[i, c]; # Nie mogę przekroczyć nadwyżek poszczególnych kamperów
s.t. VipDeficientConstraint{j in Cities}: sum{i in Cities: i != j} x[CouldReplace, i, j] >= Deficiency[j, CouldReplace]; # Staram się usunąć niedobór kamperów vip w poszczególnych miastach

# Staram się usunąć niedobór kamperów standard w poszczególnych miastach, przy czym kamper standard może być zastąpiony przez kamper vip
s.t. VipStandardDeficientConstraint{j in Cities}: sum{i in Cities: i != j} (x[CouldntReplace, i, j] + x[CouldReplace, i, j]) - Deficiency[j, CouldReplace] >= Deficiency[j, CouldntReplace];

solve;

printf "Plan przemieszczania dla campera Standard: \n";
for{i in Cities}
{	
	printf{j in Cities: i != j and x['standard', i, j] != 0} "%d kamperów Standard z %s do %s \n", x['standard', i, j], i, j;
}	

printf "######################### \n";

printf "Plan przemieszczania dla campera Vip: \n";
for{i in Cities}
{	
	printf{j in Cities: i != j and x['vip', i, j] != 0} "%d kamperów Vip z %s do %s \n", x['vip', i, j], i, j;
}	
printf "######################### \n";
printf "Koszt transportu wynikający z planu przemieszczeń: %f \n", TransportCost;

data;

set Campers := standard, vip;
set Cities := Warszawa, Gdansk, Szczecin, Wroclaw, Krakow, Berlin, Rostok, Lipsk, Praga, Brno, Bratyslawa, Koszyce, Budapeszt;

param CostCoefficients := standard 1 vip 1.15;

param Surplus:	standard vip :=
	Warszawa 14 0
	Gdansk  0 2
	Szczecin 12 4
	Wroclaw 0 10
	Krakow 10 0
	Berlin 0 0
	Rostok 0 4
	Lipsk 0 10
	Praga 10 0
	Brno 0 2
	Bratyslawa 0 8
	Koszyce 0 4
	Budapeszt 0 4;
	
param Deficiency: standard vip :=
	Warszawa 0 4
	Gdansk  20 0
	Szczecin 0 0
	Wroclaw 8 0
	Krakow 0 8
	Berlin 16 4
	Rostok 2 0
	Lipsk 3 0
	Praga 0 4
	Brno 9 0
	Bratyslawa 4 0
	Koszyce 4 0
	Budapeszt 8 0;
	
param Costs: Warszawa Gdansk Szczecin Wroclaw Krakow Berlin Rostok Lipsk Praga Brno Bratyslawa Koszyce Budapeszt := 
	Warszawa 0 340 566 355 290 573 805 727 741 540 662 489 780
	Gdansk  340 0 368 482 598 572 620 727 743 765 887 847 1084
	Szczecin 566 368 0 394 647 150 260 364 498 703 824 897 1021
	Wroclaw 355 482 394 0 272 344 632 381 284 287 525 522 721
	Krakow 290 598 647 272 0 597 884 633 533 332 454 260 398
	Berlin 573 572 150 344 597 0 234 190 350 555 676 906 873
	Rostok 805 620 260 632 884 234 0 391 585 790 912 1144 1108
	Lipsk  727 727 364 381 633 190 391 0 255 461 582 884 778
	Praga 741 743 498 284 533 350 585 255 0 207 328 663 525
	Brno  540 765 703 287 332 555 790 461 207 0 130 461 326
	Bratyslawa 662 887 824 525 454 676 912 582 328 130 0 438 200
	Koszyce 489 847 897 522 260 906 1144 884 663 461 438 0 261
	Budapeszt 780 1084 1021 721 398 873 1108 778 525 326 200 261 0;
	
param CouldReplace := vip;
param CouldntReplace := standard;

end;


