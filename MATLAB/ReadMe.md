# Delta-Sigma ADC MATLAB/Simulink Models

[cite_start]**Version used:** MATLAB R2024a [cite: 1]

## Purpose of Files

1.  [cite_start]**complete_model.slx**: Contains the complete Simulink model of the final delta-sigma ADC designed, including the chosen final modulator topology and final filter[cite: 1].
2.  [cite_start]**modulators.slx**: Contains the Simulink model of the different modulator topologies selected for modeling[cite: 2].
3.  [cite_start]**Flicker_Noise.slx**: Contains the Simulink model for noise modeling and handling of flicker noise using auto-zeroing, chopping, and nested chopping[cite: 3].
4.  [cite_start]**tradeoff.m**: MATLAB script to simulate the final model and plot the tradeoff of Nyquist v/s ENOB[cite: 4].
5.  [cite_start]**pcm_data_extract.m**: Script used to extract the modulator so it can be used in a Verilog testbench[cite: 5].
6.  [cite_start]**fft_hann.m**: Downloaded from the official MATLAB website for FFT, SNR, and ENOB calculation[cite: 6].
7.  [cite_start]**Noise_Generator.m**: Generates the required flicker noise and thermal noise to carry out noise analysis[cite: 7].

---

## Usage Instructions

### Part A: Steps to Run Final Model

1.  [cite_start]Open the file `complete_model.slx`[cite: 8].
2.  [cite_start]Set the analog input in the 'Signal Generator' block[cite: 9].
3.  [cite_start]Set the desired value of the modulating frequency (`fM`) and decimation ratio (`r`) from the command window[cite: 10, 11].
4.  [cite_start]Set the stop time and run the simulation[cite: 11].
5.  [cite_start]The output can be viewed in the scope[cite: 12].

### Part B: Steps to Run Nyquist v/s ENOB Tradeoff Script

1.  [cite_start]Ensure that `complete_model.slx` and `fft_hann.m` are in the same folder as `tradeoff.m`[cite: 12].
2.  [cite_start]Open the `tradeoff.m` script, which is used to obtain the Nyquist v/s ENOB tradeoff[cite: 13].
3.  [cite_start]Make sure the "Model name" at the top of the `tradeoff.m` file matches the name of the Simulink model you wish to use[cite: 14].
4.  [cite_start]Run the `tradeoff.m` script; the plot of ENOB v/s Nyquist should appear upon completion[cite: 15].
5.  [cite_start]The output can be viewed in the scope[cite: 16].

### Part C: Steps to Run Flicker Noise Model

1.  [cite_start]Before running `Flicker_Noise.slx`, run the `Noise_Generation.m` script to generate the required flicker and thermal noise for the Simulink models[cite: 16].
2.  [cite_start]In the `Flicker_Noise.slx` model, there are 6 subsystem blocks located in the modulator before both integrators[cite: 17].
3.  [cite_start]To simulate a specific flicker mitigation technique, connect the respective subsystem (all subsystems are named) and run it[cite: 18, 19].
4.  [cite_start]Follow the steps outlined in **Part B** for running the simulation[cite: 19].

### Part D: Steps to Extract Modulator Data for Verilog Testbench

[cite_start]**Note:** This process generates modulator data for simulating HDL design[cite: 24].

1.  [cite_start]Open the file `modulators.slx`[cite: 20].
2.  [cite_start]Uncomment the modulator you wish to test and comment out the rest[cite: 21].
3.  [cite_start]Set `fM` from the command window[cite: 21].
4.  [cite_start]Set the stop time and run the simulation[cite: 22].
5.  [cite_start]Open the script file `pcm_data_extract.m`[cite: 22].
6.  [cite_start]Run the script to generate the `modulator_data.txt` file[cite: 23].
