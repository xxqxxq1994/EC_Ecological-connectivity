library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(ggplot2)

# 读取数据
contig_arg_hgt <- read.table("Contig_Gene_HGT.txt", header = TRUE, stringsAsFactors = FALSE, sep = "\t")
arg_is <- read.table("grep-IS-le-10_output_ARG_flanking.txt", header = FALSE, stringsAsFactors = FALSE)

# 将 Contig 和基因编号分开
contig_arg_hgt <- contig_arg_hgt %>%
  mutate(Contig = str_extract(Contig.gene.ID, ".*(?=_\\d+$)"),
         Gene_Num = as.numeric(str_extract(Contig.gene.ID, "\\d+$")))

arg_is <- arg_is %>%
  mutate(Contig = str_extract(Contig_IS_gene, ".*(?=_\\d+$)"),
         Gene_Num = as.numeric(str_extract(Contig_IS_gene, "\\d+$")))

# 创建要查找的基因编号范围
contig_arg_hgt <- contig_arg_hgt %>%
  mutate(Gene_Range_Start = Gene_Num - 5,
         Gene_Range_End = Gene_Num + 5)

# 查找匹配的基因编号并输出对应的 IS_name
result <- contig_arg_hgt %>%
  mutate(IS_name = map2(Contig, Gene_Num, ~ arg_is$IS_name[arg_is$Contig == .x & arg_is$Gene_Num >= (.y - 5) & arg_is$Gene_Num <= (.y + 5)])) %>%
  select(Gene.ID, Contig.gene.ID, IS_name)

# 将列表类型的列转换为字符类型的列
result$IS_name <- sapply(result$IS_name, paste, collapse = ", ")

# 拆分 IS_name 列并保留 IS 名称的第一部分
result <- result %>%
  separate_rows(IS_name, sep = ", ") %>%
  mutate(IS_name = str_extract(IS_name, "^[^_]*")) 

# 计算每个 Gene.ID 中每种 IS_name 在独特 Contig.gene.ID 中的出现次数
result_IS_counts <- result %>%
  group_by(Gene.ID, IS_name) %>%
  summarise(Count = n_distinct(Contig.gene.ID)) %>%
  ungroup()

# 计算每个 Gene.ID 中的独特 Contig.gene.ID 数量
total_counts <- result %>%
  group_by(Gene.ID) %>%
  summarise(Total = n_distinct(Contig.gene.ID)) %>%
  ungroup()

# 合并 result_IS_counts 和 total_counts，计算 IS 出现的比例
result_final <- result_IS_counts %>%
  left_join(total_counts, by = "Gene.ID") %>%
  mutate(Frequency = Count / Total) %>%
  select(Gene.ID, IS_name, Count, Total, Frequency)

# 查看结果
head(result_final)

# 创建热图
p <- ggplot(result_final, aes(x = Gene.ID, y = IS_name, fill = Frequency)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, family = "Times New Roman"),
        axis.text.y = element_text(family = "Times New Roman"),
        plot.title = element_text(hjust = 0.5, family = "Times New Roman"),
        legend.title=element_text(family="Times New Roman"),
        legend.text=element_text(family="Times New Roman")) +
  labs(x = "Gene.ID", y = "IS_name", fill = "Frequency")
# 显示热图
print(p)

# 将热图保存为文件
ggsave(filename = "CTX-IS-R.png", plot = p, width = 10, height = 10, dpi = 300)


write.table(result_final, file = "revised_freq_heatmap_data_CTX_IS_flanking_result.txt", sep = "\t", row.names = FALSE, quote = FALSE)

library(tidyverse)

# 重新调整结果格式
result_wide <- result_final %>%
  select(IS_name, Gene.ID, Frequency) %>%
  spread(key = Gene.ID, value = Frequency, fill = 0)

# 查看结果
head(result_wide)
write.table(result_wide, file = "wide_revised_freq_heatmap_data_CTX_IS_flanking_result.txt", sep = "\t", row.names = FALSE, quote = FALSE)
