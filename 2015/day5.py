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

# part 2

total2 = 0

test = ['qjhvhtzxzqqjkmpb', 'xxyxx', 'uurcxstgmygtbstg', 'ieodomkazucvgmuy']

for i in data:
    string = i.rstrip()

    repeating = False
    overlaps = False

    for char in range(len(string) - 2):
        if string[char:char+2] in string[char+2:]:
            repeating = True
            break

    for char in range(len(string) - 2):
        if string[char] == string[char+2]:
            overlaps = True
            break

    if repeating and overlaps:
        total2 += 1

print(total2)
