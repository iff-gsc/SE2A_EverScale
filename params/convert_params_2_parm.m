params_filename = 'funray';

this_file_path = fileparts(mfilename('fullpath'));

params_str = fileread([this_file_path,'/',params_filename,'.params']);
params_cell = strsplit(params_str,'\n');

num_lines = size(params_cell,2);

new_params_str = [];
for i = 1:num_lines
    current_line = params_cell{i};
    if ~isempty(current_line)
        if strcmp(current_line(1),'#')
            new_params_str = [ new_params_str, current_line, '\n' ];
        else
            line_split = strsplit(params_cell{i},char(9));
            % Adjust airspeed sensor parameters for use in SITL
            if strcmp(line_split{3},'ARSPD_TYPE')
                line_split{4} = '2';
            elseif strcmp(line_split{3},'ARSPD_PIN')
                line_split{4} = '1';
            elseif strcmp(line_split{3},'ARSPD_SKIP_CAL')
                line_split{4} = '0';
            end
            new_line = [line_split{3},char(32),line_split{4}];
            new_params_str = [ new_params_str, new_line, '\n' ];
        end
    end
end

fid = fopen([this_file_path,'/',params_filename,'.parm'],'wt');
fprintf(fid, new_params_str);
fclose(fid);
