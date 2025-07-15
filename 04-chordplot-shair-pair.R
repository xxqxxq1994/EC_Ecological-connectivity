#install.packages("circlize")
library(circlize)

# 读取数据
df <- read.table("sharing_pair_type.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# 定义 Site-sharing 类型对应的颜色（用于弦线）
site_sharing_colors <- c(
  "WI-R" = "#AA93EC",
  "WS-WI-1" = "#3DA6BB",
  "WS-WI-2" = "#C95A74"
)

# 初始化节点角色记录
node_roles <- list()

# 遍历每一行，根据 Site-sharing 推断每个节点的类型
for (i in 1:nrow(df)) {
  site_type <- df$Site.sharing[i]
  p1 <- df$P1[i]
  p2 <- df$P2[i]
  
  if (site_type == "WI-R") {
    node_roles[[p1]] <- "WI"
    node_roles[[p2]] <- "River"
  } else if (site_type %in% c("WS-WI-1", "WS-WI-2")) {
    node_roles[[p1]] <- "WS"
    node_roles[[p2]] <- "WI"
  }
}

# 提取所有唯一节点
all_nodes <- unique(c(df$P1, df$P2))

# 给没被明确归类的节点设为 "Other"
node_roles <- lapply(all_nodes, function(n) {
  if (!is.null(node_roles[[n]])) return(node_roles[[n]])
  return("Other")
})
names(node_roles) <- all_nodes

# 定义每类节点的颜色（用于外环）
category_colors <- c("WS" = "#739399", "WI" = "#CC5A99", "River" = "#7393EC")
grid_colors <- category_colors[unlist(node_roles)]
names(grid_colors) <- names(node_roles)

# 指定外环节点排序：先 WS，再 WI，再 River
node_order <- c(
  names(node_roles[unlist(node_roles) == "WS"]),
  names(node_roles[unlist(node_roles) == "WI"]),
  names(node_roles[unlist(node_roles) == "River"])
)

# 清除旧图
circos.clear()

# 绘制外环结构，不画连接线
chordDiagram(df[, c("P1", "P2")],
             grid.col = grid_colors,
             col = NA,
             annotationTrack = "grid",
             preAllocateTracks = 1,
             order = node_order)

# 一条条画弦线，使用 Site-sharing 类型颜色
for (i in 1:nrow(df)) {
  circos.link(
    sector.index1 = df$P1[i], point1 = c(0, 1),
    sector.index2 = df$P2[i], point2 = c(0, 1),
    col = site_sharing_colors[df$Site.sharing[i]],
    border = NA
  )
}

# 设置字体为 Times New Roman（如果系统支持）
par(family = "Times")

# 添加弦线类型图例
legend("bottom", legend = c("Site-sharing Type:", names(site_sharing_colors)),
       fill = c(NA, site_sharing_colors),  # 第一个NA是标题，不配颜色
       horiz = TRUE,
       ncol = length(site_sharing_colors) + 1,
       cex = 0.9,
       bty = "n",
       text.font = 1,
       x.intersp = 0.5)  # 控制文字与色块间距)

# 添加节点来源图例
legend("bottom", legend = names(category_colors),
       fill = category_colors,
       title = "Node Category",
       horiz = TRUE,
       ncol = 3,
       inset = 0.1,  # 设得稍大一些，避免重叠
       cex = 0.9,
       bty = "n",
       text.font = 1)

### === 导出 PDF === ###
pdf("ChordDiagram_TimesNewRoman.pdf", width = 10, height = 10, family = "Times")
circos.clear()
chordDiagram(df[, c("P1", "P2")],
             grid.col = grid_colors,
             col = NA,
             annotationTrack = "grid",
             preAllocateTracks = 1,
             order = node_order)
for (i in 1:nrow(df)) {
  circos.link(df$P1[i], c(0, 1), df$P2[i], c(0, 1),
              col = site_sharing_colors[df$Site.sharing[i]], border = NA)
}
legend("bottom", legend = names(site_sharing_colors),
       fill = site_sharing_colors, title = "Sharing Type",
       horiz = TRUE,
       ncol = 3,  # 可根据类型数量调整列数
       inset = 0.02,
       cex = 0.9,
       bty = "n",
       text.font = 1)
legend("bottom", legend = names(category_colors),
       fill = category_colors,
       title = "Node Category",
       horiz = TRUE,
       ncol = 3,
       inset = 0.05,  # 设得稍大一些，避免重叠
       cex = 0.9,
       bty = "n",
       text.font = 1)
dev.off()
