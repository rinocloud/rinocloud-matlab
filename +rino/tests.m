function [ output_args ] = tests( ~ )
  try
      C = strsplit(rino.authentication(),' ');
      UsersAPIKey = C{2};
  catch
      UsersAPIKey = '0000000000000000000000000000';
  end

  disp(sprintf ( '\nSetting test API token.') );
  Worked=true;

  % random string so we identify this tests from other.
  symbols = ['a':'z' 'A':'Z' '0':'9'];
  MAX_ST_LENGTH = 5;
  stLength = randi(MAX_ST_LENGTH);
  nums = randi(numel(symbols),[1 stLength]);
  st = symbols(nums);

  % Test create folder
  disp(sprintf ( '\nTesting create_folder...') );
  returned_meta = rino.create_folder('matlab_test');

  if strcmp(returned_meta.name, 'matlab_test')==1
      disp(sprintf('\tTest passed'));
  else
      warning('create_folder test failed')
      Worked=false;
  end
  FileID=returned_meta.id;

  disp(sprintf ( '\nTesting upload with new name...') );
  returned_meta=rino.upload('README.md','newname',strcat('matlab_test/README_',st,'.md'));
  if strcmp(returned_meta.name, strcat('README_',st,'.md'))==1
      disp(sprintf('\tTest passed'));
  else
      warning('Upload test with new name failed')
      Worked=false;
  end

  logoID=returned_meta.id;

  disp(sprintf ( '\nTesting upload to specified folder...') );
  returned_meta=rino.upload('README.md','parent',FileID);
  if returned_meta.parent == FileID
      disp(sprintf('\tTest passed'));
  else
      warning('Upload to specified folder test failed')
      Worked=false;
  end

  disp(sprintf ( '\nTesting upload with metadata...') );
  returned_meta=rino.upload('README.md','metadata',struct('testfield1','testvalue1'), 'newname',strcat('matlab_test/README_',st,'.md'));
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
  returned_meta=rino.upload('README.md', 'newname',strcat('matlab_test/README_SEARCH_',st,'.md'));
  search_result=rino.search_last(1);

  if search_result{1}==returned_meta.id
      disp(sprintf('\tTest passed'));
  else
      warning('search_last failed')
      Worked=false;
  end

  %test download
  disp(sprintf ( '\nTesting download...') );
  FileContent=rino.download(logoID, 'tofile', true);

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

  rino.delete(FileID);

  %delete created files
  delete('README.md.json');
  rmdir('rinodata', 's')
end
