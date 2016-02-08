function [ output_args ] = tests( ~ )
%tests - test if the functions in the rinocloud-matlab integration are
%working and give the user the option to save their matlab path. Called by
%entering rino.tests

try
    C = strsplit(rino.authentication(),' ');
    UsersAPIKey = C{2};
catch
    UsersAPIKey = '0000000000000000000000000000';
end

disp(sprintf ( '\nSetting test API token.') );
rino.authentication('a377055b6aecc41f00038c4cd48169b6b55b3d78');
Worked=true;

% random string so we identify this tests from other.
symbols = ['a':'z' 'A':'Z' '0':'9'];
MAX_ST_LENGTH = 5;
stLength = randi(MAX_ST_LENGTH);
nums = randi(numel(symbols),[1 stLength]);
st = symbols(nums);

% Test create folder
disp(sprintf ( '\nTesting create_folder...') );
returned_meta = rino.create_folder('Test_folder');
if strcmp(returned_meta.name, 'Test_folder')==1
    disp(sprintf('\tTest passed'));
else
    warning('create_folder test failed')
    Worked=false;
end
FileID=returned_meta.id;

%Test upload
disp(sprintf ( '\nTesting simple upload...') );
returned_meta=rino.upload('logo.png');
if isnumeric(returned_meta.id)
    disp(sprintf('\tTest passed'));
else
    warning('Simple upload test failed')
    Worked=false;
end

logoID=returned_meta.id;

disp(sprintf ( '\nTesting upload with new name...') );
returned_meta=rino.upload('logo.png','newname',strcat('logo_',st,'.png'));
if strcmp(returned_meta.name, strcat('logo_',st,'.png'))==1
    disp(sprintf('\tTest passed'));
else
    warning('Upload test with new name failed')
    Worked=false;
end

disp(sprintf ( '\nTesting upload to specified folder...') );
returned_meta=rino.upload('logo.png','parent',FileID);
if returned_meta.parent == FileID
    disp(sprintf('\tTest passed'));
else
    warning('Upload to specified folder test failed')
    Worked=false;
end

disp(sprintf ( '\nTesting upload with tags...') );
returned_meta=rino.upload('logo.png','tags',{'Testtag1','Testtag2'});
if strcmp(returned_meta.tags{2}, 'Testtag2')==1
    disp(sprintf('\tTest passed'));
else
    warning('Upload with tags failed.')
    Worked=false;
end

disp(sprintf ( '\nTesting upload with metadata...') );
returned_meta=rino.upload('logo.png','metadata',struct('testfield1','testvalue1'));
if strcmp(returned_meta.metadata.testfield1, 'testvalue1')==1
    disp(sprintf('\tTest passed'));
else
    warning('Upload with metadata failed')
    Worked=false;
end

%Test update metadata
disp(sprintf ( '\nTesting update metadata...') );
returned_meta=rino.update_metadata(logoID, struct('updated','metatest'));
if strcmp(returned_meta.metadata.updated, 'metatest')==1
    disp(sprintf('\tTest passed'));
else
    warning('Update metadata failed')
    Worked=false;
end

%Test get metadata
disp(sprintf ( '\nTesting get_metadata...') );
returned_meta=rino.get_metadata(logoID);
if returned_meta.id==logoID
    disp(sprintf('\tTest passed'));
else
    warning('Update metadata failed')
    Worked=false;
end

%test search last
disp(sprintf ( '\nTesting search_last...') );
returned_meta=rino.upload('logo.png');
search_result=rino.search_last(1);

if search_result{1}==returned_meta.id
    disp(sprintf('\tTest passed'));
else
    warning('search_last failed')
    Worked=false;
end

%test download
disp(sprintf ( '\nTesting download...') );
FileContent=rino.download(logoID, 'tofile',false);
if strcmp(class(FileContent),'uint8') && length(FileContent)==11433
    disp(sprintf('\tTest passed'));
else
    warning('download test failed')
    Worked=false;
end

%test delete
disp(sprintf ( '\nTesting delete...') );
Response=rino.delete(logoID);
if strcmp(Response, 'Object deleted')
    disp(sprintf('\tTest passed'));
else
    warning('delete test failed')
    Worked=false;
end

%test create_empty
disp(sprintf ( '\nTesting create_empty...') );
Response=rino.create_empty('testempty', 'metadata', struct('Param1', 'Value 1', 'Param2', 'Value2'), 'tags',{'a', 'b'},'parent', FileID);
if strcmp(Response.metadata.Param1, 'Value 1')
    disp(sprintf('\tTest passed'));
else
    warning('create_empty test failed')
    Worked=false;
end

disp(sprintf ( '\nTesting create_object...') );
Response=rino.create_object('testempty', 'metadata', struct('Param1', 'Value 1', 'Param2', 'Value2'), 'tags',{'a', 'b'},'parent', FileID);
if strcmp(Response.metadata.Param1, 'Value 1')
    disp(sprintf('\tTest passed'));
else
    warning('create_object test failed')
    Worked=false;
end

if Worked==true
    disp(sprintf ( '\nAll tests were successful - you are ready to start using Rinocloud!') );
else
    disp(sprintf ( '\nOne or more tests failed.') );
end

disp(sprintf ( '\nResetting API token.') );
rino.authentication(UsersAPIKey);

%delete created files
delete('logo.png.json', strcat('logo_',st,'.png.json'));

while true
    x = input('Do you want to save your current MATLAB path in order to permenantly \nadd the Rinocloud-MATLAB Integration to your MATLAB path? \n(Enter ''yes'' or ''no'' as a string.)\n');
    if strcmp(x, 'yes')
        savepath
        break
    elseif strcmp(x, 'no')
        break
    else
        disp(sprintf ( '\nPlease enter only ''yes'' or ''no'' as a string.') );   
    end
        
end
end

