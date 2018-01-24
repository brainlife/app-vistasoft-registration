#!/bin/bash
module load matlab/2017a

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/soft/mason/SPM/spm8'))
mcc -m -R -nodisplay -d compiled main
exit
END
matlab -nodisplay -nosplash -r build