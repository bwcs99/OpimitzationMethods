# Błażej Wróbel, 250070, 4. rok, informatyka algorytmiczna, W4N
using JuMP, Cbc
include("gantt.jl")

function solve_model(d::Array{Int})
    n, m = size(d)

    B = sum(d) + 1 # big number - potrzebne w niektórych ograniczeniach

    precedence = [(j, i, k) for j in 1:m, i in 1:n, k in 1:n if i < k] # indeksy - zadanie k jest wykonywane przed zadaniem i na maszynie j

    model = Model(Cbc.Optimizer)

    @variable(model, S[1:n, 1:m] >= 0) # zmienne decyzyjne - moment rozpoczęcia danego zadania na danej maszynie
    @variable(model, x[precedence], Bin) # binarne zmienne pomocnicze
    @variable(model, make_span) # zmienna - czas zakończenia ostatniego zadania na P3

    @objective(model, Min, make_span) # funkcja celu - czas zakończenia ostatniego zadania na P3

    for i in 1:n
        for j in 1:m
            if j < m
                @constraint(model, S[i, j] + d[i, j] <= S[i, j + 1]) # ograniczenia kolejnościowe, najpierw na P1, potem na P2 i później na P3
            end
        end
    end

    for (j, i, k) in precedence # Ograniczenie, że procesor w danej chwili wykonuje tylko jedno zadanie
        @constraint(model, S[i, j] - S[k, j] + B*x[(j, i, k)] >= d[k, j]) 
        @constraint(model, S[k, j] - S[i, j] + B*(1 - x[(j, i, k)]) >= d[i, j])
    end

    for i in 1:n # Moment zakończenia ostatniego zadania musi być mniejszy równy niż wartość funkcji celu
        @constraint(model, S[i, m] + d[i, m] <= make_span)
    end

    print(model)

    optimize!(model)

    status = termination_status(model)

    if status == MOI.OPTIMAL
        return status, objective_value(model), value.(S)
    else
        return status, nothing, nothing
    end

end

d =  [4       4       4;
      1       2       5;
      4       1       3;
      1       2       3;
     ]       

status, function_value, solution = solve_model(d)

if status == MOI.OPTIMAL
    println("Znaleziono rozwiązanie optymalne !")
    println("Wartość funkcji celu: ", function_value)
    println("Znalezione rozwiązanie: ", solution)
    print_gantt_diagram(solution, d, function_value)
else
    println("Nie znaleziono rozwiązania optymalnego !")
end



