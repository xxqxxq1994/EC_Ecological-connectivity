# 加载库
library(readxl)

# 读取Excel文件
data <- read_excel("ARG-summary.xlsx")

# 提取每个细菌的ARG集合
bacteria_names <- unique(data$Host)
arg_lists <- split(data$ARG_Type_Subtype, data$Host)

# 定义计算两个细菌之间的resistome JI值的函数
calculate_jaccard_index <- function(resistome_A, resistome_B, consider_quantity = FALSE) {
  if (consider_quantity) {
    intersection <- sum(sapply(unique(resistome_A), function(gene) {
      min(sum(resistome_A == gene), sum(resistome_B == gene))
    }))
    union <- sum(sapply(unique(c(resistome_A, resistome_B)), function(gene) {
      max(sum(resistome_A == gene), sum(resistome_B == gene))
    }))
  } else {
    intersection <- length(intersect(resistome_A, resistome_B))
    union <- length(union(resistome_A, resistome_B))
  }
  
  return(intersection / union)
}

# 读取sharing_pair.txt文件
sharing_pairs <- read.table("sharing_pair.txt", header = FALSE, sep = "\t", stringsAsFactors = FALSE)

# 检查sharing_pairs是否包含数据
# Check if sharing_pairs contains data
if (nrow(sharing_pairs) > 0) {
  # Calculate JI values for specific pairs
  result <- data.frame(JI_no_quantity = rep(NA, nrow(sharing_pairs)),
                       JI_with_quantity = rep(NA, nrow(sharing_pairs)))
  
  for (i in 1:nrow(sharing_pairs)) {
    bacteria_A <- arg_lists[[sharing_pairs$V1[i]]]
    bacteria_B <- arg_lists[[sharing_pairs$V2[i]]]
    
    result$JI_no_quantity[i] <- calculate_jaccard_index(bacteria_A, bacteria_B, consider_quantity = FALSE)
    result$JI_with_quantity[i] <- calculate_jaccard_index(bacteria_A, bacteria_B, consider_quantity = TRUE)
  }
  
  # Output the results
  print(result)
} else {
  print("No pairs found in sharing_pair.txt")
}
write.table(result,file = "resistome-JI-share-pair.txt", sep = "\t")

JI_data <- read.table("P1P2JI_no_quantity-ARG.txt", header = TRUE, sep = "\t")
library(ggplot2)
install.packages("extrafont")
library(extrafont)
# 创建热图
p <- ggplot(JI_data, aes(x = P1, y = P2, fill = JI_no_quantity)) +
  geom_tile() +
  #geom_text(aes(label = ifelse(!is.na(JI_no_quantity), sprintf("%.2f", JI_no_quantity), "")), size = 2.5, color = "black", family = "Times New Roman") +
  scale_fill_gradient(name = "JI value", low = "#008F00", high = "#FF7E79", na.value = "white") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, family = "Times New Roman"),
        axis.text.y = element_text(family = "Times New Roman"),
        axis.title = element_text(family = "Times New Roman", face = "bold", size = 18),
        plot.title = element_text(family = "Times New Roman", face = "bold", size = 18),
        panel.grid.major = element_blank(), # Remove major grid lines
        panel.grid.minor = element_blank()) + # Remove minor grid lines
  labs(x = "Strain", y = "Strain", title = "Jaccard Index of Resistome Between Sharing Pairs")

# 保存热图到文件
pdf("jaccard_heatmap_resistome.pdf", width = 9, height = 7)
print(p)
dev.off()
