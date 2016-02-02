% Example of using Rinocloud in a simulation 

%Example simulation - This simulation has two randomly varied parameters
% Param1 and Param2 which impact the out put of the simulation result.
% A figure of merit (FOM) is calculated to determine how close the result
% is to the ideal - the lower the better. For a small FOM, the data is
% tagged as "Small_FOM" and for very small FOM the data is tagged as 
%"Small_FOM" and "Close". The result of the simulation is then written to a
%temporary file and uploaded to Rinocloud. The upload includes the tags and
% metadata. The data is uploaded with the value of both random parameters and the
% FOM. This allows for sorting by different parameters and by tags in order
% to aid data analysis.

APIToken = 'nsgfywiquer23452v234dt2r44t23423'; % Store your API token in 
% your script to avoid the need to input again for each MATLAB session.

rino.authentication(APIToken); % Set your API token

response=rino.create_folder(['Simulation_folder_',datestr(datetime)]); % Create
% a folder to store results in

parent=response.id; %Set the parent of all the saved objects to be the folder
%that we have just created


x=1:0.05:5;
X=x'*x;

for tt=1:50
    tags={}; %Default is no tags
    
    Param1=rand(1); %Random parameters
    Param2=rand(1);
    
    R=Param1*ones(length(x))+Param2*rand(length(x));
    Result=sin(X.*R); %Simulation result
    
    FOMMat=abs(Result-sin(X));
    FOM=sum(FOMMat(:))/(length(x)^2); %Find figure of merit
    
    if FOM<0.3 % Tag as needed
        tags = {'Small_FOM'};
    end
    if FOM<0.1
        tags = {'Small_FOM', 'Close'};
    end
    
    fdl = fopen('tempfolder.txt','wb'); %write to a temporary file
    dlmwrite('tempfolder.txt',Result);
    fclose(fdl);
    metadata = struct('Param1',Param1,'Param2',Param2,'FOM', FOM); % set metadata
    %Upload to Rinocloud
    rino.upload('tempfolder.txt','newname',[num2str(tt),'.txt'],'parent', parent,'tags',tags, 'metadata', metadata);
    
end