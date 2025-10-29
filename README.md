# UAV-Assisted Wireless Network Optimization

**Authors:** Khalil El Kaaki & Joe Abi Samra  
**Date:** October 2025

## Overview

This MATLAB codebase implements optimization algorithms for UAV (Unmanned Aerial Vehicle) positioning and bandwidth allocation in wireless communication networks. The system maximizes network throughput while ensuring Quality of Service (QoS) constraints for ground users.

## Features

- **Multiple UAV Placement Strategies**
  - Grid-based placement
  - K-means clustering
  - Random initialization with optimization
  - Global search optimization

- **Bandwidth Allocation Optimization**
  - Proportional fairness objective
  - Per-user QoS constraints
  - Hybrid weighted optimization (throughput + fairness)

- **Realistic Channel Modeling**
  - Okumura-Hata propagation model
  - Urban environment corrections
  - Path loss calculations

## Core Functions

### UAV Placement Solutions

#### `gridSol.m`
Places UAVs uniformly in a grid pattern across the coverage area.

```matlab
[uav_pos, baseline_br, sumlink_mbps] = gridSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, BW)
```

**Inputs:**
- `user_pos`: 2×K matrix of user positions (x, y) in meters
- `M`: Number of subcarriers
- `N`: Number of UAVs
- `AREA`: Total coverage area (m²)
- `H_M`: Mobile station height (m)
- `H`: UAV height (m)
- `F`: Frequency (MHz)
- `P_T`: Transmit power (dBm)
- `P_N`: Noise power (dBm)
- `BW`: Total bandwidth (Hz)

**Outputs:**
- `uav_pos`: 2×N matrix of UAV positions
- `baseline_br`: Bitrate per user (bps)
- `sumlink_mbps`: Total throughput (Mbps)

#### `kMeansSol.m`
Uses k-means clustering to position UAVs at cluster centroids of user locations.

```matlab
[uav_pos, baseline_br, sumlink_mbps] = kMeansSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW)
```

**Additional Inputs:**
- `MAX_ITER`: Maximum iterations for k-means
- `TOL`: Convergence tolerance

#### `randomSol.m`
Performs multi-start random optimization to find UAV positions.

```matlab
[uav_pos, baseline_br, sumlink_mbps] = randomSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, BW, Rmin)
```

**Additional Input:**
- `Rmin`: Minimum required rate per user (bps)

### Optimization Functions

#### `optimizeUAVPositions.m`
Optimizes UAV positions using global search with proportional fairness objective.

```matlab
uav_pos_opt = optimizeUAVPositions(N, AREA, uav_pos, user_pos, H_M, H, F, P_T, P_N, BW, Rmin)
```

**Features:**
- Global search algorithm with multiple starting points
- Hybrid objective: α·sum(rates) + (1-α)·sum(log(rates))
- Default α = 0.7 balancing throughput and fairness
- QoS constraints ensuring minimum rate per user

#### `optimizeBandwidthAllocation.m`
Optimally allocates bandwidth among users given fixed UAV positions.

```matlab
[B_opt, br_opt, sum_br_opt_mbps] = optimizeBandwidthAllocation(M, BW_total, user_pos, opt_uav_pos, H_M, H, F, P_T, P_N, Rmin)
```

**Outputs:**
- `B_opt`: Optimal bandwidth allocation per user (Hz)
- `br_opt`: Resulting bitrates (bps)
- `sum_br_opt_mbps`: Total throughput (Mbps)

### Supporting Functions

#### `p_received.m`
Calculates received power using the Okumura-Hata propagation model.

```matlab
p_r = p_received(user_pos, uav_pos, H_M, H, F, P_T)
```

**Returns:** M×N matrix of received powers (dBm) where M = users, N = UAVs

#### `assoc.m`
Assigns each user to the UAV providing maximum received power.

```matlab
a = assoc(p_r)
```

**Returns:** M×N binary association matrix (one-hot encoded)

#### `bitrate.m`
Computes achievable bitrates using Shannon capacity formula.

```matlab
br = bitrate(P_R, P_N, BW, A)
```

**Formula:** `br = BW · log₂(1 + SNR)` where SNR = P_received / P_noise

#### `kMeans.m`
Implements k-means clustering algorithm for UAV positioning.

```matlab
uav_pos = kMeans(user_pos, N, AREA, MAX_ITER, TOL)
```

#### `nonlcon.m`
Nonlinear constraint function ensuring QoS requirements.

```matlab
[c, ceq] = nonlcon(x, user_pos, H_M, H, F, P_T, P_N, BW, Rmin)
```

**Constraint:** Ensures all users achieve rate ≥ Rmin

#### `qosConstraint.m`
Simple QoS constraint for bandwidth optimization.

```matlab
[c, ceq] = qosConstraint(br, Rmin)
```

## Usage Example

```matlab
% System parameters
M = 100;              % Number of users
N = 5;                % Number of UAVs
AREA = 1e6;           % Coverage area (m²)
H_M = 1.5;            % Mobile height (m)
H = 100;              % UAV height (m)
F = 2000;             % Frequency (MHz)
P_T = 30;             % Transmit power (dBm)
P_N = -100;           % Noise power (dBm)
BW = 20e6;            % Bandwidth (Hz)
Rmin = 1e6;           % Minimum rate (bps)
MAX_ITER = 100;
TOL = 1e-6;

% Generate random user positions
side = sqrt(AREA);
user_pos = side * rand(2, M);

% Method 1: K-means solution
[uav_kmeans, br_kmeans, throughput_kmeans] = kMeansSol(user_pos, M, N, AREA, H_M, H, F, P_T, P_N, MAX_ITER, TOL, BW);

% Method 2: Optimize positions
uav_opt = optimizeUAVPositions(N, AREA, uav_kmeans, user_pos, H_M, H, F, P_T, P_N, BW, Rmin);

% Method 3: Optimize bandwidth allocation
[B_opt, br_opt, throughput_opt] = optimizeBandwidthAllocation(M, BW, user_pos, uav_opt, H_M, H, F, P_T, P_N, Rmin);

% Compare results
fprintf('K-means throughput: %.2f Mbps\n', throughput_kmeans);
fprintf('Optimized throughput: %.2f Mbps\n', throughput_opt);
```

## Algorithm Details

### Propagation Model

The code uses the **Okumura-Hata model** for suburban/rural environments:

```
L_urban = 69.55 + 26.16·log₁₀(f) - 13.82·log₁₀(h_b) - C_h + (44.9 - 6.55·log₁₀(h_b))·log₁₀(d)
L_suburban = L_urban - 4.78·(log₁₀(f))² + 18.33·log₁₀(f) - 40.94
```

Where:
- f = frequency (MHz)
- h_b = base station height (m)
- d = 3D distance (m)
- C_h = mobile antenna height correction factor

### Optimization Objective

The system uses a hybrid objective function:

```
maximize: α · Σ(bitrates) + (1-α) · Σ(log(bitrates))
```

This balances:
- **Throughput maximization** (first term)
- **Proportional fairness** (second term)

Default α = 0.7 provides 70% weight to throughput, 30% to fairness.

### Constraints

1. **QoS Constraint:** All users must achieve minimum rate Rmin
2. **Bandwidth Constraint:** Σ(bandwidth allocations) ≤ Total bandwidth
3. **Spatial Constraint:** UAV positions within coverage area boundaries

## Dependencies

- MATLAB Optimization Toolbox (for `fmincon`, `GlobalSearch`)
- MATLAB Core (for basic matrix operations)

## Performance Considerations

- **Global Search:** Can be time-intensive (default max 600 seconds)
- **Multi-start Random:** Uses 10 random initializations for robustness
- **Convergence:** Interior-point algorithm with tolerances:
  - Step tolerance: 1e-6
  - Optimality tolerance: 1e-3
  - Max iterations: 50
  - Max function evaluations: 500,000
(is time-consuming, takes 5-10 minutes)

## Notes

- All power values are in **dBm**
- Distances are in **meters**
- Frequencies are in **MHz**
- Bandwidths are in **Hz**
- Bitrates are in **bps** (converted to Mbps for display)
