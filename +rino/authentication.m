function [ output_args ] = authentication( args )
    persistent APITokenOut;
    if nargin == 1
        if ischar(args) ~= 1
            error('API Token must be given as a string.')
        end
        
        configDir = [args];
        if exist(configDir)
            yamlStruct = ReadYaml(configDir);
            if isfield(yamlStruct, 'apiToken')
                APITokenOut = yamlStruct.apiToken;
            else
                warning('No apiToken field in rino.yaml')
            end
        else
            APITokenOut=args;
        end
        disp(sprintf ( '\nAPI Token set.') )
    end

    if nargin == 0
      configDir = [pwd, '/rino.yaml'];
      if exist(configDir)
        yamlStruct = ReadYaml(configDir);
        if isfield(yamlStruct, 'apiToken')
          APITokenOut = yamlStruct.apiToken;
        else
          warning('No apiToken field in rino.yaml')
        end
      end
    end
    
    if length(APITokenOut) == 0 || strcmp(APITokenOut, '0000000000000000000000000000')
        error('Please set your API Token.')
    end

    output_args = ['Token ' , APITokenOut];

end
