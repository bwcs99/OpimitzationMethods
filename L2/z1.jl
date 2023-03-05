# Błażej Wróbel, 250070, 4. rok, informatyka algorytmiczna, W4N
using JuMP, Cbc

function solve_model(Q::Array{Int},t::Array{Int})

    n = size(t[:, 1])[1]

    model = Model(Cbc.Optimizer)

    @variable(model, x[1:n], Bin) # zmienne decyzyjne - wybór miejsca j do przeszukania
    @objective(model, Min, t'*x) # funkcja celu - łączny czas przeszukiwania
    @constraint(model, c1, Q*x .>= 1) # ograniczenie - mamy odczytać wszystkie cechy

    print(model)

    optimize!(model)

    status = termination_status(model)

    if status == MOI.OPTIMAL
        return status, objective_value(model), value.(x)
    else
        return status, nothing, nothing
    end
end 


T = [12, 9, 98, 45, 10]

Q = [0 1 1 0 1; 1 0 0 1 0; 1 1 1 0 0; 1 1 1 1 1; 0 1 0 1 1; 1 1 0 1 0]

status, function_value,solution = solve_model(Q, T)

if status == MOI.OPTIMAL
    println("Znaleziono rozwiązanie optymalne !")
    println("Wartość funkcji celu: ", function_value)
    println("Rozwiązanie: ", solution)
else
    println("Nie znaleziono rozwiązania optymalnego !")
end

