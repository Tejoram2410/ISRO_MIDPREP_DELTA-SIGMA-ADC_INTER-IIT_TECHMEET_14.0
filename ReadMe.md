# Delta–Sigma ADC ASIC Development

### Inter-IIT Tech Meet 14.0 — 🥉 Bronze Medal

**Team 76 | Indian Institute of Technology Indore**

---

## 🏆 Achievement

This project was developed for **Inter-IIT Tech Meet 14.0**, where **Team 76 from IIT Indore was awarded the Bronze Medal 🥉** for the complete **system-level design, modeling, and ASIC-oriented implementation** of a **high-resolution Delta–Sigma Analog-to-Digital Converter (ADC)**.

---

## 📄 Abstract

This work presents the **study, modeling, and ASIC-oriented implementation** of a high-resolution **Delta–Sigma Analog-to-Digital Converter (ADC)** targeting low-bandwidth, high-precision applications. The design aims to achieve a **20-bit resolution** with **≥16 ENOB at Nyquist**, while maintaining architectural feasibility for digital ASIC implementation.

The project spans **system-level modeling**, **noise analysis**, **digital filter design**, and a **complete RTL-to-GDS flow** for the digital back-end, ensuring that the proposed architecture is not limited to behavioral simulations alone.

---

## 📌 Problem Statement Summary

The objective of the problem statement was to:

* Study and select suitable **Delta–Sigma modulator architectures**
* Model the ADC system in **MATLAB/Simulink**
* Analyze **noise shaping, OSR trade-offs, and ENOB performance**
* Design and implement the **digital decimation filter chain**
* Take the digital design through a **complete ASIC flow**, including synthesis and physical design

---

## 🧠 Technical Contributions

* Behavioral modeling of multiple **Delta–Sigma modulator topologies** (CIFB, CIFF, Hybrid)
* Quantization and **flicker noise modeling**, including mitigation using auto-zeroing,chopping,and nested chopping
* Design of a **multi-stage digital decimation chain**:

  * CIC decimator
  * FIR compensation filter
  * Half-band FIR filter
* Fixed-point aware **Verilog HDL implementation** of all digital filters
* Verification against MATLAB/Simulink models
* End-to-end **ASIC synthesis and layout flow** for the digital back-end

---

## 🏭 ASIC Synthesis & Physical Design Flow

The digital back-end of the Delta–Sigma ADC was taken through a **complete RTL-to-GDS ASIC flow**, as detailed in `Team_76.pdf` and the Inter-IIT presentation.

### 🔧 RTL Synthesis

* All digital blocks in the decimation chain were implemented using **synthesizable Verilog HDL** (see `HDL/`).
* The RTL was synthesized using a **standard-cell based synthesis flow** under the target modulator clock frequency.
* Design constraints included clock definitions, I/O timing constraints, and area–timing trade-offs.
* Post-synthesis analysis focused on:

  * Timing closure
  * Area utilization across filter stages
  * Critical path identification in multi-rate processing blocks

### 🧱 Physical Design (Place & Route)

* The synthesized netlist was carried through **floorplanning, power planning, placement, CTS, and routing**.
* Dedicated power and ground planning ensured robust operation of the multi-stage filter chain.
* The final layout achieved acceptable utilization and low routing congestion.

Artifacts related to synthesis and layout are available in:

```
SYNTHESIS_LAYOUT_FILES/
├── SYNTHESIS/
├── SCRIPTS/
├── LAYOUT/
├── PowerPlan.png
└── Placement_Routing.png
```



## 📁 Repository Structure

```text
ISRO_MIDPREP_DELTA-SIGMA-ADC_INTER-IIT_TECHMEET_14.0
│
├── MATLAB/
│   ├── complete_model.slx
│   ├── modulators.slx
│   ├── Flicker_Noise.slx
│   ├── tradeoff.m
│   └── *.m
│
├── HDL/
│   ├── cic_filter.v
│   ├── hb_filter.v
│   ├── fir_filter.v
│   └── supporting RTL blocks
│
├── SYNTHESIS_LAYOUT_FILES/
│   ├── SYNTHESIS/
│   ├── SCRIPTS/
│   ├── LAYOUT/
│   └── layout snapshots
│
├── PROBLEM_STATEMENT.pdf
├── Team_76.pdf
├── Inter IIT Presentation.pdf
└── ReadMe.md
```

---

## 📚 Documentation

For detailed methodology, architectural choices, synthesis results, and post-layout observations, refer to:

* **Team_76.pdf** (Final Technical Report)
* **Inter IIT Presentation.pdf**

---

👥 Team

Team 76
Indian Institute of Technology Indore

Team Members:

Naman Goyal

Himesh Jha

Mohd Sharik Mansoori

Tejo Rama Vigneswar Majeti

Rohan Jain

Manthan Gupta
