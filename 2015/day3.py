file = open('day3.txt')
data = file.read()

locations = set()
santa = { "x": 0, "y": 0 }

for i in data:
    locations.add(tuple(santa.values()))
    if i == "^":
        santa['y'] += 1
    elif i == ">":
        santa['x'] += 1
    elif i == "v":
        santa['y'] -= 1
    else:
        santa['x'] -= 1

print(len(locations))

# Part 2
human_santa = { "x": 0, "y": 0 }
robo_santa = { "x": 0, "y": 0 }
locations = set()
container = [human_santa, robo_santa]
turn = 0

for i in data:
    if turn % 2 == 0:
        santa = human_santa
    else:
        santa = robo_santa

    turn += 1

    locations.add(tuple(santa.values()))

    if i == "^":
        santa['y'] += 1
    elif i == ">":
        santa['x'] += 1
    elif i == "v":
        santa['y'] -= 1
    else:
        santa['x'] -= 1


print(len(locations))
