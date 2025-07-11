import pandas as pd
from itertools import combinations
from collections import defaultdict
from scipy.spatial.distance import squareform

# 步骤 1：读取距离矩阵（下三角）
df = pd.read_csv("distances.tab", sep="\t", index_col=0)

# 步骤 2：展开下三角为 pairwise 列表
pairs = []
labels = df.index.tolist()
for i in range(len(labels)):
    for j in range(i):
        d = df.iloc[i, j]
        pairs.append((labels[i], labels[j], d))
pair_df = pd.DataFrame(pairs, columns=["Strain1", "Strain2", "Distance"])

# 步骤 3：统计不同阈值下的结果
thresholds = [10, 20, 50, 100]
summary = []

def cluster_count(pairs_subset):
    graph = defaultdict(set)
    for a, b in pairs_subset:
        graph[a].add(b)
        graph[b].add(a)
    visited = set()
    clusters = []
    for node in graph:
        if node not in visited:
            stack = [node]
            cluster = set()
            while stack:
                curr = stack.pop()
                if curr not in visited:
                    visited.add(curr)
                    cluster.add(curr)
                    stack.extend(graph[curr] - visited)
            clusters.append(cluster)
    return clusters

for t in thresholds:
    sub = pair_df[pair_df["Distance"] <= t]
    unique_strains = set(sub["Strain1"]) | set(sub["Strain2"])
    clusters = cluster_count(sub[["Strain1", "Strain2"]].values)
    summary.append({
        "Threshold": t,
        "Num_Pairs": len(sub),
        "Num_Unique_Strains": len(unique_strains),
        "Num_Clusters": len(clusters)
    })

# 输出结果
summary_df = pd.DataFrame(summary)
print(summary_df)

