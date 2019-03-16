version 1.0
# -------------------------------------------------------------------------------------------------
# Package Name: BedTools BamToFastq
# Task Summary: Conversion utility for extracting FASTQ records from sequence alignments in BAM format
# Tool Name: bedtools bamtofastq
# Documentation: https://bedtools.readthedocs.io/en/latest/content/tools/bamtofastq.html
# -------------------------------------------------------------------------------------------------


task BamToFastQ {
  input {
    File bedtools
    File bam_file
    File bam_idx_file

    String fastq1
    String ? fastq2

    Int ? memory
    Int ? cpu
  }

  command {
    ${bedtools} bamtofastq \
      -i ${bam_file} \
      -fq ${fastq1} \
      ${"-fq2 " + fastq2} \
  }

  output {
    File fastq1 = "${fastq1}"
    File ? fastq2 = "${fastq2}"
  }

  runtime {
    memory: select_first([memory, 1]) + " GB"
    cpu: select_first([cpu, 1])
  }

  parameter_meta {
    bedtools: "bedtools executable."
    bam_file: "BAM file"
    bam_idx_file: "BAM file index"
    fastq1: "FASTQ for first end"
    fastq2: "FASTQ for second end"
    memory: "GB of RAM to use at runtime."
    cpu: "Number of CPUs to use at runtime."
  }

  meta {
    author: "Michael A. Gonzalez"
    email: "GonzalezMA@email.chop.edu"
    bedtools_version: "2.27.0"
    version: "0.1.0"
  }
}
