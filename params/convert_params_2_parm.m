params_filename = 'se2a_funray';

% params_str = fileread([pwd,'/../../../../../Desktop/SE2A_Funray/se2a_funray_2.params']);

this_file_path = fileparts(mfilename('fullpath'));

params_str = fileread([this_file_path,'/',params_filename,'.params']);
params_cell = strsplit(params_str,'\n');

num_lines = size(params_cell,2);

new_params_cell = {};
new_params_str = [];
for i = 1:num_lines
    current_line = params_cell{i};
    if ~isempty(current_line)
        if strcmp(current_line(1),'#')
            new_params_cell{i} = current_line;
            new_params_str = [ new_params_str, current_line, '\n' ];
        else
            line_split = strsplit(params_cell{i},char(9));
            new_params_cell{i} = [line_split{3},char(32),line_split{4}];
            new_line = [line_split{3},char(32),line_split{4}];
            new_params_str = [ new_params_str, new_line, '\n' ];
        end
    end
end

fid = fopen([this_file_path,'/',params_filename,'.parm'],'wt');
fprintf(fid, new_params_str);
fclose(fid);
