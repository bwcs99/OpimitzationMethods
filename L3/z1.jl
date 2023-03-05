#Błażej Wróbel, 250070, 4. rok, W4N, informatyka algorytmiczna

using JuMP, Cbc

# Funkcja do odczytywania i parsowania zawartości plików z danymi testowymi
function open_and_parse_file(file_name::String="")
    if file_name == ""
        print("> Proszę podać nazwę pliku z danymi: ")

        file_name = readline()
    end

    Costs_Set = []
    Consumptions_Set = []
    Capacities_Set = []

    open(file_name) do f
        p = parse(Int64, chomp(readline(f)))

        problem_counter = 0

        while problem_counter < p

            description_line = split(strip(readline(f)), " ")
            m, n = parse(Int64, description_line[1]), parse(Int64, description_line[2])

            CostMat = zeros(Int64, m, n)
            ConsumptionMat = zeros(Int64, m, n)
            CapacitiesMat = zeros(Int64, 1, m)
            
            line_counter = 0

            while line_counter < m
                costs  = Int64[]

                while length(costs) < n
                    
                    current_line = split(strip(readline(f)), " ")

                    ints = [parse(Int64, x) for x in current_line]

                    costs = vcat(costs, ints)

                end

                CostMat[line_counter + 1, :] = costs

                line_counter += 1
            end

            line_counter = 0

            while line_counter < m
                consumptions = []

                while length(consumptions) < n
                    
                    current_line = split(strip(readline(f)), " ")

                    ints = [parse(Int64, x) for x in current_line]

                    consumptions = vcat(consumptions, ints)

                end

                ConsumptionMat[line_counter + 1, :] = consumptions

                line_counter += 1
            end

            capacities = []

            while length(capacities) < m

                resource_capacities = split(strip(readline(f)), " ")

                parsed_capacities = [parse(Int64, x) for x in resource_capacities]

                capacities = vcat(capacities, parsed_capacities)

            end

            CapacitiesMat[1, :] = capacities

            push!(Costs_Set, CostMat)
            push!(Consumptions_Set, ConsumptionMat)
            push!(Capacities_Set, CapacitiesMat)

            problem_counter += 1

        end
        
    end

    return Costs_Set, Consumptions_Set, Capacities_Set

end

# Główna funkcja rozwiązująca instancje problemu GAP
function gap(CostsArray::Array{Int}, ConsumptionsArray::Array{Int}, 
    CapacitiesArray::Array{Int})

    # Pobieram liczbę maszyn i zadań (wymiary macierzy)
    m, n = size(CostsArray)

    # Dwa zbiory maszyn - jeden jest pomocniczy
    machines = [i for i in 1:m]
    _machines = [i for i in 1:m]

    # Dwa zbiory prac - jeden jest pomocniczy
    jobs = [i for i in 1:n]
    _jobs = [i for i in 1:n]

    # graf dwudzielny do modelowania przydziału
    graph = [(i, j) for i in machines for j in jobs]

    # znaleziony przydział - początkowo pusty
    assignment = Tuple{Int, Int}[]

    # licznik iteracji
    iterations_counter = 0

    # słownik do trzymania liczby przydzielonych prac w każdej iteracji
    progress = Dict{Int, Int}()

    # główna pętla algorytmu
    while length(_jobs) != 0

        model = Model(Cbc.Optimizer)

        # zmienne decyzyjne do używanego programu liniowego (są >= 0)
        @variable(model, x[1:m, 1:n] >= 0)

        # minimalizowana funkcja celu - całkowity koszt przydziału 
        @objective(model, Min, sum(CostsArray[i, j]*x[i, j] for (i, j) in graph))

        # ograniczenie numer 1 - każda praca ma zostać przypisana do dokładnie jednej maszyny
        for j in jobs
            if j in _jobs
                edges = [e for e in graph if e[2] == j]

                @constraint(model, sum(x[i, j1] for (i, j1) in edges) == 1)

            end
        end

        # ograniczenie numer 2 (zrelaksowane ograniczenia czasowe) - ograniczenia czasowe dla pewnego podzbioru maszyn M'
        for i in _machines
            edges = [e for e in graph if e[1] == i]

            @constraint(model, sum(ConsumptionsArray[i1, j]*x[i1, j] for (i1, j) in edges) <= CapacitiesArray[i])
        end

        optimize!(model)

        # Pobieram status
        status = termination_status(model)

        if status != MOI.OPTIMAL
            # Jeśli nie udało się znaleźć punktu ekstremalnego, to kończę (nie mogę iść dalej)
            println("> Nie znaleziono rozwiązania optymalnego zadania programowania liniowego - przerywam działanie !")
            break
        else
            iterations_counter += 1
            
            extreme_point = value.(x)
            
            # Usuwam zmienne, które mają wartość 0
            filter!(((i, j),) -> extreme_point[i, j] != 0, graph)

            _jobs_length = length(_jobs)

            # Szukam zmiennych równych 1
            for i in machines
                for j in jobs

                    if abs(extreme_point[i, j] - 1.0) <= eps(Float64)
                        
                        # Dodaje krawędź (para maszyna-praca) do przydziału
                        push!(assignment, (i, j))

                        # Usuwam pracę ze zbioru _jobs
                        _jobs = setdiff(_jobs, j)

                        # Aktualizuję obciążenie maszyny
                        CapacitiesArray[i] -= ConsumptionsArray[i, j]
                    
                    end
                end
            end

            progress[iterations_counter] = _jobs_length - length(_jobs)

            machines_to_remove = []

            # Usuwam maszyny, których stopień jest równy 1 albo równy 2 i suma w wierszu jest >= 1
            for _i in _machines
                
                deg = length([e for e in graph if e[1] == _i])

                if deg == 1 || (deg == 2 && sum(extreme_point[_i, _j] for _j in  _jobs) >= 1)

                    push!(machines_to_remove, _i)
                
                end
            end

            _machines = setdiff(_machines, machines_to_remove)
                    
        end
    
    end

    return assignment, iterations_counter, progress

end

# Funkcja do wyświetlania znalezionego rozwiązania
function display_solution(Assignment::Array{Tuple{Int, Int}}, Costs::Array{Int}, Consumptions::Array{Int}, Capacities::Array{Int}, 
    IterationsCount::Int)
    assignment_cost = 0

    if length(Assignment) == 0
        println("Nie znaleziono przydziału zadań !")
        return
    end

    m, n = size(Costs)

    # Sortowanie
    sort!(Assignment, by=x->x[2])

    # Wykrywanie błędów - algorytm jest 2-aproksymacyjny
    if [x[2] for x in Assignment] != [i for i in 1:n]
        println("**** Błąd ! - złe przypisanie prac do maszyn. ****")
    end

    for edge in Assignment
        machine, job = edge

        assignment_cost += Costs[machine, job]

        println("$job -----> $machine")
    end

    println("Koszt przydziału dla tego zadania: $assignment_cost")

    times_for_machines = [0 for i in 1:m]

    for edge in Assignment
        machine, job = edge

        times_for_machines[machine] += Consumptions[machine, job]
    end

    for i in 1:m

        if (times_for_machines[i]/Capacities[i]) <= 2.0
            println("Ok - Czas na wykonanie zadań na maszynie $i: $(times_for_machines[i]) ; dopuszczalny czas: $(Capacities[i]) ; stosunek: $(times_for_machines[i]/Capacities[i])")
        else
            println("Błąd ! - Czas na wykonanie zadań na maszynie $i: $(times_for_machines[i]) ; dopuszczalny czas: $(Capacities[i]) ; stosunek: $(times_for_machines[i]/Capacities[i])")
        end

    end

    println("Liczba iteracji potrzebnych do uzyskania rozwiązania: $IterationsCount")

    time_rations = [times_for_machines[i]/Capacities[i] for i in 1:m]

    return assignment_cost, maximum(time_rations)

end

# Funkcja do testowania na plikach z danymi testowymi
function run()
    Costs, Consumptions, Capacities = open_and_parse_file()

    println("> Dane z pliku testowego wczytano pomyślnie !")

    number_of_test_cases = length(Costs)

    println("> Liczba przypadków testowych w pliku: $number_of_test_cases")

    for i in 1:number_of_test_cases
        CapacitiesCopy = copy(Capacities[i])

        assignment_edges, iterations_count, _ = gap(Costs[i], Consumptions[i], Capacities[i])

        println("------ WYNIKI DLA PRZYPADKU $i ------")
        _, _ = display_solution(assignment_edges, Costs[i], Consumptions[i], CapacitiesCopy, iterations_count)
        
        println("----------")
        println("----------")

    end

end

run()