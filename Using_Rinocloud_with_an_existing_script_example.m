% Here is an example of how to add rinocloud functions to your existing
% MATLAB scripts


% The following code should go at the start of your script

        APIToken = 'nsgfywiquer23452v234dt2r44t23423'; % Store your API token in 
        % your script to avoid the need to input again for each MATLAB session.

        rino.authentication(APIToken); % Set your API token at the start of the 
        % script

        folder_metadata = rino.create_folder(['Results_',datestr(datetime)]); 
        % Create a new folder - this one is includes the date of creation in the 
        % name.

        Parent=folder_metadata.id; % Get the folder id to allow it to be set to the 
        % parent folder for all the files generated
        
        Metadata = struct(); % Create and empty structure array for your metadata


        
% Your script that generates or records data and metatdata goes here

    Tags = {'low', 'weak'}; % Set any tags for this data object
    
    Metadata = rino.catstruct(Metadata, struct('laser_power', '6 nW', 'sample', 'W945')); % Set the 
    % metadata for this data object - using the catstruct funtion allows
    % you to append metadata to exisiting structure arrays
    
    % Your normal save to file code goes here. This assumes you use the
    % filename "filename".
    
    rino.upload('filname', 'tags', Tags, 'metadata', Metadata, 'parent', Parent);
    %upload the object to Rinocloud
    
    


