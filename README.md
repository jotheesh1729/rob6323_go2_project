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

# Baseline Improvements
We apply the suggested changes from the tutorial as-is for parts 1 to 4. We document our implementations of parts 5 to 6 below, as well as additional featuers such as the actuator friction model and rough terrain environment training. 

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
# Part 6: Advanced Foot Interaction

### 6.1 Find Sensor Indices

In `__init__`, add separate indices for robot bodies and contact sensor:

```python
self._feet_ids = []
self._feet_ids_sensor = []
foot_names = ["FL_foot", "FR_foot", "RL_foot", "RR_foot"]

for name in foot_names:
    id_list, _ = self.robot.find_bodies(name)
    self._feet_ids.append(id_list[0])
    sensor_id_list, _ = self._contact_sensor.find_bodies(name)
    self._feet_ids_sensor.append(sensor_id_list[0])
```

### 6.2 Implement Foot Clearance Reward

Add this code in `_get_rewards()`:

```python
# Foot clearance reward
phases = 1 - torch.abs(1.0 - torch.clip((self.foot_indices * 2.0) - 1.0, 0.0, 1.0) * 2.0)
foot_height = self.foot_positions_w[:, :, 2]
target_height = 0.08 * phases + 0.02
rew_foot_clearance = torch.square(target_height - foot_height) * (1 - self.desired_contact_states)
rew_feet_clearance = torch.sum(rew_foot_clearance, dim=1)
```

### 6.3 Implement Contact Force Tracking Reward

Add this code in `_get_rewards()`:

```python
# Contact force tracking reward
foot_forces = torch.norm(self._contact_sensor.data.net_forces_w[:, self._feet_ids_sensor, :], dim=-1)
desired_contact = self.desired_contact_states
rew_tracking_contacts_shaped_force = torch.zeros(self.num_envs, device=self.device)

for i in range(4):
    rew_tracking_contacts_shaped_force += -(1 - desired_contact[:, i]) * (1 - torch.exp(-1 * foot_forces[:, i] ** 2 / 100.))

rew_tracking_contacts_shaped_force /= 4
```

### 6.4 Integrate into Rewards

Update `_get_rewards()`:

```python
rewards = {
    ...
    "feet_clearance": rew_feet_clearance * self.cfg.feet_clearance_reward_scale,
    "tracking_contacts_shaped_force": rew_tracking_contacts_shaped_force * self.cfg.tracking_contacts_shaped_force_reward_scale,
}
```

## Bonus Task 1: Actuator Friction Model

### Update Configuration

Add friction parameters to `rob6323_go2_env_cfg.py`:

```python
# Friction ranges for actuator
actuator_mu_range_min = 0.001
actuator_mu_range_max = 0.3
actuator_st_range_min = 0.001
actuator_st_range_max = 2.5
```

### Initialize Friction Parameters

In `__init__` of `rob6323_go2_env.py`:

```python
# Actuator friction coefficients
self.stiction_coeff = torch.zeros(self.num_envs, 12, device=self.device)
self.viscous_coeff = torch.zeros(self.num_envs, 12, device=self.device)
```

### Add Randomization in Reset

In `_reset_idx()`:

```python
# Sample new friction coefficients
self.stiction_coeff[env_ids] = torch.zeros_like(self.stiction_coeff[env_ids]).uniform_(
    self.cfg.actuator_st_range_min, 
    self.cfg.actuator_st_range_max
)
self.viscous_coeff[env_ids] = torch.zeros_like(self.viscous_coeff[env_ids]).uniform_(
    self.cfg.actuator_mu_range_min, 
    self.cfg.actuator_mu_range_max
)
```

### Apply Friction Model

Update `_apply_action()`:

```python
def _apply_action(self) -> None:
    # Compute friction torques
    stiction = self.stiction_coeff * torch.tanh(self.robot.data.joint_vel / 0.1)
    viscous = self.viscous_coeff * self.robot.data.joint_vel
    actuator_friction_torque = stiction + viscous
    
    # Compute PD torques with friction
    self.torques = torch.clip(
        (
            self.Kp * (self.desired_joint_pos - self.robot.data.joint_pos)
            - self.Kd * self.robot.data.joint_vel
            - actuator_friction_torque
        ),
        -self.torque_limits,
        self.torque_limits,
    )
    
    self.robot.set_joint_effort_target(self.torques)
```

## Domain Randomization

### Ground Friction Randomization

Added physics material randomization using Isaac Lab's MDP events system in `rob6323_go2_env_cfg.py`:

```python
from isaaclab.managers import EventTermCfg as EventTerm
from isaaclab.managers import SceneEntityCfg

@configclass
class EventCfg:
    robot_physics_material = EventTerm(
        func=mdp.randomize_rigid_body_material,
        mode="reset",
        params={
            "asset_cfg": SceneEntityCfg("robot", body_names=".*"),
            "static_friction_range": (0.7, 1.0), 
            "dynamic_friction_range": (0.6, 1.0),
            "restitution_range": (1.0, 1.0),
            "num_buckets": 250,
            "make_consistent": True
        },
    )

@configclass
class Rob6323Go2EnvCfg(DirectRLEnvCfg):
    ...
    events: EventCfg = EventCfg()
```

This randomizes the friction properties of all robot body parts on each episode reset, making the policy more robust to varying ground conditions.


## Bonus Task 2: Rough Terrain Locomotion

### Create Rough Terrain Configuration

Create `rob6323_go2_rough_env_cfg.py` with generator. It has the following unique elements:

```python
USE_FLAT = False # used for curriculum learning

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
            visual_material=sim_utils.MdlFileCfg(
                mdl_path=f"{ISAACLAB_NUCLEUS_DIR}/Materials/TilesMarbleSpiderWhiteBrickBondHoned/TilesMarbleSpiderWhiteBrickBondHoned.mdl",
                project_uvw=True,
                texture_scale=(0.25, 0.25),
            ),
            debug_vis=False,
        )

def __post_init__(self):
        """Post initialization - scale down terrains for Go2."""
        if not USE_FLAT and self.terrain.terrain_generator is not None:
            # Scale down the terrains because the Go2 robot is small
            self.terrain.terrain_generator.sub_terrains["boxes"].grid_height_range = (0.025, 0.1)
            self.terrain.terrain_generator.sub_terrains["random_rough"].noise_range = (0.01, 0.06)
            self.terrain.terrain_generator.sub_terrains["random_rough"].noise_step = 0.01
            # Disable curriculum for now
            self.terrain.terrain_generator.curriculum = False
```

### Create Rough Terrain Environment

Create `rob6323_go2_rough_env.py` in this case it is a mirror copy of the flat environment (we don't add sensors for our implementation) 

```python

class Rob6323Go2RoughEnv(DirectRLEnv):
    cfg: Rob6323Go2RoughEnvCfg

    def __init__(self, cfg: Rob6323Go2RoughEnvCfg, render_mode: str | None = None, **kwargs):
        super().__init__(cfg, render_mode, **kwargs)
        ...

```

### Update PPO config
update `rsl_rl_ppo_cfg.py`. Notice here we increase the network size to [512, 256, 128] for both actor and critic, following the recommendation from the Anymal C environment.

```python
@configclass
class PPORunnerRoughCfg(RslRlOnPolicyRunnerCfg):
    num_steps_per_env = 32
    max_iterations = 500
    save_interval = 50
    experiment_name = "go2_rough_direct"
    policy = RslRlPpoActorCriticCfg(
        init_noise_std=1.0,
        actor_obs_normalization=True,
        critic_obs_normalization=True,
        actor_hidden_dims=[512, 256, 128],
        critic_hidden_dims=[512, 256, 128],
        activation="elu",
    )
    algorithm = RslRlPpoAlgorithmCfg(
        value_loss_coef=4.0,
        use_clipped_value_loss=True,
        clip_param=0.2,
        entropy_coef=0.0,
        num_learning_epochs=5,
        num_mini_batches=4,
        learning_rate=3.0e-4,
        schedule="adaptive",
        gamma=0.99,
        lam=0.95,
        desired_kl=0.008,
        max_grad_norm=1.0,
    )

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

## Training Instructions

To train the robot on uneven surfaces, we employ a two-stage curriculum learning approach: first, we train on rough terrain using the identical reward structure from the flat environment, allowing the policy to adapt to height variations while maintaining learned gait patterns. In the second stage, we remove the Raibert heuristic and gait phasing rewards, as these overly constrain foot placement and timing on irregular surfaces where strict trotting patterns are suboptimal. Training resumes from the final flat environment checkpoint, enabling the policy to develop more adaptive locomotion strategies.

### Train Flat Terrain
In `rob6323_go2_rough_env_cfg.py` ensure `USE_FLAT=True`

```bash
cd $HOME/rob6323_go2_project
./train_rough.sh
```

### Train Rough Terrain

We want to launch the last completed checkpoint. You'll want to replace <last_run_name> with the timestamp of the last completed run, which will be located under the `logs/[job_id]rsl_rl/go2_rough_direct` folder

```bash
cd $HOME/rob6323_go2_project
./train_rough.sh --video --resume --load_run <last_run_name>
```

### Evaluation

After training completes, logs will be in `logs/[job_id]/rsl_rl/go2_rough_direct/[timestamp]/`. Download and view with TensorBoard:

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
