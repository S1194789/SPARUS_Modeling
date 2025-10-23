# 🤖 Modeling and Control of an Underwater Vehicle — SPARUS AUV

> Dynamic modeling and simulation of the **SPARUS Autonomous Underwater Vehicle (AUV)** using MATLAB/Simulink.  
> This project explores the influence of **mass matrices**, **added mass**, **drag**, and **thruster forces** on underwater motion and control.

---

## 📘 Overview

This project models and simulates the **SPARUS AUV**, an autonomous underwater vehicle designed for inspection and research missions.  
The study investigates how rigid-body dynamics, hydrodynamic forces, and thruster configurations affect its maneuverability and stability.  
Modeling and simulation were conducted entirely in **MATLAB/Simulink**, based on classical marine robotics dynamics.

---

## ⚙️ Repository Structure

SPARUS_Modeling/
├── Simulateur/ # Simulink model and simulation files
│
├── Sparus_Report.pdf # Full project report (23 pages)
│
└── README.md # Project documentation


---

## 🧮 Dynamic Modeling Components

### 1️⃣ Rigid-Body Mass Matrix

The overall rigid-body mass matrix **MRB** is divided into four parts:

MRB = | Mm Mc |
| Mr I |


- **Mm** : Linear mass matrix (inertia in x, y, z)
- **I** : Rotational inertia tensor
- **Mc, Mr** : Coupling matrices (translation–rotation interaction)

**Numerical example:**

MRB =
[ 52 0 0 | 0 -0.1 0 ]
[ 0 52 0 | 0.1 0 -1.3 ]
[ 0 0 52 | 0 1.3 0 ]

[ 0 0.1 0 | 0.5 0 0 ]
[ -0.1 0 1.3 | 0 9.4 0 ]
[ 0 -1.3 0 | 0 0 9.5 ]


---

### 2️⃣ Added Mass Matrices

Added mass represents the inertia effect of the surrounding fluid.  
It was computed separately for **hull**, **antenna**, and **thrusters**.

#### ➤ Hull

The hull is modeled as a rotationally symmetric slender body.

Integration over the hull geometry gives:

m22 = m33 = ∫L (a1 + a2 + a3 + a4)


**Resulting Added Mass Matrix (Hull):**

| Term | Value |
|------|-------|
| m11 | 1.8621 |
| m22 | 75.8479 |
| m33 | 75.8479 |
| m55 | 14.1013 |
| m66 | 14.1013 |
| m26 / m35 | ±3.6469 |

Matrix form:

Mhull =
[ 1.8621 0 0 0 0 0 ]
[ 0 75.8479 0 0 0 -3.6469 ]
[ 0 0 75.8479 0 3.6469 0 ]
[ 0 0 0 0 0 0 ]
[ 0 0 3.6469 0 14.1013 0 ]
[ 0 -3.6469 0 0 0 14.1013 ]


---

#### ➤ Antenna

The antenna is modeled as a spheroidal body aligned along the z-axis.  
Only two principal terms are significant:

| Term | Value |
|------|-------|
| m11 | 0.7286 |
| m22 | 1.4556 |

Matrix form:

MAntenna =
[ 0.7286 0 0 0 0 0 ]
[ 0 1.4556 0 0 0 0 ]
[ 0 0 0 0 0 0 ]
[ 0 0 0 0 0 0 ]
[ 0 0 0 0 0 0 ]
[ 0 0 0 0 0 0 ]


---

### 3️⃣ Drag Matrices

Hydrodynamic drag opposes motion and depends on the projected surface area and drag coefficient.

**Formula:**

Kii = 0.5 * ρ * CDii * A


| Component | CD | Dominant Terms | Comment |
|------------|----|----------------|----------|
| Hull | 0.1 | K11, K22, K33 | Cylindrical approximation |
| Antenna | 1.23 | K11, K22 | Rectangular prism |
| Thrusters | 0.1 | K11, K33 | Small effect |

**Example (Hull Drag Matrix):**

Khull =
[ 2.26 0 0 0 0 0 ]
[ 0 57.6 0 0 0 0 ]
[ 0 0 57.6 0 0 0 ]
[ 0 0 0 0 0 0 ]
[ 0 0 0 0 7.37 0 ]
[ 0 0 0 0 0 7.37]


---

### 4️⃣ Coriolis and Centripetal Effects

The Coriolis matrix **C(v)** depends on the velocity vector **v = [u, v, w, p, q, r]ᵀ**  
and the global inertia matrix **M**.

Simplified structure:


C(v) = | 0 -S(M12v2) |
| -S(M12v2) -S(M22*v2) |


These terms account for the coupling between rotational and translational velocities in the body frame.

---

### 5️⃣ Thruster Mapping

Three thrusters are modeled as force inputs.

| Thruster | Axis | Position (m) | Role |
|-----------|------|--------------|------|
| T1 | z-axis | (0, 0, 0.08) | Heave control |
| T2 | x-axis | (-0.59, +0.17, 0) | Right thruster |
| T3 | x-axis | (-0.59, -0.17, 0) | Left thruster |

Mapping matrix **Eb**:

Eb =
[ 0 1 1 ]
[ 0 0 0 ]
[ 1 0 0 ]
[ 0 0 0 ]
[ 0 0 0 ]
[ 0 -0.17 0.17]


Resulting generalized thrust vector:

Ub = Eb * [FT1, FT2, FT3]ᵀ
Ub = [ Fx, Fy, Fz, Mx, My, Mz ]ᵀ


---

## 🎮 Simulation Scenarios

Simulations were run in **Simulink** for 50 seconds to validate the AUV model under multiple thrust configurations.

| Scenario | Thrusters Used | Description |
|-----------|----------------|-------------|
| Heave motion | Center (20%) | Vertical motion, stable oscillation |
| Surge motion | Sides (30%) | Forward propulsion with slight pitch |
| Turn right | Left 30%, Right 20% | Curved path, yaw response |
| Turn left | Right 30%, Left 20% | Symmetric opposite |
| All thrusters | 30% | Straight stable forward motion (~65 m distance) |

---

## ⚗️ Parametric Studies

### ➤ Effect of Added Mass
- Removing **M33** → increases oscillations and instability  
- Removing **M55** → slower downward motion, loss of control  
- Removing entire added mass → severe instability and unbalanced pitch

### ➤ Effect of Drag
- Without hull drag → distance doubled (20 m vs 11 m)  
- Without antenna drag → increased surge speed, reduced pitch  
- Without thruster drag → higher oscillations (±1°)

---

## 📈 Key Findings

- Added mass terms are crucial for maintaining underwater stability.  
- Drag provides damping, reducing oscillations.  
- Coupling matrices introduce realistic roll/pitch motion.  
- Accurate modeling of these parameters enhances control and trajectory prediction.

---

## 🧩 Tools & Technologies

- MATLAB / Simulink  
- Simscape Multibody  
- Symbolic Math Toolbox  
- Hydrodynamic modeling (added mass & drag)  
- Visualization with 3D simulation

---

## 👩‍🔬 Authors

**Ahmed Borchani**  
**Hyejoo Kwon**  

📍 Erasmus Mundus Master’s in *Marine & Maritime Intelligent Robotics (MIR)*  
🧑‍🏫 Instructor: *Mathieu Richier*

🔗 [GitHub Repository](https://github.com/S1194789/SPARUS_Modeling)








