#install.packages("tidyr")
#install.packages("dplyr")
#install.packages("readxl")
install.packages("writexl")
# 导入所需的包
library(tidyr)
library(dplyr)
library(readxl)
library(writexl)

data <- read_excel("sharing-plasmids.xlsx")

# 仅保留cir_group和Length列
data_subset <- data[, c("cir-group", "Length")]

# 使用pivot_wider()将数据转换为宽格式
wide_data <- data_subset %>%
  group_by(`cir-group`) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = `cir-group`, values_from = Length) %>%
  select(-row)

# 将数据写入Excel文件
write_xlsx(wide_data, "../change-23sharinggroups-Sankey-chiplot/P2_length_data.xlsx")

# 仅保留cir_group和copy列
data_subset2 <- data[, c("cir-group", "Copy_number")]

# 使用pivot_wider()将数据转换为宽格式
wide_data2 <- data_subset2 %>%
  group_by(`cir-group`) %>%
  mutate(row = match(Copy_number, Copy_number)) %>%
  pivot_wider(names_from = `cir-group`, values_from = Copy_number) %>%
  select(-row)

# 将数据写入Excel文件
write_xlsx(wide_data2, "../change-23sharinggroups-Sankey-chiplot/P3_copy_data.xlsx")

# 仅保留cir_group和copy列
data_subset3 <- data[, c("cir-group", "ARG_number")]

# 使用pivot_wider()将数据转换为宽格式
wide_data3 <- data_subset3 %>%
  group_by(`cir-group`) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = `cir-group`, values_from = ARG_number) %>%
  select(-row)

# 将数据写入Excel文件
write_xlsx(wide_data3, "../change-23sharinggroups-Sankey-chiplot/P3_ARG_data.xlsx")

phylogroup_summary <- data %>%
  count(Phylogroup, `cir-group`) %>%
  pivot_wider(names_from = Phylogroup, values_from = n, values_fill = 0)

write_xlsx(phylogroup_summary, "../change-23sharinggroups-Sankey-chiplot/P5_phylogroup_data.xlsx")

mob_summary <- data %>%
  count(Conj_type, `cir-group`) %>%
  pivot_wider(names_from = Conj_type, values_from = n, values_fill = 0)

write_xlsx(mob_summary, "../change-23sharinggroups-Sankey-chiplot/P6_mob_data.xlsx")


