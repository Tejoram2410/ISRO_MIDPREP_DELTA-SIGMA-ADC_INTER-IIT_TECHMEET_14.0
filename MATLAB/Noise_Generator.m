k  = 1.38e-23;
T  = 300;
gm = 1e-3;

Kf  = 1e-24;
Cox = 4e-3;
W   = 10e-6;
L   = 1e-6;
gamma = 1;

Fs = 1e6;
Tsim = 2;

N = round(Fs * Tsim);
if mod(N,2) ~= 0
    N = N + 1;        
end

Sth = (8/3) * k * T * gm;    
sigma_th = sqrt(Sth * Fs/2);
thermal_noise = sigma_th * randn(N,1);

f = (1:(N/2)).' * (Fs/N);

Sf = Kf ./ (Cox^2 * W * L * (f.^gamma));  

phase = exp(1j * 2*pi*rand(N/2,1));

Fpos = sqrt(Sf/2) .* phase;

F_full = [0; Fpos; conj(Fpos(end:-1:1))];

flicker_noise = real(ifft(F_full)) * sqrt(Fs);

noise = (thermal_noise(1:N) + flicker_noise(1:N))*10 +1e-3;

dt = 1/Fs;

noise_struct.time = (0:N-1)' * dt;
noise_struct.signals.values = noise;
noise_struct.signals.dimensions = 1;

figure;
plot((0:2000-1)/Fs, noise(1:2000));
xlabel("Time (s)"); ylabel("Amplitude");
title("Real MOSFET Noise (Thermal + Flicker)");
grid on;

[pxx,ff] = pwelch(noise,2000,[],[],Fs);

figure;
loglog(ff, pxx);
xlabel("Frequency (Hz)"); ylabel("PSD");
title("PSD of Realistic Noise");
grid on;