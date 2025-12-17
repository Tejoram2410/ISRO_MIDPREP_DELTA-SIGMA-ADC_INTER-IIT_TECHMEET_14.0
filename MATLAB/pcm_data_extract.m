y_raw = double(out.pcm.Data);


num_samples = length(y_raw);
if num_samples == 0
    error('mod_data is empty');
end


y_out = (y_raw > 0); 

filename = 'modulator_data.txt';   % output data file

try
    fileID = fopen(filename, 'w');
    if fileID == -1
        error('could not open file: %s', filename);
    end
    
    fprintf('writing %d samples to %s \n', num_samples, filename);
    
    for k = 1:num_samples
        fprintf(fileID, '%d\n', y_out(k));
    end
    
    fclose(fileID);
    
    fprintf('File saved\n');
    fprintf('Name: %s\n', filename);
    fprintf('No of Samples: %d\n', num_samples);
    

catch ME
    if exist('fileID', 'var') && fileID ~= -1
        fclose(fileID);
    end
    fprintf('\n error writing file \n');
    rethrow(ME);
end