version 1.0
# -------------------------------------------------------------------------------------------------
# Package Name: https://software.broadinstitute.org/gatk/
# Task Summary: Assess sequence coverage by a wide array of metrics, partitioned by sample, read group, or library
# Tool Name: GATK DepthOfCoverage
# Documentation: https://software.broadinstitute.org/gatk/documentation/tooldocs/3.8-0/org_broadinstitute_gatk_tools_walkers_coverage_DepthOfCoverage.php
# Example: https://software.broadinstitute.org/wdl/documentation/article?id=7615
# -------------------------------------------------------------------------------------------------

import "https://raw.githubusercontent.com/genomics-geek/bfx-tools-wdl/master/structs/Resources.wdl"

task DepthOfCoverage {
  input {
    File ? java
    File gatk
    ReferenceFasta reference

    Array[File] intervals
    File ? gene_list

    String sample_id
    Array[File] bam_files
    Array[File] bam_idx_files

    Array[Int] summary_coverage_threshold
    String ? userString

    Int ? memory
    Int ? cpu
  }

  String output_base_filename = sample_id + ".depthOfCoverage"

  command {
    ${default="java" java} \
      -Xmx${default=4 memory}g \
      -jar ${gatk} \
      -T DepthOfCoverage \
      ${default="-omitBaseOutput -omitLocusTable" userString} \
      -R ${reference.reference} \
      ${"-geneList " + gene_list} \
      ${default="15" sep=" " prefix("-ct ", summary_coverage_threshold)} \
      ${sep=" " prefix("-I ", bam_files)} \
      ${sep=" " prefix("--intervals ", intervals)} \
      -o ${output_base_filename}
  }

  output {
    File sample_interval_statistics_file = "${output_base_filename}" + ".sample_interval_statistics"
    File sample_statistics_file = "${output_base_filename}" + ".sample_statistics"
    File sample_summary_file = "${output_base_filename}" + ".sample_summary"
    File sample_interval_summary_file = "${output_base_filename}" + ".sample_interval_summary"
  }

  runtime {
    memory: select_first([memory, 4]) * 1.5 + " GB"
    cpu: select_first([cpu, 1])
  }

  parameter_meta {
    java: "Path to Java."
    gatk: "GATK jar file."
    reference: "ReferenceFasta struct that contains Reference sequence file, index (.fai), and dict (.dict)."
    intervals: "One or more genomic intervals over which to operate."
    gene_list: "Calculate coverage statistics over this list of genes"
    sample_id: "prefix for output files"
    bam_files: "List of Sorted and duplicate marked BAM file"
    bam_idx_files: "List of BAM file index (.bai)"
    summary_coverage_threshold: "Coverage threshold (in percent) for summarizing statistics"
    userString: "An optional parameter which allows the user to specify additions to the command line at run time."
    memory: "GB of RAM to use at runtime."
    cpu: "Number of CPUs to use at runtime."
  }

  meta {
    author: "Michael A. Gonzalez"
    email: "GonzalezMA@email.chop.edu"
    gatk_version: "3.8"
    version: "0.1.0"
  }
}
