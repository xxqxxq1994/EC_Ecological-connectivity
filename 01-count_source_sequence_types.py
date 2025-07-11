filename = "ST-899-data.txt"
output_filename = "02-out-source-st.txt"

source_sequence_types = {}

with open(filename, "r", encoding="utf-8") as file:
    next(file)  # 跳过第一行（标题行）
    for line in file:
        data = line.strip().split("\t")
        source = data[2]
        sequence_type = data[3]

        if source not in source_sequence_types:
            source_sequence_types[source] = {}

        if sequence_type not in source_sequence_types[source]:
            source_sequence_types[source][sequence_type] = 1
        else:
            source_sequence_types[source][sequence_type] += 1

with open(output_filename, "w", encoding="utf-8") as file:
    for source, sequence_types in source_sequence_types.items():
        file.write(f"{source}:\n")
        file.write(f"  检测到的Sequence_type种类数量: {len(sequence_types)}\n")
        file.write("  各种类型及其次数:\n")
        for sequence_type, count in sequence_types.items():
            file.write(f"    {sequence_type}: {count}次\n")
        file.write("\n")
