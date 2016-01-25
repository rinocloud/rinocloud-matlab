# The Rinocloud-MATLAB Integration

You can save and load data files from Rinocloud from within MATLAB using the Rinocloud-MATLAB interface.

## Installation

Download the zip file from 

[https://github.com/rinocloud/rinocloud-matlab/archive/master.zip](https://github.com/rinocloud/rinocloud-matlab/archive/master.zip)

Or you can git clone the repository.

```
git clone https://github.com/rinocloud/rinocloud-matlab
```

## Getting started

To get your API token; sign into your Rinocloud project and go to 

```
https://<yourproject>.rinocloud.com/integrations/
``` 

Download the Rinocloud-MATLAB integration folder and add the folder and subfolders to your MATLAB path.

Copy your API token and paste it into the function called "authenication.m", which is found in the "+rino" folder. Remember to keep this token secret, anyone with access to the API token can see and modify your data.

**That's it!** You're all set up and ready to go. See below for guides to using the different functions in the Rinocloud-MATLAB Interface.

## Tests

The Rinocloud-MATLAB integration should work right away, but if you want to test all of the functions automatically, you can do this by running the rinotests.m function. You will need to set the test API Token in the authenication.m file to the test API Token, which is:

__test only token__ = `a377055b6aecc41f00038c4cd48169b6b55b3d78`

Once you have done this, running rinotests.m will check that all the Matlab functions for Rinocloud work on your computer and on your version of Matlab.

Remember to change the API Token back after you have finished running the tests, as all the test data is deleted periodically.

# Examples

This section will give you some simple example of how to use the Rinocloud-MATLAB Integration. For full details on what the functions can do, see the Function Documentation section below.

## Uploading files

### Uploading a single file

To upload a file to Rinocloud from MATLAB, first make sure that the file is in your current folder. To upload the file "logo.png" to Rinocloud, in the command window enter:

```
response_metadata = rino.upload('logo.png');
```

### Upload a file with metadata and tags

```
metadata = struct(
            'param1', 'value1'
            'param2', 'value2'
          )
          

tags = {'apples','oranges'}

response_metadata = rino.upload('logo.png', 'metadata', metadata, 'tags', tags);
```

### Upload to a specific folder

Just get the id of the folder next to the folder name on the rinocloud website, its displayed as #<id>

```
response_metadata = rino.upload('logo.png', 'parent', <parent_id>);
```

### Response metadata

The response metadata will typically look like this:

```
response_metadata = 
              id: 848
            name: 'logo.png'
            size: 11433
            type: 'file'
         project: 1
    project_name: 'test'
           owner: 'test_user'
      created_on: '2016-01-25T11:33:44.098427Z'
      updated_on: '2016-01-25T11:33:44.098457Z'
          shared: 0
          parent: 1
            tags: {'apples'  'oranges'}
          param1: 'value1'
          param2: 'value2'
```

### Getting the id of the uploaded file

You can get the ID of the uploaded file by typing

```
response_metadata.id
```

### Full upload example

Here is an example that uses all of the optional arguments. Here we want to upload a file called "logo.png", but we want to rename it to "RinoLogo.png". We also want to tag it with the tags "image" and "logo", and to give it the key value pairs "size : small" and "colour : purple". Finally, we also want to save it within a folder we have created which has the object ID 865. In order to do this, we enter the following:

```
NAME = 'RinoLogo.png';
SEARCH_TAGS = {'image', 'logo'};
FILE_METADATA = struct('size', 'small', 'colour', 'purple');
FOLDER_ID = 865;

rino.upload(logo.png, 'newname', 'RinoLogo.png', 'tags', SEARCH_TAGS, 'metadata', FILE_METADATA, 'parent', FOLDER_ID);
```

## Downloading files

### Download a single Rinocloud file

```
rino.download(667);
```

It will be named with the filename on Rinocloud

### Download and rename

If we want to download a csv file with object ID 7664, and to rename it "spectrum.txt", we would type:

```
rino.download(7664, 'newname', 'spectrum.txt');
```

### Download into a variable

If we simply wanted to read the text straight into a MATLAB variable, "DATA", as a string, we would type:

```
DATA = rino.download(7664, 'tofile', false, 'totext', true);
```

### Download most recent

The download the most recently uploaded file to your current folder, you can enter:

```
rino.download_last();
```

Alternatively, you can specify which file you want to download by giving its object ID. This can be found using the Rinocloud web interface. To download an object with the ID 667, you would enter:

```
rino.download_last(4);
```

The function also takes the "tofile" and "totext" arguments in the same way as the rino.download() function. For multiple files, the output will be given as a cell array if the "tofile" argument is set to false.

## Creating folders

```
rino.create_folder('rino_uploads');
```

The create_folder() function take only a single argument, the folder name as a string. The function returns the folder metadata, including its object ID so that the ID can be used when uploading to the folder.

To create a folder called "rino_uploads", we enter:

## Updating

### Updating tags

```
rino.update_tags()
```

This function removes the old tags associated with an object and replaces them with new ones. The function requires the object ID of the object with tags to be replaced and the new tags as cell array of strings. For example, to replace the tags of the object with the ID 8898 with the tags "fast" and "new", we would type:

```
rino.update_tags(8898,{'fast', 'new'});
```

### Updating metadata

This updates the metadata associated with a file. The function requires the object ID of the file and the new metadata as a MATLAB structure array. For example, if we wanted to associate the metadata "laser_power : 6 nW" with the file with the ID 8898, we would enter:

```
rino.update_metadata(8898, struct('laser_power', '6 nW'));
```

## Deleting

This function deletes a saved file. The delete function takes only the object ID of the file you want to delete. So delete the file with the object ID 8898, we type:

```
rino.delete(8898);
```


# API Documentation

## rino.upload()

```
rino.upload(filename)

% with all optional arguments
rino.upload(filename, 'newname', newname, 'metadata', metadata, 'tags', tags, 'parent', parent)
```

The upload function only requires the file name (or file path) as a string as an input. It also takes the following optional arguments:

__newname__: This is the name that the file will given when it is saved to Rinocloud. The newname should be a string.
__tags__: Tags are to allow you to search your data more easily. Tags should be given as a cell array of strings.
__metadata__: Metadata should be in the form of key-value pairs and should be passed to the upload function as a MATLAB structure array.
__parent__: The parent argument is the object ID of the folder that you want to save your file into. You can find the folder object ID using the web interface.

## rino.download()

```
rino.download(file_id)

% with all optional arguments
rino.download(file_id, 'tofile', 1, 'totext', 0)
```

The download function only requires the object ID of file you want to download. The funtion will save the file in your current folder. The download function also takes the following optional arguments:

__newname__: As before, this is the name that the file will given when it is saved to your computer. The newname should be a string.
__tofile__: This argument defaults to true, but if it is set to false, the downloaded file will be returned as binary data (encoded in the uint8 format) and will not be saved to a file on your computer.
__totext__: This argument defaults to false, but if set to true it will assume that the downloaded data is text.
