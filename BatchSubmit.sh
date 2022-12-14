for i in $(seq -f "%02g" 11 20); do
echo Submitting 4hr_2task_V100_runPtycho_${i}.sbatch
sbatch 4hr_2task_V100_runPtycho_${i}.sbatch
sleep 1
done
echo "Jobs are all submitted!"
