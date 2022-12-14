#!/bin/bash
###############################################################################
#
#SBATCH --job-name=1115_01                         # Name of batch job, Change this!
#SBATCH --partition=secondary-eth,eng-research-gpu # Partition (queue), eng-research-gpu has 7 V100(16GB)x2 nodes; secondary-eth has eth has 3 V100(32GB)x2 node and 1 P100(12)x4 node
#SBATCH --time=04:00:00                            # Job run time (hh:mm:ss)
#SBATCH --nodes=1                                  # Number of nodes
#SBATCH --ntasks=2                                 # Number of task (cores/ppn) per node, one task per ptycho recon
#SBATCH --cpus-per-task=4                          # Always at least twice the number of GPUs (Four times the number for TITAN and V100)
#SBATCH --gpus-per-task=V100:1                     # Number of gpus per task, specifying V100 is helpful because it's almost 2x faster than P100 
#SBATCH --mem-per-gpu=80GB                         # Specify the needed memory, the default is unlimited but for some reason eng nodes are only requested with 37.5GB and secondary-eth with 114GB
#SBATCH --output=log_job_%x_4hr_%A.txt             # Name of batch job output file
##SBATCH --error=err_%x_4hr_%A.txt                 # Name of batch job error file
##SBATCH --mail-user=NetID@illinois.edu            # Send email notifications
##SBATCH --mail-type=BEGIN,END                     # Type of email notifications to send
#
# UPDATED: 2022/11/15 Chia-Hao Lee, Slurm 22.05                                                                            
###############################################################################

# This works concurrently
# srun --ntasks=1 --cpus-per-task=4 --gpu-bind=single:1 bash -c "sleep 5; echo Task 1; nvidia-smi -L" & 
# srun --ntasks=1 --cpus-per-task=4 --gpu-bind=single:1 bash -c "sleep 5; echo Task 2; nvidia-smi -L" &
# wait

# Clear the value set in the DISPLAY environment variable
# to run the CLI version of MATLAB
unset DISPLAY

# Load MATLAB module (Enable MATLAB in user environment)
module load matlab/9.7 # Only this version has the correct path to nvcc compiler on eng-research-gpu, eth, fdr

echo "Starting job $SLURM_JOB_ID on $HOSTNAME"

# Start 2 tasks concurrently, each take 4 CPU and 1 GPU 
# Note that each node may has different amount of memory
srun --ntasks=1 --cpus-per-task=4 --gpu-bind=single:1 bash -c 'nvidia-smi -L; matlab -logfile <log_file_name_01>.txt -r "<matlab_script_name_01>"' & 
srun --ntasks=1 --cpus-per-task=4 --gpu-bind=single:1 bash -c 'nvidia-smi -L; matlab -logfile <log_file_name_02>.txt -r "<matlab_script_name_02>"' &
wait

# Don't use dash (-) in the <matlab_script_name> because `-r` will fail to recognize the script name. 
# The `.m` file extension is not needed for <matlab_script_name> while using `-r`

# My srun examples
# srun --ntasks=1 --cpus-per-task=4 --gpu-bind=single:1 bash -c 'nvidia-smi -L; matlab -logfile log_runPtycho_STO_Themis_0049_5.txt -r "runPtycho_cc_STO_Themis_0049_5"' & 
# srun --ntasks=1 --cpus-per-task=4 --gpu-bind=single:1 bash -c 'nvidia-smi -L; matlab -logfile log_runPtycho_STO_Themis_0050_5.txt -r "runPtycho_cc_STO_Themis_0050_5"' &

# The ampersand (&) symbol at the end of every srun command is used to run commands simultaneously. 
# It removes the blocking feature of the srun command which makes it interactive but non-blocking. 
# It???s vital to use the wait command when using ampersand to run commands simultaneously. 
# This is because it ensures that a given task doesn???t cancel itself due to the completion of another task or sibling tasks. 
# In other words, without the wait command, task 0 would cancel itself, given task 1, or 2 completed successfully.
