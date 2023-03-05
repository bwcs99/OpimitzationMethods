#Błażej Wróbel, 250070, 4. rok, W4N, informatyka algorytmiczna

include("z1.jl")
using BenchmarkTools
using DataStructures

# Funkcja do generowania rezultatów dla tabel 1 i 2 ze sprawozdania
# tzn. liczba iteracji, maksymalne przekroczenia, wartości funkcji celu dla przypisania itd.
function generate_results()
    print("> Proszę podać nazwę pliku wynikowego numer 1: ")

    result_file_name = readline()

    print("> Proszę podać nazwę pliku wynikowego numer 2: ")

    result_file_name1 = readline()

    test_files = ["gap$i.txt" for i in 1:12]

    test_files = vcat(test_files, ["gapa.txt", "gapb.txt", "gapc.txt", "gapd.txt"])

    for tf in test_files
        Costs, Consumptions, Capacities = open_and_parse_file(tf)

        number_of_test_cases = length(Costs)

        for i in 1:number_of_test_cases
            m, n = size(Costs[i])

            CapacitiesCopy = copy(Capacities[i])

            instance_name = "c$m$n-$i"

            assignment, iterations_number = nothing, nothing

            dt = @elapsed begin

                assignment, iterations_number, progress = gap(Costs[i], Consumptions[i], Capacities[i])
                
            end

            assignment_cost, maximum_time_ration = display_solution(assignment, Costs[i], Consumptions[i], CapacitiesCopy,
                                                                    iterations_number)

            dt = round(dt, digits=4)
            maximum_time_ration = round(maximum_time_ration, digits=4)

            open("$result_file_name", "a") do f
                write(f, "$instance_name;$dt;$iterations_number;$assignment_cost;$maximum_time_ration\n")
            end

            progress = DataStructures.SortedDict(progress)

            progress_str = "$progress"

            progress_str = replace(progress_str, "SortedDict" => "")
            progress_str = replace(progress_str, "(" => "")
            progress_str = replace(progress_str, ")" => "")
            progress_str = replace(progress_str, "," => "   ")

            open("$result_file_name1", "a") do f
                write(f, "$instance_name;$progress_str \n")
            end

        end
    end
end

# Funkcja do generowania rezultatów przedstawionych na wykresach
# tj. średni czas rozwiązywania zadań oraz średnia liczba iteracji algorytmu
function compute_averages()

    test_files = ["gap$i.txt" for i in 1:12]

    test_files = vcat(test_files, ["gapa.txt", "gapb.txt", "gapc.txt", "gapd.txt"])

    times_for_tasks_number = DefaultOrderedDict{Int, Float64}(0.0)
    number_of_iterations_for_tasks_number = DefaultOrderedDict{Int, Int}(0)

    number_of_tasks_dict = DefaultOrderedDict{Int, Int}(0)

    avg_times = DefaultOrderedDict{Int, Float64}(0.0)
    avg_number_iterations = DefaultOrderedDict{Int, Float64}(0.0)

    for tf in test_files
        Costs, Consumptions, Capacities = open_and_parse_file(tf)

        number_of_test_cases = length(Costs)

        for i in 1:number_of_test_cases
            m, n = size(Costs[i])

            CapacitiesCopy = copy(Capacities[i])

            assignment, iterations_number = nothing, nothing

            dt = @elapsed begin

                assignment, iterations_number, progress = gap(Costs[i], Consumptions[i], Capacities[i])
                
            end

            dt = round(dt, digits=4)

            times_for_tasks_number[n] += dt
            number_of_iterations_for_tasks_number[n] += iterations_number

            number_of_tasks_dict[n] += 1

            println(keys(number_of_tasks_dict))

            for k in keys(number_of_tasks_dict)
                avg_times[k] = times_for_tasks_number[k] / number_of_tasks_dict[k]
                avg_number_iterations[k] = number_of_iterations_for_tasks_number[k] / number_of_tasks_dict[k]
            end

        end
    end

    println("Średnie czasy rozwiązania w zależności od liczby zadań: $avg_times")
    println("Średnie liczby iteracji w zależności od liczby zadań: $avg_number_iterations")

    return avg_times, avg_number_iterations

end