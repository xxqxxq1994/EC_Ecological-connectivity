#install.packages("VennDiagram")

# 加载 VennDiagram 包
library(VennDiagram)

# 设置数据集
human_only <- 461
animal_only <- 269
environment_only <- 368
human_animal_env <- 54
human_animal <- 96
human_environment <- 158
animal_environment <- 98

# 绘制Venn图
venn.plot <- draw.triple.venn(
  area1 = human_only,
  area2 = animal_only,
  area3 = environment_only,
  n12 = human_animal,
  n23 = animal_environment,
  n13 = human_environment,
  n123 = human_animal_env,
  category = c("Human", "Animal", "Environment"),
  fill = c("mediumvioletred", "seagreen", "cornflowerblue"),
  lty = "blank",
  cex = 4,
  cat.cex = 4,
  cat.col = c("mediumvioletred", "seagreen", "cornflowerblue")
)

# 保存Venn图到文件
png("plasmid-group_venn.png", width = 16, height = 16, res = 300, bg = "transparent")
grid.draw(venn.plot)
dev.off()
