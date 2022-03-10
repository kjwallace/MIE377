function [config] = ReadJson(fileName)
    % Reads JSON file, returns struct with the inputs
    fid = fopen(fileName);
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    config = jsondecode(str);
end

