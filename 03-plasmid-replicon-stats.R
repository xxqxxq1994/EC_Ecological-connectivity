setwd("/Users/xuxiaoqing/OneDrive - The University Of Hong Kong/Isolate/002-Ecoli-Genome/Manuscript/NC/resubmission/revised-plasmid-figure/")

# 加载所需的库
library(tidyr)
library(dplyr)

# 读取数据
data <- read.delim("revused-plasmid-ARG.txt", header = TRUE, stringsAsFactors = FALSE)

# 将 Plasmidfinder_type 列中的多个复制子分为多行，同时保持其他列属性一致
data_separated <- separate_rows(data, Plasmidfinder_type, sep = ", ")

# 计算独特复制子的数量
unique_plasmids <- unique(data_separated$Plasmidfinder_type)

# 查看独特复制子的数量
num_unique_plasmids <- length(unique_plasmids)
print(num_unique_plasmids)

###################################################################
# 计算每个复制子在每个 Niche 和 Source 中出现的次数
count_result <- data_separated %>%
  group_by(Plasmidfinder_type, Niche, Source) %>%
  summarise(Count = n()) %>%
  ungroup()

# 将结果转换为宽格式，每个 Niche 和 Source 都有一个单独的列
count_result_wide <- count_result %>%
  unite("Niche_Source", Niche, Source) %>%
  spread(Niche_Source, Count, fill = 0)

# 查看结果
print(count_result_wide)
write.table(count_result_wide, file = "replicon_stats_niche_source.txt", sep = "\t")

###################################################################
# 计算每个复制子所在的质粒的不同 Conj_type 的数量
count_conj_type <- data_separated %>%
  group_by(Plasmidfinder_type, Conj_type) %>%
  summarise(Count = n()) %>%
  ungroup()

# 计算每个复制子的总数量
total_counts <- count_conj_type %>%
  group_by(Plasmidfinder_type) %>%
  summarise(Total = sum(Count)) %>%
  ungroup()

# 计算每个 Conj_type 的比例
conj_type_ratios <- count_conj_type %>%
  left_join(total_counts, by = "Plasmidfinder_type") %>%
  mutate(Ratio = Count / Total) %>%
  select(-Count, -Total)

# 将结果转换为宽格式，每个 Conj_type 都有一个单独的列
conj_type_ratios_wide <- conj_type_ratios %>%
  spread(Conj_type, Ratio, fill = 0)

# 查看结果
print(conj_type_ratios_wide)
write.table(conj_type_ratios_wide, file = "replicon-conj_ratio.txt", sep = "\t")

####################################################################
# 计算每个复制子成环与否的数量
count_circular <- data_separated %>%
  group_by(Plasmidfinder_type, Circular) %>%
  summarise(Count = n()) %>%
  ungroup()

# 计算每个复制子的总数量
total_counts <- count_circular %>%
  group_by(Plasmidfinder_type) %>%
  summarise(Total = sum(Count)) %>%
  ungroup()

# 计算成环与否的比例
circular_ratios <- count_circular %>%
  left_join(total_counts, by = "Plasmidfinder_type") %>%
  mutate(Ratio = Count / Total) %>%
  select(-Count, -Total)

# 将结果转换为宽格式，每个 Circular 类型都有一个单独的列
circular_ratios_wide <- circular_ratios %>%
  spread(Circular, Ratio, fill = 0)

# 查看结果
print(circular_ratios_wide)
write.table(circular_ratios_wide, file = "replicon-cir_ratio.txt", sep = "\t")

##########################################################################
# 提取复制子和拷贝数
replicon_copy_numbers <- data_separated %>%
  select(Plasmidfinder_type, Copy_number)

# 将结果转换为宽格式，每个复制子都有一个单独的列
replicon_copy_numbers_wide <- replicon_copy_numbers %>%
  group_by(Plasmidfinder_type) %>%
  mutate(row_number = row_number()) %>%
  spread(Plasmidfinder_type, Copy_number) %>%
  select(-row_number)

# 查看结果
print(replicon_copy_numbers_wide)
write.table(replicon_copy_numbers_wide, file = "replicon-copy_num.txt", sep = "\t")

##############################################################################
# 分割 ARG_Type_Subtype 列
replicon_ARG_types <- data_separated %>%
  select(Plasmidfinder_type, ARG_Type_Subtype) %>%
  mutate(ARG_Split = str_split(ARG_Type_Subtype, ", ")) %>%  # 按逗号和空格分割
  unnest(ARG_Split) %>%  # 展开列表列
  mutate(ARG_Type = str_extract(ARG_Split, "^[^_]+")) %>%  # 提取每个条目的类型
  select(-ARG_Type_Subtype, -ARG_Split)

# 计算每个复制子携带 ARG 类型的数量
count_ARG_types <- replicon_ARG_types %>%
  group_by(Plasmidfinder_type, ARG_Type) %>%
  summarise(Count = n()) %>%
  ungroup()

# 将结果转换为宽格式，每个复制子都有一个单独的行
ARG_counts_wide <- count_ARG_types %>%
  spread(ARG_Type, Count, fill = 0) %>%
  group_by(Plasmidfinder_type) %>%
  summarise_all(sum, na.rm = TRUE)

# 查看结果
print(ARG_counts_wide)
write.table(ARG_counts_wide, file = "revised-replicon-ARG-stats.txt", sep = "\t")

###########################################################################
# 提取复制子和 ARG Subtype
replicon_ARG_subtypes <- data_separated %>%
  select(Plasmidfinder_type, ARG_Type_Subtype)

# 拆分逗号分隔的 Subtype
replicon_ARG_subtypes_split <- replicon_ARG_subtypes %>%
  separate_rows(ARG_Type_Subtype, sep = ", ")

# 删除空值
replicon_ARG_subtypes_split <- replicon_ARG_subtypes_split %>%
  filter(ARG_Type_Subtype != "")

# 计算每个复制子携带的含有值的 ARG Subtype 总数
count_ARG_subtypes <- replicon_ARG_subtypes_split %>%
  group_by(Plasmidfinder_type) %>%
  summarise(Total_Subtypes = n())

# 查看结果
print(count_ARG_subtypes)

##############################
# 提取复制子和 ARG Subtype
replicon_ARG_subtypes <- data_separated %>%
  select(Plasmidfinder_type, ARG_Type_Subtype)

# 拆分逗号分隔的 Subtype
replicon_ARG_subtypes_split <- replicon_ARG_subtypes %>%
  separate_rows(ARG_Type_Subtype, sep = ", ")

# 删除空值
replicon_ARG_subtypes_split <- replicon_ARG_subtypes_split %>%
  filter(ARG_Type_Subtype != "")

# 计算每个复制子携带的含有值的 ARG Subtype 总数
count_ARG_subtypes <- replicon_ARG_subtypes_split %>%
  group_by(Plasmidfinder_type) %>%
  summarise(Total_Subtypes = n()) %>%
  ungroup()

# 获取所有复制子的列表
all_replicons <- unique(data_separated$Plasmidfinder_type)

# 将没有 ARG 的复制子添加到结果中，并将数量设为 0
count_ARG_subtypes_complete <- data.frame(Plasmidfinder_type = all_replicons,
                                          Total_Subtypes = 0)

count_ARG_subtypes_complete <- count_ARG_subtypes_complete %>%
  left_join(count_ARG_subtypes, by = "Plasmidfinder_type", suffix = c("_old", "")) %>%
  mutate(Total_Subtypes = ifelse(is.na(Total_Subtypes), Total_Subtypes_old, Total_Subtypes)) %>%
  select(-Total_Subtypes_old)

# 查看结果
print(count_ARG_subtypes_complete)
write.table(count_ARG_subtypes_complete, file = "replicon-ARG-subtype-number.txt", sep = "\t")

###################################################################################
# 提取 Replicon 和 carrying_VF_num
replicon_VF_num <- data_separated %>%
  select(Plasmidfinder_type, carrying_VF_num)

# 计算每个 Replicon 携带的 VF 总数
count_VF_num <- replicon_VF_num %>%
  group_by(Plasmidfinder_type) %>%
  summarise(Total_VF = sum(carrying_VF_num, na.rm = TRUE)) %>%
  ungroup()

# 获取所有 Replicon 的列表
all_replicons <- unique(data_separated$Plasmidfinder_type)

# 将没有 VF 的 Replicon 添加到结果中，并将数量设为 0
count_VF_num_complete <- data.frame(Plasmidfinder_type = all_replicons,
                                    Total_VF = 0)

count_VF_num_complete <- count_VF_num_complete %>%
  left_join(count_VF_num, by = "Plasmidfinder_type", suffix = c("_old", "")) %>%
  mutate(Total_VF = ifelse(is.na(Total_VF), Total_VF_old, Total_VF)) %>%
  select(-Total_VF_old)

# 查看结果
print(count_VF_num_complete)
write.table(count_VF_num_complete, file = "replicon-VF-number.txt", sep = "\t")
##############################################################################
# 提取复制子和拷贝数
replicon_length <- data_separated %>%
  select(Plasmidfinder_type, Length)

# 将结果转换为宽格式，每个复制子都有一个单独的列
replicon_length_wide <- replicon_length %>%
  group_by(Plasmidfinder_type) %>%
  mutate(row_number = row_number()) %>%
  spread(Plasmidfinder_type, Length) %>%
  select(-row_number)

# 查看结果
print(replicon_length_wide)
write.table(replicon_length_wide, file = "replicon-length.txt", sep = "\t")
################################################################


# 查看结果
print(data_separated)

# 计算每个复制子成环与否的数量
count_selection <- data_separated %>%
  group_by(Plasmidfinder_type, Selection) %>%
  summarise(Count = n()) %>%
  ungroup()

# 计算每个复制子的总数量
total_counts <- count_selection %>%
  group_by(Plasmidfinder_type) %>%
  summarise(Total = sum(Count)) %>%
  ungroup()

# 计算成环与否的比例
selection_ratios <- count_selection %>%
  left_join(total_counts, by = "Plasmidfinder_type") %>%
  mutate(Ratio = Count / Total) %>%
  select(-Count, -Total)

# 将结果转换为宽格式，每个 Circular 类型都有一个单独的列
selection_ratios_wide <- selection_ratios %>%
  spread(Selection, Ratio, fill = 0)

# 查看结果
print(selection_ratios_wide)
write.table(selection_ratios_wide, file = "replicon-select_ratio.txt", sep = "\t")
