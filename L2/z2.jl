# Błażej Wróbel, 250070, 4. rok, informatyka algorytmiczna, W4N
using JuMP, Cbc

function solve_model(I::Array{Int}, t::Array{Int}, r::Array{Int}, M::Int)
    m, n = size(t)

    model = Model(Cbc.Optimizer)

    @variable(model, x[1:m, 1:n], Bin) # zmienne decyzyjne - wybór danego podprogramu do obliczenia danej funkcji
    @objective(model, Min, sum((x[i,:])'*t[i,:] for i in I)) # funkcja celu - czas wykonania ułożonego programu

    for i in I
        @constraint(model, sum(x[i,:]) == 1) # ograniczenie - bierzemy tylko podprogramy do obliczania zadanych funkcji
    end

    whole_set = 1:m

    for i in setdiff(whole_set, I)
        @constraint(model, sum(x[i,:]) == 0) # ograniczenie - nie bierzemy innych podprogramów
    end

    @constraint(model, size_constraint, sum((x[i,:])'*r[i,:] for i in I) <= M) # ograniczenie - ułożony program musi zajmować co najwyżej M komórek pamięci

    print(model)

    optimize!(model)

    status = termination_status(model)

    if status == MOI.OPTIMAL
        return status, objective_value(model), value.(x)
    else
        return status, nothing, nothing
    end
end

I = [1, 3, 5]

t = [12 30 20 45 60 10;
     10 10 56 78 90 9;
     25 45 12 34 67 70;
     23 43 12 21 32 45;
     23 65 76 68 56 76]

r = [34 51 21 14 15 17;
     20 30 40 10 21 25;
     56 12 32 45 61 12;
     34 43 23 65 12 9;
     33 44 23 65 78 14]

M = 100

stat, function_value, solution = solve_model(I, t, r, M)

if stat == MOI.OPTIMAL
    println("Znaleziono rozwiązanie optymalne !")
    println("Wartość funkcji celu: ", function_value)
    println("Rozwiązanie: ", solution)
else
    println("Nie znaleziono rozwiązania optymalnego !")
end