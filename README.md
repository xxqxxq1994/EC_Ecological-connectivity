# EC_Ecological-connectivity

AMR Data Analysis Scripts

This repository contains scripts used for antimicrobial resistance (AMR)-related genomic analyses, with a focus on ecological connectivity in Escherichia coli. The scripts cover sequence type (ST) sharing, plasmid and ARG feature statistics, resistome and pangenome similarity metrics, mobile genetic element associations, and figure generation. The following is a description of all these files.

## Script Descriptions

01-count_niche_ST.py

This script processes the file ST-899-data.txt to calculate the intersection and union of sequence types (STs) between ecological niches, generating a summary of shared and unique STs between niche pairs.

01-count_source_sequence_types.py

This script summarizes the abundance of STs by ecological source using ST-899-data.txt, producing a source-stratified count table of STs.

01-generate-venn-ST-data.py

This script extracts STs per niche from ST-899-data.txt and prepares group-specific lists for Venn diagram construction.

02-Blastp_hit_Cov_identity.py

This script filters BLASTP alignment results based on user-defined identity and coverage thresholds, using a tab-delimited BLASTP result file and corresponding ORF fasta file. It outputs filtered hits for downstream ARG validation.

02-ARG-stats.R

This script analyzes ARG subtype distributions across different niches and contig types using the file ARG-sum-90-90.xlsx. It computes subtype-level proportions, plasmid versus chromosome distributions, and AR versus NoR profiles, and exports structured Excel summaries.

03-plasmid-replicon-stats.R

This script performs a comprehensive analysis of plasmid replicon-associated features using revused-plasmid-ARG.txt. It generates multiple summary tables for replicon distributions across niche/source, conjugation type, circularity, copy number, ARG/VF content, and length for downstream visualization and statistical modeling.

03-niche-source-plasmid-length.R

This script visualizes plasmid length distributions by niche and source using two input files (niche-plasmid-length.txt and Plasmid-Length-Source.txt) and outputs three plots: a density plot by niche and ridge plots by source and niche.

04-chordplot-shair-pair.R

This script generates a circular chord diagram based on the file sharing_pair_type.txt to visualize strain sharing between sites or compartments, with color coding by sharing group and category.

04-sharing-pair-JI-pangenome.R

This script reads jaccard_indices-pangenome.txt to plot a heatmap of pairwise Jaccard Index values representing gene content similarity (pangenome overlap) between E. coli genomes from different sources.

04-Sharing-pair-JI-resistome-cal-plot.R

This script calculates and visualizes the Jaccard Index of ARG profiles between sharing strain pairs using sharing_pair.txt and ARG-summary.xlsx, reporting both presence/absence-based and abundance-adjusted similarity metrics in heatmap form.

04-stats-cgmlst-distance.py

This script analyzes a lower-triangular cgMLST distance matrix (distances.tab) to compute the number of connected strain pairs and clusters under defined distance thresholds (e.g., 10, 20, 50, 100), producing a summary table of clustering behavior.

05-stats-IS-ARG-final-for-heatmap.R

This script analyzes insertion sequence (IS) elements flanking ARGs (e.g., CTX-type) within ±5 gene windows, based on Contig_Gene_HGT.txt and grep-IS-le-10_output_ARG_flanking.txt. It calculates the frequency of IS–ARG co-occurrence per gene, generates a heatmap of IS associations, and exports both long and wide format result tables.

06-stats-data-sharingplasmids.R

This script processes plasmid sharing group data from sharing-plasmids.xlsx to generate several wide-format summary tables including plasmid length, copy number, ARG number, phylogroup, and conjugation type, suitable for use in Sankey diagrams and other comparative plots.

06-venn-sharedplasmids-group-niche.R

This script uses hardcoded overlap counts to draw a Venn diagram representing shared plasmid groups among human, animal, and environmental niches, with customized colors and layout.



