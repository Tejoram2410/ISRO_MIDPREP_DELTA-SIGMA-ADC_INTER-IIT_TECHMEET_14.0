# Delta–Sigma ADC ASIC Development  
### Inter-IIT Tech Meet 14.0 — 🥉 Bronze Medal  
**Team 76 | Indian Institute of Technology Indore**

---

![MATLAB](https://img.shields.io/badge/MATLAB-R2024a-blue)
![Simulink](https://img.shields.io/badge/Simulink-Modeling-orange)
![Verilog](https://img.shields.io/badge/HDL-Verilog-green)
![ASIC](https://img.shields.io/badge/Flow-RTL--to--GDS-red)
![Inter-IIT](https://img.shields.io/badge/Competition-Inter--IIT%20Tech%20Meet-blueviolet)

---

## 🏆 Achievement

This project was developed for **Inter-IIT Tech Meet 14.0**, where  
**Team 76 from IIT Indore was awarded the Bronze Medal 🥉**  
for the complete **system-level design, modeling, and ASIC-oriented implementation** of a **high-resolution Delta–Sigma Analog-to-Digital Converter (ADC)**.

---

## 📄 Abstract

This work presents the **study, modeling, and ASIC-oriented implementation** of a high-resolution **Delta–Sigma Analog-to-Digital Converter (ADC)** targeting low-bandwidth, high-precision applications. The design aims to achieve a **20-bit resolution** with **≥16 Effective Number of Bits (ENOB) at Nyquist**, while ensuring architectural feasibility for digital ASIC implementation.

The project involves a comprehensive exploration of **Delta–Sigma modulator architectures**, detailed **noise modeling** including flicker noise mitigation techniques, and the design of a **multi-stage digital decimation filter chain**. The digital back-end is implemented in **Verilog HDL** and evaluated using an **RTL-to-GDS ASIC flow**, ensuring practical realizability beyond behavioral simulations.

---

## 📌 Problem Statement Summary

The objective of the problem statement was to:

- Study and select suitable **Delta–Sigma modulator architectures**
- Model the ADC system in **MATLAB/Simulink**
- Analyze **noise shaping**, **OSR trade-offs**, and **ENOB performance**
- Design and implement the **digital decimation filter chain**
- Take the digital design through a **complete ASIC flow**, including post-layout considerations

---

## 🧠 Technical Contributions

- ✔ Behavioral modeling of multiple **Delta–Sigma modulator topologies**
- ✔ Noise analysis including **quantization noise** and **flicker noise**
- ✔ Flicker noise mitigation using:
  - Auto-zeroing
  - Chopping
  - Nested chopping
- ✔ Multi-rate digital decimation chain design:
  - CIC Filter
  - Half-Band Filters
  - FIR Compensation Filter
- ✔ Verilog HDL implementation of all digital filters
- ✔ ENOB, SNR, and frequency-domain performance evaluation
- ✔ ASIC-aware digital design methodology

---

## 📁 Repository Structure

```text
Delta-Sigma-ADC-ASIC-development--Inter-IIT-Tech-Meet-14.0
│
├── MATLAB/
│   ├── complete_model.slx
│   │   └── Final integrated Delta–Sigma ADC Simulink model
│   ├── modulators.slx
│   │   └── Different Delta–Sigma modulator topologies
│   ├── Flicker_Noise.slx
│   │   └── Flicker noise modeling and mitigation techniques
│   ├── tradeoff.m
│   │   └── ENOB vs Nyquist frequency trade-off analysis
│   ├── pcm_data_extract.m
│   ├── Noise_Generator.m
│   └── ReadMe.md
│
├── HDL/
│   ├── cic_filter.v
│   ├── hb_filter.v
│   ├── fir_filter.v
│   ├── integrator.v
│   ├── comb.v
│   ├── decimation.v
│   ├── scale_round_convergent.v
│   ├── dff.v
│   ├── add.v
│   ├── fft_hann.m
│   ├── txt_ENOB_calculation.m
│   └── ReadMe.md
│
├── PROBLEM_STATEMENT.pdf
├── Team_76.pdf
├── Inter IIT Presentation.pdf
└── README.md
