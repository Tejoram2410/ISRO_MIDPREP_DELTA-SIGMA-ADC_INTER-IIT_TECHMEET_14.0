# Delta-Sigma ADC MATLAB/Simulink Models

**MATLAB Version Used:** MATLAB R2024a

---

## Purpose of Files

1. **`complete_model.slx`**  
   Contains the complete Simulink model of the final delta–sigma ADC, including the selected modulator topology and the final digital filter chain.

2. **`modulators.slx`**  
   Contains Simulink models of different delta–sigma modulator topologies used during the modeling and evaluation phase.

3. **`Flicker_Noise.slx`**  
   Contains the Simulink model for noise modeling and flicker-noise mitigation techniques such as auto-zeroing, chopping, and nested chopping.

4. **`tradeoff.m`**  
   MATLAB script used to simulate the final ADC model and plot the **Nyquist frequency vs. ENOB** tradeoff.

5. **`pcm_data_extract.m`**  
   Script used to extract modulator output data so it can be used in a Verilog testbench.

6. **`fft_hann.m`**  
   FFT utility script downloaded from the official MATLAB website, used for FFT-based SNR and ENOB calculations.

7. **`Noise_Generator.m`**  
   MATLAB script used to generate flicker noise and thermal noise for noise analysis.

---

## Usage Instructions

### Part A: Running the Final ADC Model

1. Open the file **`complete_model.slx`**.
2. Set the analog input using the **Signal Generator** block.
3. From the MATLAB command window, set:
   - Modulating frequency `fM`
   - Decimation ratio `r`
4. Set the simulation stop time and run the model.
5. Observe the output using the scope blocks in the model.

---

### Part B: Nyquist Frequency vs. ENOB Tradeoff

1. Ensure that the following files are present in the same folder:
   - `complete_model.slx`
   - `tradeoff.m`
   - `fft_hann.m`
2. Open the script **`tradeoff.m`**.
3. Verify that the **model name** specified at the top of the script matches the Simulink model you intend to simulate.
4. Run the script.
5. After execution, the **ENOB vs. Nyquist frequency** plot will be generated automatically.

---

### Part C: Running the Flicker Noise Model

1. Before opening **`Flicker_Noise.slx`**, run the script **`Noise_Generator.m`** to generate the required flicker and thermal noise signals.
2. In `Flicker_Noise.slx`, six noise-mitigation subsystems are provided and placed before the integrators in the modulator.
3. To simulate a specific flicker-noise mitigation technique:
   - Connect the corresponding subsystem (all subsystems are clearly named).
   - Disconnect the remaining subsystems.
4. Run the simulation following the same procedure described in **Part B** for performance evaluation.

---

### Part D: Extracting Modulator Data for Verilog Testbench

> **Note:**  
> This process generates modulator output data for HDL (Verilog) simulation and verification.

1. Open the file **`modulators.slx`**.
2. Uncomment the modulator topology you wish to test and comment out all others.
3. Set the modulating frequency `fM` from the MATLAB command window.
4. Set the simulation stop time and run the model.
5. Open the script **`pcm_data_extract.m`**.
6. Run the script to generate the output file **`modulator_data.txt`**, which can be used in a Verilog testbench.

---
