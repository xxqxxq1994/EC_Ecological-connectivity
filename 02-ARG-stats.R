library(dplyr)
library(tidyr)
library(writexl)
library(readxl)

data <- read_excel("ARG-sum-90-90.xlsx")

# 初始化总数
total_human <- 440
total_animal <- 194
total_environment <- 382

# 计算每个Subtype在每个Niche中的数量
counts <- data %>%
  group_by(Subtype, Type, Niche) %>%
  summarise(count = n()) %>%
  pivot_wider(names_from = Niche, values_from = count, values_fill = 0) # 用0填补缺失值

# 计算比例
counts <- counts %>%
  mutate(
    Proportion_in_Human = Human / total_human,
    Proportion_in_Environment = Environment / total_environment,
    Proportion_in_Animal = Animal / total_animal
  )

# 计算每个 Subtype 在 Plasmid 和 Chromosome 上的数量
contig_counts <- data %>%
  group_by(Subtype, Type, Contig_type) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = Contig_type, values_from = count, values_fill = list(count = 0))

# 查看结果
print(contig_counts)
write_xlsx(counts, "Subtype_Niche_Analysis.xlsx")
write_xlsx(contig_counts, "Niche-ARG-position-stats.xlsx")

# 定义每个 Source 的总数
total_counts_NoR <- c("WWTP-E" = 38, "Pig-I" = 49, "Manhole" = 169, "WWTP-I" = 33, 
                      "Fishing water" = 30, "River" = 42, "BB" = 23, "WWTP-S" = 16, "Marine" = 15)
total_counts_AR <- c("WWTP-I" = 238, "Pig-S" = 11, "River" = 100, "BB" = 6, 
                     "WWTP-S" = 50, "Marine" = 4, "WWTP-E" = 71, "Pig-I" = 115, "Pig-E" = 6)

# 处理 NoR 情况
results_NoR <- data %>%
  filter(Antibiotics == "NoR") %>%
  group_by(Subtype, Type, Source) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = Source, values_from = count, values_fill = list(count = 0)) %>%
  mutate(across(starts_with("WWTP-E"), ~ ./total_counts_NoR["WWTP-E"], .names = "Proportion_{col}"),
         across(starts_with("Pig-I"), ~ ./total_counts_NoR["Pig-I"], .names = "Proportion_{col}"),
         across(starts_with("Manhole"), ~ ./total_counts_NoR["Manhole"], .names = "Proportion_{col}"),
         across(starts_with("WWTP-I"), ~ ./total_counts_NoR["WWTP-I"], .names = "Proportion_{col}"),
         across(starts_with("Fishing water"), ~ ./total_counts_NoR["Fishing water"], .names = "Proportion_{col}"),
         across(starts_with("River"), ~ ./total_counts_NoR["River"], .names = "Proportion_{col}"),
         across(starts_with("BB"), ~ ./total_counts_NoR["BB"], .names = "Proportion_{col}"),
         across(starts_with("WWTP-S"), ~ ./total_counts_NoR["WWTP-S"], .names = "Proportion_{col}"),
         across(starts_with("Marine"), ~ ./total_counts_NoR["Marine"], .names = "Proportion_{col}"))

# 处理 AR 情况
results_AR <- data %>%
  filter(Antibiotics == "AR") %>%
  group_by(Subtype, Type, Source) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = Source, values_from = count, values_fill = list(count = 0)) %>%
  mutate(across(starts_with("WWTP-I"), ~ ./total_counts_AR["WWTP-I"], .names = "Proportion_{col}"),
         across(starts_with("Pig-S"), ~ ./total_counts_AR["Pig-S"], .names = "Proportion_{col}"),
         across(starts_with("River"), ~ ./total_counts_AR["River"], .names = "Proportion_{col}"),
         across(starts_with("BB"), ~ ./total_counts_AR["BB"], .names = "Proportion_{col}"),
         across(starts_with("WWTP-S"), ~ ./total_counts_AR["WWTP-S"], .names = "Proportion_{col}"),
         across(starts_with("Marine"), ~ ./total_counts_AR["Marine"], .names = "Proportion_{col}"),
         across(starts_with("WWTP-E"), ~ ./total_counts_AR["WWTP-E"], .names = "Proportion_{col}"),
         across(starts_with("Pig-I"), ~ ./total_counts_AR["Pig-I"], .names = "Proportion_{col}"),
         across(starts_with("Pig-E"), ~ ./total_counts_AR["Pig-E"], .names = "Proportion_{col}"))

# 查看结果
print(results_NoR)
print(results_AR)

# 保存结果到 Excel 文件
write_xlsx(list(NoR = results_NoR, AR = results_AR), "Subtype_Source_Analysis.xlsx")

# 统计在 Antibiotics 分别为 NoR 和 AR 下，各个 Subtype 在 Plasmid 和 Chromosome 上的数量
subtype_contig_counts <- data %>%
  group_by(Antibiotics, Type, Subtype, Contig_type) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = Contig_type, values_from = count, values_fill = list(count = 0))

# 统计在 Antibiotics 分别为 NoR 和 AR 下，各个 Source 包含的 Subtype 总数及在 Plasmid 和 Chromosome 上的数量
source_contig_counts <- data %>%
  group_by(Antibiotics, Source, Contig_type) %>%
  summarise(subtype_count = n(), .groups = "drop") %>%
  pivot_wider(names_from = Contig_type, values_from = subtype_count, values_fill = list(subtype_count = 0))

# 保存结果到 Excel 文件
write_xlsx(list(Subtype_Contig_Counts = subtype_contig_counts, Source_Contig_Counts = source_contig_counts), "Contig_Analysis2.xlsx")
