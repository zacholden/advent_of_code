file = open('day1.txt', 'r')
data = file.read()

total = 0

for i in data:
    if i == "(":
        total += 1
    else:
        total -= 1

print(total)

total = 0


for i in range(len(data)):
    if data[i] == "(":
        total += 1
    else:
        total -= 1

    if total == -1:
        print(i + 1)
        break

