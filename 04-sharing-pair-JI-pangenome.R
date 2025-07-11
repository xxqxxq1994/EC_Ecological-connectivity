library(ggplot2)
#install.packages("reshape2")
library(reshape2)
#install.packages("extrafont")
library(extrafont)

# 注册并加载字体
if (.Platform$OS.type == "windows") {
  loadfonts(device = "win")
} else {
  font_import(paths = NULL, recursive = TRUE, prompt = FALSE)
  loadfonts()
}

# 从文本文件中读取Jaccard指数
jaccard_indices <- read.table("jaccard_indices-pangenome.txt", header = FALSE, sep = " ", stringsAsFactors = FALSE)

# 移除名字中的"-bin"
jaccard_indices$V4 <- gsub("-bin", "", jaccard_indices$V4)
jaccard_indices$V6 <- gsub("-bin:", "", jaccard_indices$V6)

# 将数据转换为矩阵
jaccard_matrix <- dcast(jaccard_indices, V4 ~ V6, value.var = "V7")

# 将数据转换为长格式
jaccard_long <- melt(jaccard_matrix, id.vars = "V4")

# 创建热图
p1 <- ggplot(jaccard_long, aes(x = V4, y = variable, fill = value)) +
  geom_tile() +
  #geom_text(aes(label = ifelse(!is.na(value), sprintf("%.2f", value), "")), size = 2.5, color = "black", family = "Times New Roman") +
  scale_fill_gradient(name = "JI value", low = "blue", high = "red", na.value = "white") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, family = "Times New Roman"),
        axis.text.y = element_text(family = "Times New Roman"),
        axis.title = element_text(family = "Times New Roman", face = "bold", size = 18),
        plot.title = element_text(family = "Times New Roman", face = "bold", size = 18)) +
  labs(x = "Strain", y = "Strain", title = "Jaccard Index of Pangenome Between Sharing Pairs", size = 18)

# 保存热图到文件
pdf("jaccard_heatmap_pangenome.pdf", p1, width = 9, height = 7)
print(p1)
dev.off()
