library(deTS)
library(pheatmap)
options(warn=-1)
args = commandArgs(trailingOnly=TRUE)

input_file= args[1]
outdir=as.character(args[2])
analysisType= as.character(args[3])
reference_panel=as.character(args[4])
ratio_arg= as.numeric(args[5])
p_adjust_method = as.character(args[6])
#plot_threshold=as.numeric(args[7])

normalization_method= as.character(args[7])
out_file=paste0(outdir,'/',"Tissue_Specific_Enrichment.txt")
#out_pdf=paste0(outdir,'/',"Tissue_Specific_Enrichment.pdf")
print(args)

#data(reference_panel)
data(list=reference_panel)


## TSEA for gene lists
if ( analysisType == "single_sample"){
      dat = read.table( input_file, head = T)
      query.genes = dat[,1]
      results=tryCatch({tsea_t = tsea.analysis(query_gene_list=query.genes, score=get(reference_panel), 
      ratio = ratio_arg, p.adjust.method =p_adjust_method)},error = function(e){
        stop("Please modify your parameters")
        })
      write.table(tsea_t,out_file)
       #plot_ =tryCatch({
       #pdf(out_pdf, 10, 10, onefile = FALSE)
       # tsea.plot(tsea_t, threshold = plot_threshold) #plot_threshold
       # dev.off()
    },
     error = function(e){
        stop("Error with plotting image")})
## TSEA for multiple gene lists
  } else if ( analysisType == "multiple_samples"){
     dat = read.table(input_file, head = T, row.names = 1)
     query.gene.list = dat
     tsea_t_multi =tryCatch({tsea_t_multi = tsea.analysis.multiple(query_gene_list=query.gene.list, score=get(reference_panel),
     ratio = ratio_arg, p.adjust.method =p_adjust_method)},
     error = function(e){
        stop("Please modify your parameters")})

     write.table(tsea_t_multi,out_file)
    
   # plot_ =tryCatch({
   #     pdf(out_pdf, 10, 10, onefile = FALSE)
   #     tsea.plot(tsea_t_multi, threshold = plot_threshold) #plot_threshold
   #    dev.off()
   # },
   #  error = function(e){
   #     stop("Error with plotting image")})

} else if ( analysisType == "RNA_Seq_profiles"){
## TSEA for RNA-Seq profiles
     dat = read.table(input_file, head = T, row.names = 1)
     query.matrix = dat
     data(correction_factor)
     results=tryCatch({
        query_mat_abundance_nor = tsea.expression.normalization(query.matrix, correction_factor, normalization = normalization_method)
        tseaed = tsea.expression.decode(query_mat_abundance_nor, score=get(reference_panel),
         ratio = ratio_arg, p.adjust.method =p_adjust_method)},
     error = function(e){
        stop("Please modify your parameters")})
    
    write.table(tseaed,out_file)
    #plot_ =tryCatch({
    #    pdf (out_pdf, 10, 10, onefile = FALSE)
    #    tsea.plot(tseaed, threshold = plot_threshold)
    #    dev.off()
    #},
    # error = function(e){
    #    stop("Error with plotting image")})
} else{
    print(" inValid option for the analysisType ")
}
