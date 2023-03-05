# Błażej Wróbel, 250070, 4. rok, informatyka algorytmiczna, W4N

function solution_matrix_to_int(S)
    n, m = size(S)

    IntMat = zeros(Int64, n, m)

    for i in 1:n
        for j in 1:m
            IntMat[i, j] = floor(Int64, S[i, j])
        end
    end

    return IntMat
end

function get_time_task_pairs(array)
    result = []

    for i in 1:length(array)
        push!(result, (Int64(array[i]), i))
    end

    return sort(result, by = first)
end

function compute_finish_times(S, d)
    n, m = size(S)

    F = zeros(Int64, n, m)

    for i in 1:n
        for j in 1:m
            F[i, j] += S[i, j] + d[i, j]
        end
    end

    return F
end

function print_gantt_diagram(S, d, end_of_last_task)
    n, m = size(S)

    end_of_last_task_int = floor(Int64, end_of_last_task)

    int_solution_matrix = solution_matrix_to_int(S)
    tasks_finish_times = compute_finish_times(int_solution_matrix, d)

    for i in 1:m
        print("P$(i): ")

        tasks_begs = int_solution_matrix[:, i]
        tasks_ends = tasks_finish_times[:, i]

        task_beg_pairs = get_time_task_pairs(tasks_begs)
        task_end_pairs = get_time_task_pairs(tasks_ends)

        last_task_end_time = last(task_end_pairs)[1]

        for j in 1:task_beg_pairs[1][1]
            print("#")
        end

        for j in 1:n
            
            for k in task_beg_pairs[j][1]:task_end_pairs[j][1]-1
                print("$(task_beg_pairs[j][2])")
            end

            if task_end_pairs[j][1] != last_task_end_time
                difference = task_beg_pairs[j + 1][1] - task_end_pairs[j][1]

                for k in 1:difference
                    print("#")
                end
            end
        end

        for j in last(task_end_pairs)[1]:end_of_last_task_int-1
            print("#")
        end

        println()

    end
end
