#!/usr/bin/env bash
input=$1
outdir=$2
analysisTye=$3  #{single_sample, multiple_samples, RNA_Seq_profiles}
reference_panel=$4  #{GTEx_t_score,ENCODE_z_score}
ratio=$5
p_adjust_method=$6   #p.adjust.method, c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")
#plot_threshold=$7
bindir="/app/scripts"
if [ $analysisTye = "RNA_Seq_profiles" ]; then
     normalization_method=$7  #{"z-score" and "abundance"}
fi

if [ $analysisTye = "single_sample" ]; then
     Rscript --vanilla  ${bindir}/deTS.R ${input} ${outdir} single_sample \
     ${reference_panel} ${ratio} ${p_adjust_method} #${plot_threshold}

fi

if [ $analysisTye = "multiple_samples" ]; then
     Rscript --vanilla  ${bindir}/deTS.R ${input} ${outdir} multiple_samples \
     ${reference_panel} ${ratio} ${p_adjust_method}  ${normalization_method}
fi

if [ $analysisTye = "RNA_Seq_profiles" ]; then
     Rscript --vanilla  ${bindir}/deTS.R ${input} ${outdir} RNA_Seq_profiles \
     ${reference_panel} ${ratio} ${p_adjust_method} ${normalization_method}
fi
if [ -f ${outdir}/Tissue_Specific_Enrichment.txt ]; then
   echo " Finished successfully";
   else
     touch ${outdir}/Tissue_Specific_Enrichment.txt 
     fi
