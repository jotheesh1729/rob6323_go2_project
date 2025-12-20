# ROB6323 Go2 Project — Isaac Lab

This repository is the starter code for the NYU Reinforcement Learning and Optimal Control project in which students train a Unitree Go2 walking policy in Isaac Lab starting from a minimal baseline and improve it via reward shaping and robustness strategies. Please read this README fully before starting and follow the exact workflow and naming rules below to ensure your runs integrate correctly with the cluster scripts and grading pipeline.

## Repository policy

- Fork this repository and do not change the repository name in your fork.  
- Your fork must be named rob6323_go2_project so cluster scripts and paths work without modification.

### Prerequisites

- **GitHub Account:** You must have a GitHub account to fork this repository and manage your code. If you do not have one, [sign up here](https://github.com/join).

### Links
1.  **Project Webpage:** [https://machines-in-motion.github.io/RL_class_go2_project/](https://machines-in-motion.github.io/RL_class_go2_project/)
2.  **Project Tutorial:** [https://github.com/machines-in-motion/rob6323_go2_project/blob/master/tutorial/tutorial.md](https://github.com/machines-in-motion/rob6323_go2_project/blob/master/tutorial/tutorial.md)

## Connect to Greene

- Connect to the NYU Greene HPC via SSH; if you are off-campus or not on NYU Wi‑Fi, you must connect through the NYU VPN before SSHing to Greene.  
- The official instructions include example SSH config snippets and commands for greene.hpc.nyu.edu and dtn.hpc.nyu.edu as well as VPN and gateway options: https://sites.google.com/nyu.edu/nyu-hpc/accessing-hpc?authuser=0#h.7t97br4zzvip.

## Clone in $HOME

After logging into Greene, `cd` into your home directory (`cd $HOME`). You must clone your fork into `$HOME` only (not scratch or archive). This ensures subsequent scripts and paths resolve correctly on the cluster. Since this is a private repository, you need to authenticate with GitHub. You have two options:

### Option A: Via VS Code (Recommended)
The easiest way to avoid managing keys manually is to configure **VS Code Remote SSH**. If set up correctly, VS Code forwards your local credentials to the cluster.
- Follow the [NYU HPC VS Code guide](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/vs-code) to set up the connection.

> **Tip:** Once connected to Greene in VS Code, you can clone directly without using the terminal:
> 1. **Sign in to GitHub:** Click the "Accounts" icon (user profile picture) in the bottom-left sidebar. If you aren't signed in, click **"Sign in with GitHub"** and follow the browser prompts to authorize VS Code.
> 2. **Clone the Repo:** Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`), type **Git: Clone**, and select it.
> 3. **Select Destination:** When prompted, select your home directory (`/home/<netid>/`) as the clone location.
>
> For more details, see the [VS Code Version Control Documentation](https://code.visualstudio.com/docs/sourcecontrol/intro-to-git#_clone-a-repository-locally).

### Option B: Manual SSH Key Setup
If you prefer using a standard terminal, you must generate a unique SSH key on the Greene cluster and add it to your GitHub account:
1. **Generate a key:** Run the `ssh-keygen` command on Greene (follow the official [GitHub documentation on generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)).
2. **Add the key to GitHub:** Copy the output of your public key (e.g., `cat ~/.ssh/id_ed25519.pub`) and add it to your account settings (follow the [GitHub documentation on adding a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)).

### Execute the Clone
Once authenticated, run the following commands. Replace `<your-git-ssh-url>` with the SSH URL of your fork (e.g., `git@github.com:YOUR_USERNAME/rob6323_go2_project.git`).
```
cd $HOME
git clone <your-git-ssh-url> rob6323_go2_project
```
*Note: You must ensure the target directory is named exactly `rob6323_go2_project`. This ensures subsequent scripts and paths resolve correctly on the cluster.*
## Install environment

- Enter the project directory and run the installer to set up required dependencies and cluster-side tooling.  
```
cd $HOME/rob6323_go2_project
./install.sh
```
Do not skip this step, as it configures the environment expected by the training and evaluation scripts. It will launch a job in burst to set up things and clone the IsaacLab repo inside your greene storage. You must wait until the job in burst is complete before launching your first training. To check the progress of the job, you can run `ssh burst "squeue -u $USER"`, and the job should disappear from there once it's completed. It takes around **30 minutes** to complete. 
You should see something similar to the screenshot below (captured from Greene):

![Example burst squeue output](docs/img/burst_squeue_example.png)

In this output, the **ST** (state) column indicates the job status:
- `PD` = pending in the queue (waiting for resources).
- `CF` = instance is being configured.
- `R`  = job is running.

On burst, it is common for an instance to fail to configure; in that case, the provided scripts automatically relaunch the job when this happens, so you usually only need to wait until the job finishes successfully and no longer appears in `squeue`.

## What to edit

- In this project you'll only have to modify the two files below, which define the Isaac Lab task and its configuration (including PPO hyperparameters).  
  - source/rob6323_go2/rob6323_go2/tasks/direct/rob6323_go2/rob6323_go2_env.py  
  - source/rob6323_go2/rob6323_go2/tasks/direct/rob6323_go2/rob6323_go2_env_cfg.py
PPO hyperparameters are defined in source/rob6323_go2/rob6323_go2/tasks/direct/rob6323_go2/agents/rsl_rl_ppo_cfg.py, but you shouldn't need to modify them.

## How to edit

- Option A (recommended): Use VS Code Remote SSH from your laptop to edit files on Greene; follow the NYU HPC VS Code guide and connect to a compute node as instructed (VPN required off‑campus) (https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/vs-code). If you set it correctly, it makes the login process easier, among other things, e.g., cloning a private repo.
- Option B: Edit directly on Greene using a terminal editor such as nano.  
```
nano source/rob6323_go2/rob6323_go2/tasks/direct/rob6323_go2/rob6323_go2_env.py
```
- Option C: Develop locally on your machine, push to your fork, then pull changes on Greene within your $HOME/rob6323_go2_project clone.

> **Tip:** Don't forget to regularly push your work to github

## Launch training

- From $HOME/rob6323_go2_project on Greene, submit a training job via the provided script.  
```
cd "$HOME/rob6323_go2_project"
./train.sh
```
- Check job status with SLURM using squeue on the burst head node as shown below.  
```
ssh burst "squeue -u $USER"
```
Be aware that jobs can be canceled and requeued by the scheduler or underlying provider policies when higher-priority work preempts your resources, which is normal behavior on shared clusters using preemptible partitions.

## Where to find results

- When a job completes, logs are written under logs in your project clone on Greene in the structure logs/[job_id]/rsl_rl/go2_flat_direct/[date_time]/.  
- Inside each run directory you will find a TensorBoard events file (events.out.tfevents...), neural network checkpoints (model_[epoch].pt), YAML files with the exact PPO and environment parameters, and a rollout video under videos/play/ that showcases the trained policy.  

## Download logs to your computer

Use `rsync` to copy results from the cluster to your local machine. It is faster and can resume interrupted transfers. Run this on your machine (NOT on Greene):

```
rsync -avzP -e 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' <netid>@dtn.hpc.nyu.edu:/home/<netid>/rob6323_go2_project/logs ./
```

*Explanation of flags:*
- `-a`: Archive mode (preserves permissions, times, and recursive).
- `-v`: Verbose output.
- `-z`: Compresses data during transfer (faster over network).
- `-P`: Shows progress bar and allows resuming partial transfers.

## Visualize with TensorBoard

You can inspect training metrics (reward curves, loss values, episode lengths) using TensorBoard. This requires installing it on your local machine.

1.  **Install TensorBoard:**
    On your local computer (do NOT run this on Greene), install the package:
    ```
    pip install tensorboard
    ```

2.  **Launch the Server:**
    Navigate to the folder where you downloaded your logs and start the server:
    ```
    # Assuming you are in the directory containing the 'logs' folder
    tensorboard --logdir ./logs
    ```

3.  **View Metrics:**
    Open your browser to the URL shown (usually `http://localhost:6006/`).

## Debugging on Burst

Burst storage is accessible only from a job running on burst, not from the burst login node. The provided scripts do not automatically synchronize error logs back to your home directory on Greene. However, you will need access to these logs to debug failed jobs. These error logs differ from the logs in the previous section.

The suggested way to inspect these logs is via the Open OnDemand web interface:

1.  Navigate to [https://ood-burst-001.hpc.nyu.edu](https://ood-burst-001.hpc.nyu.edu).
2.  Select **Files** > **Home Directory** from the top menu.
3.  You will see a list of files, including your `.err` log files.
4.  Click on any `.err` file to view its content directly in the browser.

> **Important:** Do not modify anything inside the `rob6323_go2_project` folder on burst storage. This directory is managed by the job scripts, and manual changes may cause synchronization issues or job failures.

## Project scope reminder

- The assignment expects you to go beyond velocity tracking by adding principled reward terms (posture stabilization, foot clearance, slip minimization, smooth actions, contact and collision penalties), robustness via domain randomization, and clear benchmarking metrics for evaluation as described in the course guidelines.  
- Keep your repository organized, document your changes in the README, and ensure your scripts are reproducible, as these factors are part of grading alongside policy quality and the short demo video deliverable.

## Resources

- [Isaac Lab documentation](https://isaac-sim.github.io/IsaacLab/main/source/setup/ecosystem.html) — Everything you need to know about IsaacLab, and more!
- [Isaac Lab ANYmal C environment](https://github.com/isaac-sim/IsaacLab/tree/main/source/isaaclab_tasks/isaaclab_tasks/direct/anymal_c) — This targets ANYmal C (not Unitree Go2), so use it as a reference and adapt robot config, assets, and reward to Go2.
- [DMO (IsaacGym) Go2 walking project page](https://machines-in-motion.github.io/DMO/) • [Go2 walking environment used by the authors](https://github.com/Jogima-cyber/IsaacGymEnvs/blob/e351da69e05e0433e746cef0537b50924fd9fdbf/isaacgymenvs/tasks/go2_terrain.py) • [Config file used by the authors](https://github.com/Jogima-cyber/IsaacGymEnvs/blob/e351da69e05e0433e746cef0537b50924fd9fdbf/isaacgymenvs/cfg/task/Go2Terrain.yaml) — Look at the function `compute_reward_CaT` (beware that some reward terms have a weight of 0 and thus are deactivated, check weights in the config file); this implementation includes strong reward shaping, domain randomization, and training disturbances for robust sim‑to‑real, but it is written for legacy IsaacGym and the challenge is to re-implement it in Isaac Lab.
- **API References**:
    - [ArticulationData (`robot.data`)](https://isaac-sim.github.io/IsaacLab/main/source/api/lab/isaaclab.assets.html#isaaclab.assets.ArticulationData) — Contains `root_pos_w`, `joint_pos`, `projected_gravity_b`, etc.
    - [ContactSensorData (`_contact_sensor.data`)](https://isaac-sim.github.io/IsaacLab/main/source/api/lab/isaaclab.sensors.html#isaaclab.sensors.ContactSensorData) — Contains `net_forces_w` (contact forces).

---
Students should only edit README.md below this ligne.

---

## Part 5: Refining the Reward Function

To achieve stable and natural-looking locomotion, we added penalties for unwanted behaviors that the basic velocity tracking rewards don't address.

### 5.1 Update Configuration

Add the following reward scales to `rob6323_go2_env_cfg.py`:

```python
# Additional reward scales
orient_reward_scale = -5.0
lin_vel_z_reward_scale = -0.02
dof_vel_reward_scale = -0.0001
ang_vel_xy_reward_scale = -0.001
```

### 5.2 Implement Reward Terms

Add these reward calculations in `_get_rewards()` method in `rob6323_go2_env.py`:

```python
# Penalize non-vertical orientation
rew_orient = torch.sum(torch.square(self.robot.data.projected_gravity_b[:, :2]), dim=1)

# Penalize vertical velocity
rew_lin_vel_z = torch.square(self.robot.data.root_lin_vel_b[:, 2])

# Penalize high joint velocities
rew_dof_vel = torch.sum(torch.square(self.robot.data.joint_vel), dim=1)

# Penalize angular velocity in XY plane
rew_ang_vel_xy = torch.sum(torch.square(self.robot.data.root_ang_vel_b[:, :2]), dim=1)

# Add to rewards dictionary
rewards = {
    ...
    "orient": rew_orient * self.cfg.orient_reward_scale,
    "lin_vel_z": rew_lin_vel_z * self.cfg.lin_vel_z_reward_scale,
    "dof_vel": rew_dof_vel * self.cfg.dof_vel_reward_scale,
    "ang_vel_xy": rew_ang_vel_xy * self.cfg.ang_vel_xy_reward_scale,
}
```

Update logging dictionary in `__init__`:

```python
self._episode_sums = {
    key: torch.zeros(self.num_envs, dtype=torch.float, device=self.device)
    for key in [
        "track_lin_vel_xy_exp",
        "track_ang_vel_z_exp",
        "rew_action_rate",
        "raibert_heuristic",
        "orient",
        "lin_vel_z",
        "dof_vel",
        "ang_vel_xy",
    ]
}
```

## Part 6: Advanced Foot Interaction

### 6.1 Update Configuration

Add reward scales in `rob6323_go2_env_cfg.py`:

```python
feet_clearance_reward_scale = -30.0
tracking_contacts_shaped_force_reward_scale = 4.0
```

### 6.2 Find Sensor Indices

In `__init__`, add separate indices for contact sensor:

```python
# Find indices in the CONTACT SENSOR (for forces)
self._feet_ids_sensor = []
for name in foot_names:
    id_list, _ = self._contact_sensor.find_bodies(name)
    self._feet_ids_sensor.append(id_list[0])
```

### 6.3 Implement Foot Clearance Reward

Add this method to `rob6323_go2_env.py`:

```python
def _reward_feet_clearance(self):
    phases = 1 - torch.abs(1.0 - torch.clip((self.foot_indices * 2.0) - 1.0, 0.0, 1.0) * 2.0)
    foot_height = self.foot_positions_w[:, :, 2]
    target_height = 0.08 * phases + 0.02
    swing_mask = 1 - self.desired_contact_states
    rew_foot_clearance = torch.square(target_height - foot_height) * swing_mask
    reward = torch.sum(rew_foot_clearance, dim=1)
    return reward
```

### 6.4 Implement Contact Force Tracking Reward

Add this method to `rob6323_go2_env.py`:

```python
def _reward_tracking_contacts_shaped_force(self):
    contact_forces_3d = self._contact_sensor.data.net_forces_w[:, self._feet_ids_sensor, :]
    foot_forces = torch.norm(contact_forces_3d, dim=-1)
    desired_contact = self.desired_contact_states
    swing_mask = 1 - desired_contact
    force_penalty = 1 - torch.exp(-1 * foot_forces ** 2 / 100.)
    rew_tracking_contacts = -swing_mask * force_penalty
    reward = torch.sum(rew_tracking_contacts, dim=1) / 4.0
    return reward
```

### 6.5 Integrate into Rewards

Update `_get_rewards()`:

```python
rew_feet_clearance = self._reward_feet_clearance()
rew_tracking_contacts = self._reward_tracking_contacts_shaped_force()

rewards = {
    ...
    "feet_clearance": rew_feet_clearance * self.cfg.feet_clearance_reward_scale,
    "tracking_contacts_shaped_force": rew_tracking_contacts * self.cfg.tracking_contacts_shaped_force_reward_scale,
}
```

Update logging in `__init__`:

```python
self._episode_sums = {
    key: torch.zeros(self.num_envs, dtype=torch.float, device=self.device)
    for key in [
        ...
        "feet_clearance",
        "tracking_contacts_shaped_force",
    ]
}
```

## Bonus Task 1: Actuator Friction Model

### Update Configuration

Add friction parameters to `rob6323_go2_env_cfg.py`:

```python
# Friction model parameters
use_friction_model = True
friction_stiction_range = (0.0, 2.5)
friction_viscous_range = (0.0, 0.3)
```

### Initialize Friction Parameters

In `__init__` of `rob6323_go2_env.py`:

```python
if self.cfg.use_friction_model:
    self.friction_stiction = torch.zeros(self.num_envs, 12, device=self.device)
    self.friction_viscous = torch.zeros(self.num_envs, 12, device=self.device)
```

### Add Randomization in Reset

In `_reset_idx()`:

```python
if self.cfg.use_friction_model:
    self.friction_stiction[env_ids] = torch.rand(len(env_ids), 12, device=self.device) * \
        (self.cfg.friction_stiction_range[1] - self.cfg.friction_stiction_range[0]) + \
        self.cfg.friction_stiction_range[0]
    self.friction_viscous[env_ids] = torch.rand(len(env_ids), 12, device=self.device) * \
        (self.cfg.friction_viscous_range[1] - self.cfg.friction_viscous_range[0]) + \
        self.cfg.friction_viscous_range[0]
```

### Apply Friction Model

Update `_apply_action()`:

```python
def _apply_action(self) -> None:
    torques = torch.clip(
        (
            self.Kp * (self.desired_joint_pos - self.robot.data.joint_pos)
            - self.Kd * self.robot.data.joint_vel
        ),
        -self.torque_limits,
        self.torque_limits,
    )
    
    if self.cfg.use_friction_model:
        tau_stiction = self.friction_stiction * torch.tanh(self.robot.data.joint_vel / 0.1)
        tau_viscous = self.friction_viscous * self.robot.data.joint_vel
        tau_friction = tau_stiction + tau_viscous
        torques = torques - tau_friction
    
    self.robot.set_joint_effort_target(torques)
```

## Bonus Task 2: Rough Terrain Locomotion

### Create Rough Terrain Configuration

Create `rob6323_go2_rough_env_cfg.py` with terrain generator:

```python
from isaaclab.terrains.config.rough import ROUGH_TERRAINS_CFG
from isaaclab.sensors import RayCasterCfg, patterns

observation_space = 48 + 4 + 160  # 160 height scan points

terrain = TerrainImporterCfg(
    prim_path="/World/ground",
    terrain_type="generator",
    terrain_generator=ROUGH_TERRAINS_CFG,
    max_init_terrain_level=5,
    collision_group=-1,
    physics_material=sim_utils.RigidBodyMaterialCfg(
        friction_combine_mode="multiply",
        restitution_combine_mode="multiply",
        static_friction=1.0,
        dynamic_friction=1.0,
        restitution=0.0,
    ),
    debug_vis=False,
)

height_scanner: RayCasterCfg = RayCasterCfg(
    prim_path="/World/envs/env_.*/Robot/base",
    offset=RayCasterCfg.OffsetCfg(pos=(0.0, 0.0, 20.0)),
    ray_alignment="yaw",
    pattern_cfg=patterns.GridPatternCfg(resolution=0.1, size=[1.6, 1.0]),
    debug_vis=False,
    mesh_prim_paths=["/World/ground"],
)

def __post_init__(self):
    self.terrain.terrain_generator.sub_terrains["boxes"].grid_height_range = (0.025, 0.1)
    self.terrain.terrain_generator.sub_terrains["random_rough"].noise_range = (0.01, 0.06)
    self.terrain.terrain_generator.sub_terrains["random_rough"].noise_step = 0.01
    self.terrain.terrain_generator.curriculum = False
```

### Create Rough Terrain Environment

Create `rob6323_go2_rough_env.py` extending the flat environment:

```python
from .rob6323_go2_env import Rob6323Go2Env
from .rob6323_go2_rough_env_cfg import Rob6323Go2RoughEnvCfg

class Rob6323Go2RoughEnv(Rob6323Go2Env):
    cfg: Rob6323Go2RoughEnvCfg

    def __init__(self, cfg: Rob6323Go2RoughEnvCfg, render_mode: str | None = None, **kwargs):
        super().__init__(cfg, render_mode, **kwargs)

    def _setup_scene(self):
        super()._setup_scene()
        self._height_scanner = RayCaster(self.cfg.height_scanner)
        self.scene.sensors["height_scanner"] = self._height_scanner

    def _get_observations(self) -> dict:
        self._previous_actions = self._actions.clone()
        
        height_data = (
            self._height_scanner.data.pos_w[:, :, 2].unsqueeze(2)
            - self._height_scanner.data.ray_hits_w[..., 2].unsqueeze(2)
        ).squeeze(2)
        height_data = height_data.clip(-1.0, 1.0)
        
        obs = torch.cat([
            self.robot.data.root_lin_vel_b,
            self.robot.data.root_ang_vel_b,
            self.robot.data.projected_gravity_b,
            self._commands,
            self.robot.data.joint_pos - self.robot.data.default_joint_pos,
            self.robot.data.joint_vel,
            self._actions,
            self.clock_inputs,
            height_data,
        ], dim=-1)
        
        observations = {"policy": obs}
        return observations
```

### Register Environment

Update `__init__.py`:

```python
gym.register(
    id="Template-Rob6323-Go2-Direct-Rough-v0",
    entry_point=f"{__name__}.rob6323_go2_rough_env:Rob6323Go2RoughEnv",
    disable_env_checker=True,
    kwargs={
        "env_cfg_entry_point": f"{__name__}.rob6323_go2_rough_env_cfg:Rob6323Go2RoughEnvCfg",
        "rsl_rl_cfg_entry_point": f"{agents.__name__}.rsl_rl_ppo_cfg:PPORunnerCfg",
    },
)
```

### Create new train_rough.sh and train_rough.slurm for executing rough terrain

Create `train_rough.sh`

```shell
#!/usr/bin/env bash
ssh -o StrictHostKeyChecking=accept-new burst "cd ~/rob6323_go2_project && sbatch --job-name='rob6323_rough_${USER}' --mail-user='${USER}@nyu.edu' train_rough.slurm '$@'"
```

Create `train_rough.slurm`

```shell
#!/bin/bash

#SBATCH --requeue
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20GB
#SBATCH --time=02:00:00
#SBATCH --gres=gpu:1
#SBATCH --mail-type=END
#SBATCH --account=rob_gy6323-2025fa
#SBATCH --partition=g2-standard-12
#SBATCH --output=../slurm_%j.out
#SBATCH --error=../slurm_%j.err

set -euo pipefail

# -------------------------------
# Project workspace bootstrap
# -------------------------------
PROJECT_NAME="rob6323_go2_project"
REMOTE_HOST="greene-dtn"
LOCAL_PROJECT="${HOME}/${PROJECT_NAME}"
REMOTE_PROJECT="${HOME}/${PROJECT_NAME}"
ISAACLAB_DIR="/scratch/$USER/IsaacLab"

# Ensure local project exists and mirrors remote (first time creates it)
mkdir -p "${LOCAL_PROJECT}"
rsync -az --delete --mkpath -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" \
    "${REMOTE_HOST}:${REMOTE_PROJECT}/" \
    "${LOCAL_PROJECT}/"

mkdir -p "${ISAACLAB_DIR}"
rsync -az --delete --mkpath -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" \
    "${REMOTE_HOST}:${ISAACLAB_DIR}/" \
    "${ISAACLAB_DIR}/"

# -------------------------------
# Hardcode your cluster paths
# -------------------------------
SIF_IMAGE="/scratch/$USER/isaac-lab-base.sif"
RUN_DIR="${LOCAL_PROJECT}"                       # run inside the mirrored project
PERSISTENT_CACHE_DIR="/scratch/$USER/docker-isaac-sim"
PERSISTENT_LOGS_DIR="/scratch/$USER/isaaclab/logs/${SLURM_JOB_ID}"

# Isaac Sim container paths
DOCKER_ISAACSIM_ROOT_PATH="/isaac-sim"
DOCKER_USER_HOME="/root"

# Node-local cache & execution
NODE_TMP="${SLURM_TMPDIR:-${TMPDIR:-/tmp}}"
CACHE_ROOT="${NODE_TMP}/docker-isaac-sim"
mkdir -p \
  "${CACHE_ROOT}/cache/kit" \
  "${CACHE_ROOT}/cache/ov" \
  "${CACHE_ROOT}/cache/pip" \
  "${CACHE_ROOT}/cache/glcache" \
  "${CACHE_ROOT}/cache/computecache" \
  "${CACHE_ROOT}/logs" \
  "${CACHE_ROOT}/data" \
  "${CACHE_ROOT}/documents" \
  "${CACHE_ROOT}/kit-data"

mkdir -p "${PERSISTENT_LOGS_DIR}"
touch "${PERSISTENT_LOGS_DIR}/.keep"

# Prefer node-local tmp for apptainer/singularity scratch
export APPTAINER_TMPDIR="${NODE_TMP}"
export APPTAINER_CACHEDIR="${NODE_TMP}/apptainer-cache"

# Forward all user args to eval.py
export ISAAC_ARGS="$*"
echo "$ISAAC_ARGS"

# Execute with GPU and required binds
singularity exec \
  --nv --containall \
  -B "${CACHE_ROOT}/kit-data:${DOCKER_ISAACSIM_ROOT_PATH}/kit/data:rw" \
  -B "${CACHE_ROOT}/cache/kit:${DOCKER_ISAACSIM_ROOT_PATH}/kit/cache:rw" \
  -B "${CACHE_ROOT}/cache/ov:${DOCKER_USER_HOME}/.cache/ov:rw" \
  -B "${CACHE_ROOT}/cache/pip:${DOCKER_USER_HOME}/.cache/pip:rw" \
  -B "${CACHE_ROOT}/cache/glcache:${DOCKER_USER_HOME}/.cache/nvidia/GLCache:rw" \
  -B "${CACHE_ROOT}/cache/computecache:${DOCKER_USER_HOME}/.nv/ComputeCache:rw" \
  -B "${CACHE_ROOT}/logs:${DOCKER_USER_HOME}/.nvidia-omniverse/logs:rw" \
  -B "${CACHE_ROOT}/data:${DOCKER_USER_HOME}/.local/share/ov/data:rw" \
  -B "${CACHE_ROOT}/documents:${DOCKER_USER_HOME}/Documents:rw" \
  -B "${ISAACLAB_DIR}:/workspace/isaaclab:rw" \
  -B "${PERSISTENT_LOGS_DIR}:/workspace/isaaclab/logs:rw" \
  -B "${RUN_DIR}:/workspace/run:rw" \
  "${SIF_IMAGE}" bash -lc '
set -euo pipefail

cd /workspace/isaaclab
export ISAACLAB_PATH=/workspace/isaaclab

# Ensure the local package is installed in the container Python

/isaac-sim/python.sh -m pip install -e /workspace/run/source/rob6323_go2

/isaac-sim/python.sh /workspace/run/scripts/rsl_rl/train.py \
  --task=Template-Rob6323-Go2-Direct-Rough-v0 \
  --headless

# Identify the latest-created/modified subdirectory under go2_rough_direct
LATEST_DIR=$(ls -td /workspace/isaaclab/logs/rsl_rl/go2_rough_direct/*/ 2>/dev/null | head -n 1 || true)
if [[ -z "${LATEST_DIR:-}" ]]; then
  echo "No subdirectories found under /workspace/isaaclab/logs/rsl_rl/go2_rough_direct" >&2
  exit 1
fi
LATEST_DIR="${LATEST_DIR%/}"

# Run evaluation with the discovered checkpoint
/isaac-sim/python.sh /workspace/run/scripts/rsl_rl/play.py \
  --task=Template-Rob6323-Go2-Direct-Rough-v0 \
  --checkpoint "${LATEST_DIR}/model_499.pt" \
  --video \
  --video_length 1000 \
  --headless
'

rsync -az --delete \
  --exclude='*.err' \
  --exclude='*.out' \
  -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" \
  "${PERSISTENT_LOGS_DIR}/" \
  "${REMOTE_HOST}:${REMOTE_PROJECT}/logs/${SLURM_JOB_ID}/"
```

## Training Instructions

### Train Flat Terrain with Friction Model

```bash
cd $HOME/rob6323_go2_project
./train.sh
```

### Train Rough Terrain

```bash
cd $HOME/rob6323_go2_project
./train_rough.sh 
```

Note: Reduce number of environments to 2048 for rough terrain to avoid PhysX buffer overflow.

### Evaluation

After training completes, logs will be in `logs/[job_id]/rsl_rl/go2_flat_direct/[timestamp]/`. Download and view with TensorBoard:

```bash
rsync -avzP <netid>@dtn.hpc.nyu.edu:/home/<netid>/rob6323_go2_project/logs ./
tensorboard --logdir ./logs
```

Videos are generated automatically in `videos/play/` subdirectory of each run.

## Summary of Modifications

### Reward Function Enhancements
- Added orientation penalty to keep base level
- Added vertical velocity penalty to reduce bouncing
- Added joint velocity penalty for smoother motion
- Added angular velocity penalty to reduce roll and pitch
- Implemented foot clearance rewards for proper swing phase
- Implemented contact force tracking for stance phase control

### Robustness Improvements
- Implemented actuator friction model with randomization
- Added stiction and viscous friction components
- Randomized friction parameters per episode reset

### Terrain Adaptation
- Created rough terrain environment with height scanning
- Added 160-point height map to observations
- Scaled terrain difficulty for Go2 dimensions
- Integrated RayCaster sensor for terrain perception

### Key Parameters
- PD gains: Kp=20.0, Kd=0.5
- Torque limits: 100.0 Nm
- Friction stiction range: 0.0 to 2.5
- Friction viscous range: 0.0 to 0.3
- Height scan: 1.6m x 1.0m grid at 0.1m resolution
- Observation space: 52 (flat) or 212 (rough terrain)

---
