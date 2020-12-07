file = open('day2.txt')
data = file.readlines()

class Box:
    def __init__(self, dimensions):
        self.length = int(dimensions[0])
        self.width = int(dimensions[1])
        self.height = int(dimensions[2])

    def __str__(self):
        return "{} {} {}".format(self.length, self.width, self.height)

    def surface_area(self):
        return (2 * self.length * self.width) + (2 * self.width * self.height) + (2 * self.height * self.length)

    def area_of_smallest_side(self):
        dimensions = [self.length, self.width, self.height]
        dimensions.sort()
        return dimensions[0] * dimensions[1]

    def wrapping_paper_required(self):
        return self.surface_area() + self.area_of_smallest_side()

    def perimeter_of_smallest_side(self):
        dimensions = [self.length, self.width, self.height]
        dimensions.sort()
        return (dimensions[0] * 2) + (dimensions[1] * 2)

    def volume(self):
        return self.width * self.height * self.length

    def ribbon_required(self):
        return self.volume() + self.perimeter_of_smallest_side()

total_wrapping_paper = 0
total_ribbon = 0

for dimension in data:
    box = Box(dimension.rstrip().split('x'))
    total_wrapping_paper += box.wrapping_paper_required()
    total_ribbon += box.ribbon_required()

print(total_wrapping_paper)
print(total_ribbon)


