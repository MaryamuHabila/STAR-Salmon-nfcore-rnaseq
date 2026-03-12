NXF_OPTS='-Xms20g -Xmx40g'

nextflow run nf-core/rnaseq \
  --input Samplesheet_HAoSMCs.csv \
  -params-file nfcore_params.yml \
  -r 3.22.2 \
  -profile singularity \
  --igenomes_base /tmp \
  -with-dag \
  -with-timeline \
  -with-trace \
  -with-report \
  --outdir results \
  -resume
