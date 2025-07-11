setwd("/Users/xuxiaoqing/OneDrive - The University Of Hong Kong/Isolate/002-Ecoli-Genome/Manuscript/")

#install.packages("circlize")
library(circlize)

# Read the data from the file
sharing_pairs <- read.table("sharing_pair_type.txt", header = TRUE, sep = "\t")

# Define colors for Site_sharing
site_sharing_colors <- c("WI-R" = "#AA93EC", "WS-WI-1" = "#3DA6BB", "WS-WI-2" = "#C95A74")

# Define colors for P1 and P2 categories
categories_colors <- c("WI" = "#CC5A99", "River" = "#7393EC", "WS" = "#739399")

# Extract the unique categories from P1 and P2 columns
categories <- unique(c(as.character(sharing_pairs$P1), as.character(sharing_pairs$P2)))

# Assign colors to categories
category_colors <- setNames(rep(categories_colors, each = length(categories) / length(categories_colors)),
                            categories)

# Create a matrix for the links and set the Site_sharing column as the color
links <- as.matrix(sharing_pairs[, c("P1", "P2")])
colnames(links) <- c("from", "to")
rownames(links) <- as.character(sharing_pairs$Site.sharing)
colors <- site_sharing_colors[as.character(sharing_pairs$Site.sharing)]

# Custom panel function for vertical labels with adjusted font size
panel_fun <- function(x, y) {
  sector.name <- get.cell.meta.data("sector.index")
  xlim <- get.cell.meta.data("xlim")
  ylim <- get.cell.meta.data("ylim")
  circlize::circos.text(x = mean(xlim), y = ylim[1], labels = sector.name, facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5), cex = 3, font = 2) # Adjust the 'cex' parameter for font size
}

# Create a new graphics device to save the chord plot as a PNG file
png(filename = "revised-sharing_pair_chordplot.png", width = 60, height = 60, units = "in", res = 200)

# Plot the chord diagram
chordDiagram(links, grid.col = category_colors, col = colors, annotationTrack = "grid", preAllocateTracks = 1, annotationTrackHeight = 0.05)
#circos.trackPlotRegion(track.index = 1, panel.fun = panel_fun, bg.border = NA)

# Add legend for Site_sharing colors
legend("bottom", legend = names(site_sharing_colors), fill = site_sharing_colors, ncol = 3, cex = 10, text.font = 20, inset = c(0.03, 0.03))

# Add legend for categories
#legend("bottom", legend = names(categories_colors), fill = categories_colors, ncol = 3, cex = 3, text.font = 2, inset = c(-5, 0.025))

# Close the graphics device
dev.off()
