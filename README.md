# 🤖 SPARUS AUV – Dynamic Modeling and Control Simulation

> A MATLAB/Simulink project focused on modeling and simulating the **SPARUS Autonomous Underwater Vehicle (AUV)** to understand its dynamic behavior, stability, and thruster control under real underwater conditions.

---

## 🌊 Overview

This project was carried out as part of the *Robotics Modeling* course at **Université de Toulon (MIR Programme)**.  
The objective was to design a complete **dynamic model** of the SPARUS AUV, an underwater vehicle used for scientific observation and marine exploration.

We aimed to understand how the AUV’s **mass, buoyancy, drag, and thruster configuration** influence its movement and stability underwater.  
By combining theoretical modeling and simulation experiments, we analyzed the AUV’s response to different thrust scenarios.

---

## ⚙️ What I Did

- Built a **dynamic simulation model** of the SPARUS AUV in MATLAB/Simulink  
- Modeled **hydrodynamic forces**: mass, added mass, drag, and Coriolis effects  
- Implemented **thruster mapping** to simulate surge, heave, and yaw motions  
- Conducted **parametric simulations** to study how stability changes when removing drag or added mass effects  
- Compared different **control scenarios** (single thruster, dual, all thrusters) to evaluate performance and response  
- Validated physical behaviors such as buoyancy, pitch oscillations, and forward motion under real hydrodynamic constraints

---

## 🧩 Key Learning Outcomes

| Area | What I Learned |
|------|----------------|
| Dynamic Modeling | How underwater vehicles are represented mathematically through 6-DOF dynamics |
| Hydrodynamics | The role of added mass and drag in stability and control |
| Simulation | How to use Simulink to test underwater behaviors and visualize motion |
| Control | How thrust distribution and buoyancy affect movement direction and efficiency |
| Analysis | How to interpret physical responses (pitch, heave, surge) from simulation data |

---

## 📊 Results Summary

- The SPARUS model achieved **stable forward motion** under balanced thruster inputs  
- Removing drag increased range but caused **oscillations** and instability  
- Removing added mass made the system **unbalanced and less controllable**  
- The model successfully reproduced **realistic underwater dynamics** (buoyancy-driven rise, pitch dampening, surge–heave coupling)

---

## 🧠 Tools & Technologies

- **MATLAB / Simulink**
- **Simscape Multibody**
- **Hydrodynamic Modeling Theory**
- **Control System Simulation**

---

## 👩‍🔬 Authors

**Hyejoo Kwon**  
**Ahmed Borchani**  

📍 Erasmus Mundus Master’s in *Marine & Maritime Intelligent Robotics (MIR)*  
🧑‍🏫 Instructor: *Mathieu Richier*  

🔗 [GitHub Repository](https://github.com/S1194789/SPARUS_Modeling)
