% --- 1. Configuration ---


   filename = '20_bit_adc_out.txt';

   fs = 1000;
   bit_width=20;



fprintf('Loading data from %s...\n', filename);
try
    fileID = fopen(filename, 'r');
    if fileID == -1, error('Could not open the file.'); end
    
    binary_strings = textscan(fileID, '%s');
    fclose(fileID);
    
    binary_strings = binary_strings{1}; 
    num_samples = length(binary_strings);
    
    if num_samples == 0, error('File is empty.'); end
    fprintf('Read %d samples.\n', num_samples);
    
catch ME
    if exist('fileID', 'var') && fileID ~= -1, fclose(fileID); end
    fprintf('Error while loading file: %s\n', ME.message);
    rethrow(ME);
end


BIT_WIDTH = bit_width; 
TWO_POW_BW = 2^BIT_WIDTH;

fprintf('Converting %d-bit binary strings to double...\n', BIT_WIDTH);

try

    
   
    if length(binary_strings{1}) ~= BIT_WIDTH
        error('First sample has %d bits, expected %d. Aborting.', length(binary_strings{1}), BIT_WIDTH);
    end
    
   
    char_matrix = char(binary_strings);
    numeric_matrix = char_matrix - '0';
    invalid_rows = any(numeric_matrix < 0 | numeric_matrix > 1, 2);
    
    if any(invalid_rows)
        fprintf('Warning: Found %d samples with incorrect bit width. They will be skipped.\n', sum(invalid_rows));
        numeric_matrix(invalid_rows, :) = [];
        binary_strings(invalid_rows) = [];
        num_samples = length(binary_strings);
        if num_samples == 0, error('No valid-width samples found.'); end
    end

    weights = 2.^( (BIT_WIDTH-1) : -1 : 0 )';
    unsigned_vals = numeric_matrix * weights;    
    is_negative = (numeric_matrix(:, 1) == 1);   
    data_double = unsigned_vals;
    data_double(is_negative) = data_double(is_negative) - TWO_POW_BW;
    
    
    fprintf('Conversion complete. %d valid samples found.\n', num_samples);
    
catch ME
    fprintf('Error during binary conversion: %s\n', ME.message);
    fprintf('This can happen if file contains non-binary chars or inconsistent line lengths.\n');
    rethrow(ME);
end
y = data_double;

if isempty(y)
    error('No valid data left after processing. Check your .txt file.');
end

fprintf('Starting analysis...\n');
try
   
    N = 2^floor(log2(length(y)));  
    y = y(end-N+1:end);            
    fprintf('Analyzing %d samples...\n', N);
    
    BW_low  = 0;          
    BW_high = fs/2;       
    
    % --- get defaults ---
    opt = fft_hann();     
    opt.win = 'hann';  
    
    opt.coherent = 0;     
    opt.RL = 100;         
    
   
    [fsig,amp,vos,snr,thd,sndr,ENOB,phi] = ...
        fft_hann(y, BW_low, BW_high, fs, 'i', 'Verilog Filter Output (20-bit)', opt);
 
    fprintf('\n--- Analysis Results (from fft_hann) ---\n');
    fprintf('Sample Freq (Fs) = %.4f Hz\n', fs);
    fprintf('Detected Signal (fsig) = %.3f Hz\n', fsig);
    fprintf('SNDR = %.2f dB\n', sndr);
    fprintf('ENOB = %.3f bits\n', ENOB);
    
catch ME
    % --- This ONE 'catch' block will handle all errors ---
    if strcmp(ME.identifier, 'MATLAB:UndefinedFunction')
        if contains(ME.message, 'fft_hann')
            fprintf('\n--- ERROR --...-snip-...');
            fprintf('Could not find the "fft_hann.m" function.\n');
            fprintf('Please make sure this file is in your MATLAB folder or path.\n');
        else
            % Some other undefined function
            fprintf('\n--- Undefined Function Error ---\n');
            fprintf('Function "%s" was not found.\n', ME.message);
            rethrow(ME);
        end
    else
        % All other possible errors (e.g., in the analysis)
        fprintf('\n--- An Error Occurred During Analysis ---\n');
        rethrow(ME);
    end
end