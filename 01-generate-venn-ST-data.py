filename = "ST-899-data.txt"
output_filename = "01-out-count-st-inter-niche.txt"

niche_sequence_types = {}

with open(filename, "r", encoding="utf-8") as file:
    next(file)  # 跳过第一行（标题行）
    for line in file:
        data = line.strip().split("\t")
        niche = data[1]
        sequence_type = data[3]

        if niche not in niche_sequence_types:
            niche_sequence_types[niche] = set()

        niche_sequence_types[niche].add(sequence_type)

intersections = {}
unions = set()
total_intersection = set()

first_niche = True
for niche, sequence_types in niche_sequence_types.items():
    if first_niche:
        total_intersection = sequence_types.copy()
        first_niche = False
    else:
        total_intersection.intersection_update(sequence_types)

    for niche_2, sequence_types_2 in niche_sequence_types.items():
        if niche != niche_2:
            pair = frozenset([niche, niche_2])
            if pair not in intersections:
                intersections[pair] = sequence_types.intersection(sequence_types_2)
                unions = unions.union(sequence_types, sequence_types_2)

with open(output_filename, "w", encoding="utf-8") as file:
    for pair, intersection in intersections.items():
        niches = ", ".join(pair)
        file.write(f"{niches}交集:\n")
        file.write(f"  检测到的Sequence_type数量: {len(intersection)}\n")
        file.write(f"  类型: {', '.join(intersection)}\n")
        file.write("\n")

    file.write("所有Niche并集:\n")
    file.write(f"  检测到的Sequence_type数量: {len(unions)}\n")
    file.write(f"  类型: {', '.join(unions)}\n")

    file.write("\n所有Niche总交集:\n")
    file.write(f"  检测到的Sequence_type数量: {len(total_intersection)}\n")
    file.write(f"  类型: {', '.join(total_intersection)}\n")
