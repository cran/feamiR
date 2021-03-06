#' feamiR: Classification and feature selection for microRNA/mRNA interactions
#'
#' The feamiR package provides two categories of functions:
#' Dataset preparation functions and analysis functions
#'
#' @section Dataset preparation functions:
#' feamiR uses 1 preparation function called preparedataset.
#' There are 2 options for the input mRNA dataset:
#' 1. Reference genome (fasta) and corresponding annotation file (gtf). From these files, the three prime UTR sequences will be extracted for alignment. These paths for these files could be for example a toplevel file and annotation file from Ensembl (e.g. Homo_sapiens.GRCh38.dna.toplevel.fa and Homo_sapiens.GRCh38.100.chr.gtf). Before using this form of input check consistent naming of chromosomes between the two files and that the IDs are consistent with the interactions file you intend to use (e.g. using gene names). These files should be specificed using the fullchromosomes and annotations parameters. If this type of data is supplied you must also specify the number of chromosomes for the species in question (e.g. 23 for Homo sapiens) using the chr parameter.
#' 2. Three prime UTR file (fasta). Again check consistent IDs with interactions file. This file should be specified using the mRNA_3pUTR parameter.
#'
#' The input miRNA file should be a fasta file containing mature miRNA sequences (e.g. from miRBase). Check the miRNA IDs are consistent with the interaction dataset. From the mature sequences, the seed sequences will be extracted and saved to a separate fasta file.
#'
#' The mRNA and miRNA datasets will be used for PaTMaN alignment then split into a positive dataset (validated interactions) and negative dataset (non-validated interactions with seed matches). For reformating and PaTMaN alignment both sreformat and patman must be installed and the paths to the executables specificied with sreformatpath and patmanpath. If the commands sreformat and patman work on your system then there is no need to specify the path.
#'
#' To perform this split an interaction dataset must be supplied. This interaction dataset must contain a 'miRNA' column, 'Target Gene' column. It can also contain an Experiments column detailing which type of experiment was used to validate the interaction. If this column is supplied some preprocessing should be performed so there are <=10 unique values. If the Experiments column is supplied, statistical analysis is performed on the dataset split by experiment type. Finally a 'Support Type' column may be included with values 'Functional MTI','Functional MTI (Weak)','Non-Functional MTI' and 'Non-Functional MTI (Weak)'. If this column is supplied and there are enough positive entries remaining then they will be filtered for only 'Functional MTI' entries (these entries are more likely to yield good results).
#'
#' After alignment, first statistical analysis is performed. By default this is only on seed features but if specified using the nonseed_miRNA and flankingmRNA parameters then analysis can be performed on full miRNA features and flanking features. The chi-squared and Fisher exact p-values are saved in csvs and heatmaps created and saved as jpgs. If Experiments column is supplied in interactions dataset then statistical analysis is performed for the dataset split by experiment type.
#'
#' Finally, the negative set is subsampled to be comparable to the positive set for the ML and feature selection component. Here 100 representative subsamples (checked by chi-squared tests) and created and labelled (1 if positive, 0 if negative) subsamples are saved in a subsamples folder.
#'
#' By supplying the positive and negative sets using positiveset and negativeset parameters, the process skips straight to the statistical analysis stage but this should only be done with positive and negative sets created by feamiR (although they can be filtered if column names are unchanged)
#'
#' A prefix for all output files can be supplied using the o parameter.
#'
#' PLEASE NOTE: To use this function Python (>=3.6) must be installed on your system and the path specified. The following libraries must also be installed on the Python version you specify: os, Bio, gtfparse, pandas, numpy, math, scipy.stats, matplotlib.pyplot, seaborn as sns, statistics, logging.
#'
#' @section ML and feature selection functions:
#' Using subsamples created by the preparedataset function, feamiR contains several function for creating miRNA/mRNA classifiers and selecting features which contribute most strongly to the classifiers.
#'
#' The classifier functions are: decisiontree, randomforest and svm.
#' To select hyperparameters for randomforest and svm, you should use selectsvmkernel and selectrfnumtrees. This functions will produce plots through cross validation from which an appropriate number of trees and kernel can be identified. You should try this on multiple subsamples to check your selection.
#'
#' Once these hyperparameters are identified, use runallmodels to create and analyse results from Decision Trees, Random Forests and SVMs on all 100 subsamples. The selected hyperparameters using selectsvmkernel and selectrfnumtrees should be input as parameters. The function will output a data.frame of the achieved test and training accuracy, sensitivity and specificity for each model on each subsample. Summary boxplots showing accuracy, sensitivity and specificity for each model will be produced. The function will also output dtreevote containing the features used in the decision trees for each subsample and the level of the tree at which they appear. Finally, the function outputs ongoingginis which contains the Gini index for each feature in the Random Forest for each subsample. The first column of dtreevote contains the number of runs for which each feature was used which can be used for feature selection. The first column of ongoingginis contains the cumulative Gini index for each feature across the 100 runs which can be used for feature selection.
#'
#' As well as using the Decision Tree voting scheme and Random Forest cumulative Gini index measure, feamiR also has three further feature selection approaches. These are the traditional forwardfeatureselection and geneticalgorithm approaches as well as a novel approach based on embryonic Genetic Algorithms using the eGA function.
#' It is recommended that a combination of these feature selection appraoches across multiple subsamples and the statistical analysis is used to select discriminative features, for example using summary heatmaps.
#'
#' @docType package
#' @name feamiR
NULL
#> NULL
