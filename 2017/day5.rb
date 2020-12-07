def traverse(arr, steps = 0, location = 0)
  loop do
    value = arr[location]
    arr[location] > 2 ? (arr[location] -= 1) : (arr[location] += 1)
    location += value
    steps += 1
    break if (location < 0) || location > (arr.length - 1)
  end
  steps
end

