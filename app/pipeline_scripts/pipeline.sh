#!/usr/bin/env bash
input=$1
outdir=$2
analysisType=$3  #{single_sample, multiple_samples, RNA_Seq_profiles} # dont add RNA_Seq_profiles and multiple samples
reference_panel=$4  #{GTEx_t_score,ENCODE_z_score}
ratio=$5
p_adjust_method=$6   #p.adjust.method, c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")
#plot_threshold=$7
bindir="/app/pipeline_scripts"
if [ $analysisType = "RNA_Seq_profiles" ]; then
     normalization_method=$7  #{"z-score" and "abundance"}
fi

if [ $analysisType = "single_sample" ]; then
     Rscript --vanilla  ${bindir}/deTS.R ${input} ${outdir} single_sample \
     ${reference_panel} ${ratio} ${p_adjust_method} #${plot_threshold}

fi

if [ $analysisType = "multiple_samples" ]; then
     Rscript --vanilla  ${bindir}/deTS.R ${input} ${outdir} multiple_samples \
     ${reference_panel} ${ratio} ${p_adjust_method} 
fi

if [ $analysisType = "RNA_Seq_profiles" ]; then
     Rscript --vanilla  ${bindir}/deTS.R ${input} ${outdir} RNA_Seq_profiles \
     ${reference_panel} ${ratio} ${p_adjust_method} ${normalization_method}
fi

if [ -f ${outdir}/Tissue_Specific_Enrichment1.txt ] && [ $analysisType = "single_sample" ] ; then
     sed   -i '1d' ${outdir}/Tissue_Specific_Enrichment1.txt
     echo  -e 'Tissue \t p.adjust' > ${outdir}/Tissue_Specific_Enrichment.txt
     cat    ${outdir}/Tissue_Specific_Enrichment1.txt >> ${outdir}/Tissue_Specific_Enrichment.txt
     rm ${outdir}/Tissue_Specific_Enrichment1.txt
    echo " Finished successfully";
   
 elif [ -f ${outdir}/Tissue_Specific_Enrichment1.txt ] && [ $analysisType = "multiple_samples" ] ; then
     header_=($(head -n1 ${outdir}/Tissue_Specific_Enrichment1.txt))
     header_=( "Tissue" ${header_[@]})
     sed   -i '1d' ${outdir}/Tissue_Specific_Enrichment1.txt
     printf '%s\t' ${header_[@]} > ${outdir}/Tissue_Specific_Enrichment.txt
     echo -e "\n" >> ${outdir}/Tissue_Specific_Enrichment.txt
     sed   -i '2d' ${outdir}/Tissue_Specific_Enrichment.txt
     cat    ${outdir}/Tissue_Specific_Enrichment1.txt >> ${outdir}/Tissue_Specific_Enrichment.txt
     rm ${outdir}/Tissue_Specific_Enrichment1.txt
    echo " Finished successfully";  
   
 elif [ -f ${outdir}/Tissue_Specific_Enrichment1.txt ] && [ $analysisType = "RNA_Seq_profiles" ] ; then
      header_=($(head -n1 ${outdir}/Tissue_Specific_Enrichment1.txt))
      header_=( "Tissue" ${header_[@]})
      sed   -i '1d' ${outdir}/Tissue_Specific_Enrichment1.txt
      printf '%s\t' ${header_[@]} > ${outdir}/Tissue_Specific_Enrichment.txt
      echo -e "\n" >> ${outdir}/Tissue_Specific_Enrichment.txt
      sed   -i '2d' ${outdir}/Tissue_Specific_Enrichment.txt
      cat    ${outdir}/Tissue_Specific_Enrichment1.txt >> ${outdir}/Tissue_Specific_Enrichment.txt
      rm ${outdir}/Tissue_Specific_Enrichment1.txt
     echo " Finished successfully";  
    
else
     touch ${outdir}/Tissue_Specific_Enrichment.txt 
     fi
