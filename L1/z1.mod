# Zadanie 1, metody optymalizacji, Lista 1
# Błażej Wróbel, 250070, W4N, 4. rok, informatyka algorytmiczna

param n, integer, > 0; # Dodatni parametr n określający np. wielkość macierzy ograniczeń i liczbę zmiennych decyzyjnych

set Range := 1..n; # Zbiór liczb od 1 do n

param A{i in Range, j in Range} := (1/(i + j - 1)); # Macierz ograniczeń A (jej wielkość zależy od n)
param b{i in Range} := sum{j in Range} (1/(i + j - 1)); # Wektor prawych stron b (jego wielkość zależy od n)
param c{i in Range} := sum{j in Range} (1/(i + j - 1)); # Wektor współczynników funkcji celu (jego wielkość zależy od n)

var x{Range} >= 0; # Zmienne decyzyjne x (rozwiązania układu n równanń liniowych)

minimize ObjFunc: sum{i in Range} x[i]*c[i]; # Funkcja celu - c^T * x, która jest minimalizowana

s.t. constraints{i in Range}: sum{j in Range} A[i, j]*x[j] = b[i]; # Ograniczenie z podanego modelu - Ax = b

solve;

# Wyświetlanie wyników 
printf "----- WYNIKI ----- \n";
printf "x obliczony: \n";
printf{i in Range} "%f \n", x[i];
printf "Błąd względny: \n";
printf "%f \n", (sqrt(sum{i in Range} (x[i] - 1)*(x[i] - 1)))/sqrt(n); 

data;

param n := 20;

end;

