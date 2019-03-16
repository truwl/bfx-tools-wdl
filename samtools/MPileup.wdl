version 1.0
# -------------------------------------------------------------------------------------------------
# Package Name: http://www.htslib.org/
# Tool Name: Samtools
# Documentation: http://www.htslib.org/doc/samtools.html
# -------------------------------------------------------------------------------------------------


task MPileup {
  input {
    File samtools
    File reference
    File reference_idx

    Array[File] bam_files
    Array[File] bam_idx_files
    File ? intervals
    String ? userString

    Int ? memory
    Int ? cpu
  }

  command {
    ${samtools} \
      mpileup \
      ${"--reference " + reference} \
      ${userString} \
      ${sep=" " bam_files}
  }

  output {
    File mpileup_file = stdout()
  }

  runtime {
    memory: select_first([memory, 4]) + " GB"
    cpu: select_first([cpu, 1])
  }

  parameter_meta {
    samtools: "Samtools executable."
    reference: "Reference sequence file."
    reference_idx: "Reference sequence index (.fai)."
    bam_files: "Sorted BAM files."
    bam_idx_files: "Sorted BAM index files."
    intervals: "Intervals to focus on."
    userString: "An optional parameter which allows the user to specify additions to the command line at run time."
    memory: "GB of RAM to use at runtime."
    cpu: "Number of CPUs to use at runtime."
  }

  meta {
    author: "Michael A. Gonzalez"
    email: "GonzalezMA@email.chop.edu"
    samtools_version: "1.9"
    version: "0.1.0"
  }
}
