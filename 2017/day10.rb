def hash(arr, lengths)
  index = 0
  skip_level = 0

  lengths.each do |length|
    arr.rotate!(index)
    arr[0,length] = arr[0,length].reverse
    arr.rotate!(-index)
    
    index = (index + length + skip_level) % arr.length
    skip_level += 1
  end
  arr
end

