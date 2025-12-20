#!/usr/bin/env bash
ssh -o StrictHostKeyChecking=accept-new burst "cd ~/rob6323_go2_project && sbatch --job-name='rob6323_rough_${USER}' --mail-user='${USER}@nyu.edu' train_rough.slurm '$@'"
