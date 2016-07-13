# Rinocloud MATLAB Quickstart

## Create a Rinocloud account

The first thing you need to do to get started with Rinocloud is sign up for a free account. A brand new Rinocloud project will automatically be created for you with its own unique URL ending in rinocloud.com. We'll use this URL to store and sync data.

Since Rinocloud is currently in beta you will need to be sent a unique signup link by someone from the Rinocloud team.

## Installation

Download the zip file from

>
[https://github.com/rinocloud/rinocloud-matlab/archive/master.zip](https://github.com/rinocloud/rinocloud-matlab/archive/master.zip)

Or, if you use git, you can clone the repository:

```python
git clone https://github.com/rinocloud/rinocloud-matlab
```

## Getting started

### Installing the library to your path

First, add the Rinocloud-MATLAB integration folder to your MATLAB path:

1. Find the library in the MATLAB file explorer. Its probably in downloads, but maybe you want to move it somewhere more stable.
2. Right-click on the 'rinocloud-matlab-master' folder.
3. select "Add to Path -> Selected Folders and Subfolders".

The Rinocloud library should now be accessible from MATLAB. Check by typing the following into your console:

```
>>> rino.version
 '0.0.2'
```

## Tests

The Rinocloud-MATLAB integration should work right away, but you should test all of the functions automatically.
You can do this by running the tests.m function. Enter:

```
rino.tests
```

If everything is setup correctly, all the test should be passed and you will
be given the option to save your MATLAB path. If you want to do this, enter
'yes' as a string - this means you won't have to add the rinocloud-matlab
intergration to you MATLAB path every time you restart MATLAB.

If you don't want to do this, enter 'no'.

### Authentication

To get your API token; sign into your Rinocloud project and go to the 'Integrations' page. Its
available at:

```python
https://<yourproject>.rinocloud.com/integrations/
```

Enter your API Token as a string into the authentication function (remember to include quote marks to make the input a string):

```python
>>> rino.authentication('Your API Token');

API Token set.
```

You should keep this token secret, anyone with access to the API token can see and modify your data.

**That's it!** You're all set up and ready to go. See below for guides to using the different functions in the Rinocloud-MATLAB Interface.

Here is a simple example of creating a folder and uploading some files with metadata to Rinocloud:

```python
rino.authentication('Your API Token');

rino_response = rino.create_folder('rino_uploads');

% create some metadata, this will normally be your experimental or simulation parameters.
metadata = struct('param1', 'value1', 'param2', 'value2');

tags = {'apples','oranges'};

rino.upload('logo.png', 'metadata', metadata, 'tags', tags, 'parent', rino_response.id);
```

## Creating folders

The create_folder() function takes a single argument, the folder name as a string. The function returns the folder metadata, including its object ID so that the ID can be used when uploading to the folder.

To create a folder called "rino_uploads", we enter:


```python
rino.create_folder('rino_uploads');
```

## Uploading files

This section will give you some simple examples of how to upload using the Rinocloud-MATLAB Integration.

### Uploading a single file

To upload the file "logo.png" to Rinocloud, in the command window enter:

```python
rino_response = rino.upload('logo.png');
```

This will upload the file 'logo.png' to rinocloud without any metadata.

### Upload a file with metadata and tags

```python
metadata = struct('param1', 'value1', 'param2', 'value2');

tags = {'apples','oranges'};

rino_response = rino.upload('logo.png', 'metadata', metadata, 'tags', tags);
```

### Upload to a specific folder

Just get the id of the folder next to the folder name on the rinocloud website, its displayed as #<id>

```python
rino_response = rino.upload('logo.png', 'parent', <parent_id>);
```

### Response metadata

The response metadata will typically look like this:

```python
rino_response =
            id: 848
            metadata: [1x1 struct]
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
```

### Getting the id of the uploaded file

You can get the ID of the uploaded file by typing

```python
rino_response.id
```

### Full upload example

Here is an example that uses all of the optional arguments. Here we want to upload a file called "logo.png", but we want to rename it to "RinoLogo.png". We also want to tag it with the tags "image" and "logo", and to give it the key value pairs "size : small" and "colour : purple". Finally, we also want to save it within a folder we have created which has the object ID 865. In order to do this, we enter the following:

```python
name = 'RinoLogo.png';
tags = {'image', 'logo'};
metadata = struct('size', 'small', 'colour', 'purple');
folder_id = 865;

rino.upload('logo.png', 'newname', 'RinoLogo.png', 'tags', tags, 'metadata', metadata, 'parent', folder_id);
```

## Getting metadata

Get the metadata of a specific file/object by using the `get_metadata` function

```python
rino_response = rino.get_metadata(848)
```

Will set the reponse to:

```python
rino_response =
            id: 848
            metadata: [1x1 struct]
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
```

## Getting children


You can get the children of any folder by using

```python
rino_response = rino.children(1111)
```

`rino_response` is then a list of metadata structs.

You can pass in an extra argument so that children will recursively get all the children of all the subfolders of the folder you're targeting

```python
rino_response = rino.children(1111, 1) % this will act recursively
```

## Downloading files

By default Rinocloud-MATLAB will download all files into a `rinodata` folder, relative to the folder where you are running your code.
To save to a different location, use the `newname` option.

### Download a single Rinocloud file

You can specify which file you want to download by giving its object ID. This can be found using the Rinocloud web interface. To download an object with the ID 667, you would enter:

```python
rino.download(667);
```

It will be named with the filename on Rinocloud. The metadata of the object will be returned as a structure array.

### Download and rename

If we want to download a csv file with object ID 7664, and to rename it "spectrum.txt", we would type:

```python
rino.download(7664, 'newname', 'spectrum.txt');
```

### Download into a variable

If we simply wanted to read the text straight into a MATLAB variable, "data", we would type:

```python
data = rino.download(7664, 'tofile', false);
```

This saves the data in uint8 format. If we want the data to be read as text and saved to a variable, we enter:

```python
data = rino.download(7664, 'totext', true);
```

Sometimes we will want the data to be parsed and read into a Matlab variable ready for plotting. If you specify the format of the data using a format string, the data will be read into a Matlab variable. For example:

```python
data = rino.download(7664, 'format', '%f %f');
```

Would read a file containing two columns of floating point numbers separated by a space into a Matlab array. For more information about format strings in MATLAB, got to [The MATLAB Formatting Strings support page](http://uk.mathworks.com/help/matlab/matlab_prog/formatting-strings.html).

### Download most recent

The download the most recently uploaded file to your current folder, you can enter:

```python
rino.download_last(1);
```
or
```python
rino.download_last(4); % will download last 4 files
```

The function also takes the "tofile" and "totext" and 'format' arguments in the same way as the rino.download() function. For multiple files, the output will be given as a cell array if the "tofile" argument is set to false (this happens automatically if 'totext' is set to true or if a format string is given).

### Download most recent and plot

To plot the most recently uploaded data (composed of two columns of floating point numbers separated by a space), you could enter:


```python

data = rino.download_last(1, 'format', '%f %f');
plot(data{1}, data{2})
```

## Updating

### Updating tags

```python
rino.update_tags()
```

This function removes the old tags associated with an object and replaces them with new ones. The function requires the object ID of the object with tags to be replaced and the new tags as a cell array of strings. For example, to replace the tags of the object with the ID 8898 with the tags "fast" and "new", we would type:

```python
rino.update_tags(8898, {'fast', 'new'});
```

### Updating metadata

This updates the metadata associated with a file. The function requires the object ID of the file and the new metadata as a MATLAB structure array. For example, if we wanted to associate the metadata "laser_power : 6 nW" with the file with the ID 8898, we would enter:

```python
rino.update_metadata(8898, struct('laser_power', '6 nW'));
```

## Deleting

This function deletes a saved file. The delete function takes only the object ID of the file you want to delete. So delete the file with the object ID 8898, we type:

```python
rino.delete(8898);
```



## Tutorials

[Adding Rinocloud to an existing MATLAB project](./adding-matlab-rinocloud-to-project.md)

[Continuous logging with matlab and Rinocloud](./continuous-logging-in-matlab)

[Remote control with matlab and Rinocloud](./matlab-remote-control)
