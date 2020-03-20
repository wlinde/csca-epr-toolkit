function [data,names] = logReadDOS(filename)

    % Read all log files collected from dir('*.log') and collect all
    % intermediate chi2 and param values.
    
    % Read text from file; preallocate data matrix for stored fit info
    data=[];
    text=fileread(filename);
    
    % Split the file using delimiter found in log files
    cell=strsplit(text,'-\r\n');
    
    % cell{2} stores variable names; cell{3} is the data table
    ndummy=strsplit(cell{2},'\r\n  -');
    names=strtrim(strsplit(ndummy{1},' '));
    names=names(~cellfun(@isempty,names));
    ldummy=strsplit(cell{3},'\r\n  -');
    lines=strsplit(ldummy{1},'\r\n');
    
    % Remove empty lines from cell{3}
    lines=lines(~cellfun(@isempty,lines));
%     lines=lines(1:end-1);
    
    % Remove the letter 'S' from the beginning of cell{3} entries, then
    % store data in numerical table for output.
    for j=1:length(lines)
        dumm=strsplit(lines{j},'S');
        datline=textscan(dumm{end},'%f');
        if length(datline{1})==length(names)
            data=[data,datline{1}];
        end
    end
    
    % Transpose, so data are collums instead of rows.
    data=data';
           
       
end