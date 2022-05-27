defmodule Day7 do
  @input File.read!("day7.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn str ->
           String.replace(str, "Step ", "")
           |> String.replace(" can begin.", "")
           |> String.split(" must be finished before step ")
         end)

  def part1 do
    jobs = Enum.flat_map(@input, & &1) |> Enum.uniq()

    requirements =
      Enum.reduce(@input, %{}, fn [requirement, job], acc ->
        Map.update(acc, job, [requirement], fn existing_value ->
          [requirement | existing_value]
        end)
      end)

    job_queue = (jobs -- Map.keys(requirements)) |> Enum.sort()

    traverse(job_queue, requirements, "")
  end

  def traverse([head | tail], requirements, result) do
    new_requirements =
      Stream.map(requirements, fn {k, v} -> {k, Enum.reject(v, &(&1 == head))} end)
      |> Stream.filter(fn {_k, v} -> Enum.any?(v) end)
      |> Enum.into(%{})

    job_queue = ((Map.keys(requirements) -- Map.keys(new_requirements)) ++ tail) |> Enum.sort()

    traverse(job_queue, new_requirements, result <> head)
  end

  def traverse([], _, result), do: result

  # Had a hard time here iterating over multiple data structures and updating both
  def part2 do
    # job_scores = ?A..?Z |> Enum.map(fn i -> {List.to_string([i]), i - 64} end) |> Map.new()
    job_scores = ?A..?Z |> Enum.map(fn i -> {List.to_string([i]), i - 4} end) |> Map.new()

    jobs = Enum.flat_map(@input, & &1) |> Enum.uniq()

    requirements =
      Enum.reduce(@input, %{}, fn [requirement, job], acc ->
        Map.update(acc, job, [requirement], fn existing_value ->
          [requirement | existing_value]
        end)
      end)

    job_queue = (jobs -- Map.keys(requirements)) |> Enum.sort()

    tick(
      job_queue,
      requirements,
      0,
      Enum.map(1..5, fn id -> %{id: id, job: nil, time: nil} end),
      job_scores,
      "",
      false
    )
  end

  def tick(_queue, _requirements, seconds, _workers, _job_scores, _result, true), do: seconds

  def tick(job_queue, requirements, seconds, workers, job_scores, result, false) do
    {updated_queue, updated_workers} =
      Enum.reduce_while(job_queue, {job_queue, workers}, fn job, {queue, workers} ->
        worker_with_new_job = Enum.find(workers, fn worker -> is_nil(worker.job) end)

        if worker_with_new_job do
          updated_workers =
            Enum.map(workers, fn worker ->
              if worker.id == worker_with_new_job.id,
                do: %{worker | job: job, time: 0},
                else: worker
            end)

          {:cont, {Enum.reject(queue, &(&1 == job)), updated_workers}}
        else
          {:halt, {job_queue, workers}}
        end
      end)

    updated_workers_again =
      Enum.map(updated_workers, fn worker ->
        if worker.job, do: Map.update!(worker, :time, &(&1 + 1)), else: worker
      end)

    {updated_workers_again_2, updated_result} =
      Enum.reduce(updated_workers_again, {updated_workers_again, result}, fn worker,
                                                                             {workers, result} ->
        if worker.job && job_scores[worker.job] == worker.time do
          workers =
            Enum.map(workers, fn inner_worker ->
              if worker.id == inner_worker.id,
                do: %{inner_worker | job: nil, time: nil},
                else: inner_worker
            end)

          result = result <> worker.job
          {workers, result}
        else
          {workers, result}
        end
      end)

    new_requirements =
      Enum.map(requirements, fn {k, v} ->
        {k, Enum.reject(v, fn char -> String.contains?(updated_result, char) end)}
      end)
      |> Enum.filter(fn {_k, v} -> Enum.any?(v) end)
      |> Enum.into(%{})

    updated_queue_2 =
      (updated_queue ++ (Map.keys(requirements) -- Map.keys(new_requirements))) |> Enum.sort()

    done =
      job_queue == [] && requirements == %{} &&
        Enum.all?(updated_workers_again_2, fn worker -> worker.job == nil end)

    tick(
      updated_queue_2,
      new_requirements,
      seconds + 1,
      updated_workers_again_2,
      job_scores,
      updated_result,
      done
    )
  end
end

Day7.part1() |> IO.inspect()
Day7.part2() |> IO.inspect()
