% Using Rinocloud - for simulations

x=1:0.05:5;
X=x'*x;
meta=rino.create_folder(['Simulation_folder_',datestr(datetime)]);
parent=meta.id;
for tt=1:200
    tags={};
    Param1=rand(1);
    Param2=rand(1);
    R=Param1*ones(length(x))+Param2*rand(length(x));
    Result=sin(X.*R);
    FOMMat=abs(Result-sin(X));
    FOM=sum(FOMMat(:))/(length(x)^2);
    if FOM<0.3
        tags = {'Small_FOM'};
    end
    if FOM<0.1
        tags = {'Small_FOM', 'Close'};
    end
    
    fdl = fopen('tempfolder.txt','wb');
    dlmwrite('tempfolder.txt',Result);
    fclose(fdl);
    rino.upload('tempfolder.txt','newname',[num2str(tt),'.txt'],'parent', parent,'tags',tags, 'metadata',struct('Param1',Param1,'Param2',Param2));
    
end