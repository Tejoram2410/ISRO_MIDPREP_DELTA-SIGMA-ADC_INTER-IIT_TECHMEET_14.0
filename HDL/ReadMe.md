
## RTL Decimation Filter Chain

### Files Included

- **`top_module.v`** – Top-level RTL chain: CIC → FIR → Half-Band → Scaling  
- **`cic_filter.v`** – CIC filter with integrator, comb, and decimation stages  
- **`integrator.v`** – Multi-stage CIC integrator  
- **`decimation.v`** – Decimation logic based on operating mode  
- **`comb.v`** – Comb filter stage  
- **`add.v`** – Adder module  
- **`sub.v`** – Subtractor module  
- **`dff.v`** – D flip-flop with enable  
- **`fir_filter.v`** – FIR filter with mode-dependent coefficients  
- **`hb_filter.v`** – Half-band filter  
- **`scale_round_convergent.v`** – Scaling and convergent rounding logic  
- **`tb.v`** – Testbench for verification  
- **`1V_100Hz.txt`** – 1-bit PCM modulator output (input stimulus)  
- **`20_bit_adc_out.txt`** – Final 20-bit decimated ADC output

---

## Running RTL Simulation in Vivado

1. Open **Vivado 2024.1**.
2. Create a new project.
3. Add all `.v` files **except `tb.v`** as **Design Sources**.
4. Add `tb.v` as a **Simulation Source**.
5. Copy the PCM input file (e.g., `1V_100Hz.txt`) to:  
   `PROJECT_NAME.sim/sim_1/behav/xsim/`
6. Run **Behavioral Simulation**.
7. Run the simulation for **1.25 seconds**.
8. The testbench automatically loads PCM data and writes 20-bit output samples.

---

## Viewing Waveforms

1. Maximize the waveform window and click **Zoom Fit**.
2. Right-click `hb_out` → **Waveform Style → Analog**.
3. Right-click `hb_out` → **Radix → Signed Decimal**.

---

## Computing ENOB / SNDR from RTL Output

1. Copy `20_bit_adc_out.txt` from:  
   `PROJECT_NAME.sim/sim_1/behav/xsim/`
2. Paste it into the MATLAB HDL analysis folder.
3. Open `txt_ENOB_calculation.m`.
4. Set the sampling frequency according to the target Nyquist rate.
5. Ensure `fft_hann.m` is present in the same folder.
6. Run the script.
7. ENOB and SNDR values will be displayed in the MATLAB command window.

---
