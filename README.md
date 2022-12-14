# ptycho
Personal repo for electron ptychography related scripts

-- Chia-Hao Lee @ UIUC

## Contents
- `BatchSubmit.sh`: Shell script that submit multiple sbatch jobs to the camplus cluster through Slurm
- `4hr_2task_V100_runPtycho_template.sbatch`: Template sbatch file used to submit jobs concurrently to cluster GPU node
- `eng_2task_V100_runPtycho_template.sbatch`: Template sbatch file used to submit jobs concurrently to cluster GPU node
- `runPtycho_cc_Themis_${DATE}_${SAMPLE}_{ExpTime}.m`: Template Matlab script used to execute ptycho reconstruction
- `GeneratePtychoScripts.ipynb`: Jupyter notebook that generates all the .sh, .sbatch, and .m in batch to make our life easier

## Dependencies
1. [fold_slice github repo](https://github.com/yijiang1/fold_slice)
2. Matlab with Parallel Computing Toolbox license (either local or remote)
3. Python 3 with jupyter notebook if you want to generate script files in batch

## How to start
- Run `runPtycho_cc_Themis_${DATE}_${SAMPLE}_{ExpTime}.m` script file locally if you have a licensed Matlab installation
- Use the .sbatch and .m to submit jobs to the campus cluster nodes to run remotely
- For batch processing, run `GeneratePtychoScripts.ipynb` with jupyter notebook to generate all the needed scripts in one go
  - Type in `sh BatchSubmit.sh` to run the shell script for batch job submission
