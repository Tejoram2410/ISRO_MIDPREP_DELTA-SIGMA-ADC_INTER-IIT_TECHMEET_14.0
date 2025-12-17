model_name = 'complete_model';
BW_low = 0;

fM_vector = [4.096e6];

fs_target_min = 850;
fs_target_max = 2000;
num_fs_points = 10;
fs_target_vector = linspace(fs_target_min, fs_target_max, num_fs_points);

num_fM = length(fM_vector);
num_fs = length(fs_target_vector);

enob_results      = zeros(num_fM, num_fs);
fs_actual_results = zeros(num_fM, num_fs);
r_used_results    = zeros(num_fM, num_fs);

DESIRED_N = 2^11;
settle_time = 0.1;
max_stop_time = 5;

fprintf('Loading Simulink model: %s\n', model_name);
load_system(model_name);

for j = 1:num_fM
    fM = fM_vector(j);
    assignin('base', 'fM', fM);

    fprintf('\n Starting simulations for fM = %.3f MHz \n', fM / 1e6);

    for i = 1:num_fs
        fs_target = fs_target_vector(i);

        r_target = fM / fs_target;
        r = 2 * round(r_target / 2);

        if r <= 0 || ~isfinite(r)
            fprintf('Target fs=%.1f kHz is unachievable (r=%d). Skipping.\n', fs_target/1e3, r);
            continue;
        end

        assignin('base', 'r', r);
        fs_actual = fM / r;
        BW_high = fs_actual/2;

        required_sim_time = settle_time + DESIRED_N / fs_actual;

        actual_N = DESIRED_N;
        if required_sim_time > max_stop_time
            max_allowed_samples = floor((max_stop_time - settle_time) * fs_actual);
            if max_allowed_samples < 128
                fprintf(' Required stop time would be >%.1f s and reduced samples <128. Skipping.\n', max_stop_time);
                continue;
            end
            actual_N = 2^floor(log2(max_allowed_samples));
            required_sim_time = settle_time + actual_N / fs_actual;
            fprintf('DESIRED_N too large for this fs. Using reduced N=%d (StopTime=%.3f s).\n', actual_N, required_sim_time);
        end

        stop_time = required_sim_time;
        set_param(model_name, 'StopTime', num2str(stop_time));

        fprintf('Running (fM %d/%d, fs_tgt %d/%d):   fs=%.4f kHz, ...', ...
                 j, num_fM, i, num_fs,  fs_actual/1e3);

        try
            out = sim(model_name);
        catch ME
            fprintf('\nError running simulation for fM=%.1fMHz, r=%d.\n', fM/1e6, r);
            fprintf('Error message: %s\n', ME.message);
            continue;
        end

        adc_ts = adc_out;
        y = double(adc_ts);

        total_samples = length(y);
        if total_samples < actual_N
            fprintf('\n Only %d samples available but %d required. Skipping.\n', total_samples, actual_N);
            continue;
        end

        y = y(end-actual_N+1:end);
        N = actual_N;

        opt = fft_hann();
        opt.win = 'hann';
        opt.coherent = 0;
        opt.RL = 100;

        [fsig, amp, vos, snr, thd, sndr, ENOB, phi] = ...
            fft_hann(y, BW_low, BW_high, fs_actual, '', '', opt);

        enob_results(j, i)      = ENOB;
        fs_actual_results(j, i) = fs_actual;
        r_used_results(j, i)    = r;

        fprintf(' Done. fsig=%.3f ENOB = %.3f bits\n', fsig, ENOB);
    end
end

fprintf('\nAll simulation loops finished.\n');

figure;
hold on;
legend_entries = cell(num_fM, 1);
fs_plot_x_axis = fs_target_vector / 1e3;

for j = 1:num_fM
    enob_row = enob_results(j, :);
    valid_results = (enob_row ~= 0);
    if ~any(valid_results)
         fprintf('No valid data for fM = %.3f MHz. Skipping plot.\n', fM_vector(j)/1e6);
         continue;
    end
    plot(fs_plot_x_axis(valid_results), enob_row(valid_results), 'o-', 'LineWidth', 1.5, 'MarkerSize', 5);
    current_fM = fM_vector(j);
    if current_fM >= 1e6
        legend_entries{j} = sprintf('f_M = %.3f MHz', current_fM / 1e6);
    else
        legend_entries{j} = sprintf('f_M = %.1f kHz', current_fM / 1e3);
    end
end
hold off;
grid on;
title('ENOB vs. Target Nyquist Frequency');
xlabel('Target Nyquist Sampling Frequency (f_s) [kHz]');
ylabel('Effective Number of of Bits (ENOB)');
xlim([fs_target_min/1e3, fs_target_max/1e3]);
legend(legend_entries(~cellfun('isempty',legend_entries)), 'Location', 'best');
set(gca, 'FontSize', 12);
fprintf('Plotting complete.\n');
