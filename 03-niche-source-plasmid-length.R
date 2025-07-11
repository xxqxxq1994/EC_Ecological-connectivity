# 导入库
#install.packages("ggridges")
library(ggplot2)
library(ggridges)

# 读取数据
data <- read.table('niche-plasmid-length.txt', header = TRUE, sep = "\t") # 如果是用逗号分隔的文件，请将 sep 参数改为 ","
data2 <- read.table('Plasmid-Length-Source.txt', header = TRUE, sep = "\t")
# 转换数据为长格式
data_long <- stack(data)

# 创建密度图
plot <- ggplot(data_long, aes(x = values, fill = ind)) +
  geom_density(alpha = 0.7) +
  scale_fill_manual(values = c("#CCCCCC", "#EFA70C", "#B094DB")) +
  labs(title = "Plasmid Length Density by Source",
       x = "Plasmid Length (bp)",
       y = "Density",
       fill = "Niche")

plot2 <- ggplot(data2, aes(x = Length, y = Source, fill = Source)) +
  geom_density_ridges(alpha = 0.6) +
  labs(title = "Plasmid Length Ridge Plot by Source",
       x = "Plasmid Length (bp)",
       y = "Source",
       fill = "Source")


plot3 <- ggplot(data_long, aes(x = values, y = ind, fill = ind)) +
  geom_density_ridges(alpha = 0.6) +
  scale_fill_manual(values = c("#CCCCCC", "#EFA70C", "#B094DB")) +
  labs(title = "Plasmid Length Density by Niche",
       x = "Plasmid Length (bp)",
       y = "Niche",
       fill = "Niche")

# 显示图表
print(plot)
print(plot2)
print(plot3)

# 保存图像并设置图像大小
ggsave("density_plot.png", plot, width = 10, height = 6, dpi = 300)
ggsave("density_ridge_plot-source.png", plot2, width = 10, height = 14, dpi = 300)
ggsave("density_ridge_plot-niche.png", plot3, width = 10, height = 8, dpi = 300)
