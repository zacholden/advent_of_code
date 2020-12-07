file = open('day5.txt')
data = file.readlines()

total = 0

VOWELS = ['a', 'e', 'i', 'o', 'u']
BAD_PATTERNS = ['ab', 'cd', 'pq', 'xy']

for i in data:
    string = i.rstrip()

    vowels = 0
    for char in string:
        if char in VOWELS:
            vowels += 1

    if vowels < 3:
        continue

    repeat = False
    for string_index in range(len(string) - 1):
        if string[string_index] == string[string_index + 1]:
            repeat = True
            break

    if not repeat:
        continue

    bad_pattern = False
    for pattern in BAD_PATTERNS:
        if pattern in string:
            bad_pattern = True
            break

    if bad_pattern:
        continue

    total += 1


print(total)

for i in data:
    string = i.rstrip()

    for index in range(len(string) - 1):
        print(string)
