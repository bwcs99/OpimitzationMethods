# Błażej Wróbel, 250070, W4N, metody optymalizacji, zadanie 4, lista 1

var x_algebra_1, binary; # Zmienne binarne oznaczające, którą (jedną) grupę z algebry wybiorę
var x_algebra_2, binary;
var x_algebra_3, binary;
var x_algebra_4, binary;

var x_analiza_1, binary; # Zmienne binarne oznaczające, którą (jedną) grupę z analizy wybiorę
var x_analiza_2, binary;
var x_analiza_3, binary;
var x_analiza_4, binary;

var x_fizyka_1, binary; # Zmienne binarne oznaczające, którą (jedną) grupę z fizyki wybiorę
var x_fizyka_2, binary;
var x_fizyka_3, binary;
var x_fizyka_4, binary;

var x_chem_min_1, binary; # Zmienne binarne oznaczające, którą (jedną) grupę z chemii minerałów wybiorę
var x_chem_min_2, binary;
var x_chem_min_3, binary;
var x_chem_min_4, binary;

var x_chem_org_1, binary; # Zmienne binarne oznaczające, którą (jedną) grupę z chemii organicznej wybiorę
var x_chem_org_2, binary;
var x_chem_org_3, binary;
var x_chem_org_4, binary;

var sport_classes_1, binary; # "Sztuczne" zmienne binarne oznaczające, które grupy z zajęć sportowych wybiorę
var sport_classes_2, binary;
var sport_classes_3, binary;


# Funkcja celu - taki dobór grup zajęciowych aby zmaksymalizować sumę punktów preferencyjnych
maximize PreferencePointsSum: 5*x_algebra_1+4*x_algebra_2+10*x_algebra_3+5*x_algebra_4+4*x_analiza_1+4*x_analiza_2+5*x_analiza_3+6*x_analiza_4+3*x_fizyka_1+5*x_fizyka_2+7*x_fizyka_3+8*x_fizyka_4+10*x_chem_min_1+10*x_chem_min_2+
7*x_chem_min_3+5*x_chem_min_4+0*x_chem_org_1+5*x_chem_org_2+3*x_chem_org_3+4*x_chem_org_4 + 0*sport_classes_1 + 0*sport_classes_2 + 0*sport_classes_3; 

s.t. MondayConstraint: x_algebra_1 + x_analiza_1 + x_chem_min_1 + x_chem_min_2 + x_chem_org_1 + x_chem_org_2 <= 4; # W ciągu jednego dnia, student nie chce mieć więcej niż 4 godziny zajęć
s.t. TuesdayConstraint: x_algebra_2 + x_analiza_2 + x_fizyka_1 + x_fizyka_2 <= 4;
s.t. WednesdayCosntraint: x_algebra_3 + x_algebra_4 + x_analiza_3 <= 4;
s.t. ThursdayConstraint: x_analiza_4 + x_fizyka_3 + x_fizyka_4 + x_chem_min_3 <= 4;
s.t. FridayConstraint: x_chem_min_4 + x_chem_org_3 + x_chem_org_4 <= 4;

s.t. OnlyOneGroupCons1: x_algebra_1 + x_algebra_2 + x_algebra_3 + x_algebra_4 = 1; # Dla każdego przedmiotu muszę się zapisać tylko do jednej grupy zajęciowej
s.t. OnlyOneGroupCons2: x_analiza_1 + x_analiza_2 + x_analiza_3 + x_analiza_4 = 1; 
s.t. OnlyOneGroupCons3: x_fizyka_1 + x_fizyka_2 + x_fizyka_3 + x_fizyka_4 = 1;
s.t. OnlyOneGroupCons4: x_chem_min_1 + x_chem_min_2 + x_chem_min_3 + x_chem_min_4 = 1;
s.t. OnlyOneGroupCons5: x_chem_org_1 + x_chem_org_2 + x_chem_org_3 + x_chem_org_4 = 1;

s.t. SportClassesCons: 1 <= sport_classes_1 + sport_classes_2 + sport_classes_3 <= 3; # Student może trenować 1, 2 lub 3 razy w tygodniu

s.t. ColConst1: x_algebra_1 + x_analiza_1 <= 1; # Student nie może zapisywać się do kolidujących (czasowo) grup z różnych przedmiotów
s.t. ColConst2: x_chem_min_1 + x_chem_min_2 <= 1;
s.t. ColConst3: x_chem_min_1 + x_chem_org_1 <= 1;
s.t. ColConst4: x_chem_min_2 + x_chem_org_1 <= 1;

s.t. ColConst5: x_algebra_2 + x_analiza_2 <= 1;
s.t. ColConst6: x_algebra_2 + x_fizyka_1 <= 1;
s.t. ColConst7: x_algebra_2 + x_fizyka_2 <= 1;
s.t. ColConst8: x_analiza_2 + x_fizyka_1 <= 1;
s.t. ColConst9: x_analiza_2 + x_fizyka_2 <= 1;

s.t. ColConst10: x_algebra_3 + x_analiza_3 <= 1;
s.t. ColConst11: x_algebra_4 + x_analiza_3 <= 1;

s.t. ColCons12: x_chem_min_4 + x_chem_org_4 <= 1;

s.t. FridayDinnerConstraint1: x_chem_org_3 + x_chem_org_4 <= 1; # Student chce mieć każdego dnia godzinną przerwę między 12-14, aby zjeść obiad
s.t. FridayDinnerConstraint2: x_chem_org_3 + x_chem_min_4 <= 1;

s.t. MondaySportClassesCons1: sport_classes_1 + x_algebra_1 <= 1; # Student nie może być na zajęciach sportowych i na obowiązkowych ćwiczeniach jednocześnie
s.t. MondaySportClassesCons2: sport_classes_1 + x_analiza_1 <= 1; 

s.t. WednesdaySportClassesCons1: x_algebra_3 + sport_classes_2 <= 1;
s.t. WednesdaySportClassesCons2: x_analiza_3 + sport_classes_2 <= 1;
s.t. WednesdaySportClassesCons3: x_algebra_4 + sport_classes_2 <= 1;

s.t. WednesdaySportClassesCons4: x_analiza_3 + sport_classes_3 <= 1;
s.t. WednesdaySportClassesCons5: x_algebra_4 + sport_classes_3 <= 1;

solve;

# Wypisywanie otrzymanego planu 
printf "Poniedziałek: \n";
printf "Chemia minerałów 1 (8 - 10): %d \n", x_chem_min_1;
printf "Chemia minerałów 2 (8 - 10): %d \n", x_chem_min_2;
printf "Chemia organiczna 1 (9 - 10:30): %d \n", x_chem_org_1;
printf "Chemia organiczna 2 (10:30 - 12): %d \n", x_chem_org_2;
printf "Algebra 1 (13 - 15): %d \n", x_algebra_1;
printf "Analiza 1 (13 - 15): %d \n", x_analiza_1;
printf "Zajęcia sportowe 1 (13 - 15): %d \n", sport_classes_1;

printf "******\n";

printf "Wtorek: \n";
printf "Fizyka 1 (8 - 11): %d \n", x_fizyka_1;
printf "Fizyka 2 (10 - 13): %d \n", x_fizyka_2;
printf "Analiza 2 (10 - 12): %d \n", x_analiza_2;
printf "Algebra 2 (10 - 12): %d \n", x_algebra_2;

printf "******\n";

printf "Środa: \n";
printf "Algebra 3 (10 - 12): %d \n", x_algebra_3;
printf "Analiza 3 (11 - 13): %d \n", x_analiza_3;
printf "Algebra 4 (11 - 13): %d \n", x_algebra_4;
printf "Zajęcia sportowe 2 (11 - 13): %d \n", sport_classes_2;
printf "Zajęcia sportowe 3 (13 - 15): %d \n", sport_classes_3;

printf "******\n";

printf "Czwartek: \n";
printf "Analiza 4 (8 - 10): %d \n", x_analiza_4;
printf "Chemia minerałów 3 (13 - 15): %d \n", x_chem_min_3;
printf "Fizyka 3 (15 - 18): %d \n", x_fizyka_3;
printf "Fizyka 4 (17 - 20): %d \n", x_fizyka_4;

printf "******\n";

printf "Piątek: \n";
printf "Chemia organiczna 3 (11 - 12:30): %d \n", x_chem_org_3;
printf "Chemia organiczna 4 (13 - 14:30): %d \n", x_chem_org_4;
printf "Chemia minerałow 4 (13 - 15): %d \n", x_chem_min_4;

printf "******\n";

printf "Osiągnięta suma punktów preferencyjnych: %d \n", PreferencePointsSum;

end;
