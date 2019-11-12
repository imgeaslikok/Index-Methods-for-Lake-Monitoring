% Start with a folder and get a list of all subfolders.
% Finds and prints names of all files in 
% that folder and all of its subfolders.
% Similar to imageSet() function in the Computer Vision System Toolbox: http://www.mathworks.com/help/vision/ref/imageset-class.html
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
x = [];
i=1;
%Define a roi;
uiwait(msgbox('Select a ROI'));
[filename, pathname]= uigetfile({'*.jpg;*.png;*.tif;*.jp2'},'Select The TCI Image');
path=fullfile(pathname, filename);
im=imread(path);
disp('congratulations! Water Extraction Process in Running');
imshow(im);
r1 = drawrectangle('Label','Double Click to Select','Color',[1 0 0],'Selected',true);
pos = customWait(r1);

% Define a starting folder.
start_path = fullfile(matlabroot, '\toolbox');
if ~exist(start_path, 'dir')
  start_path = matlabroot;
end
% Ask user to confirm or change.
uiwait(msgbox('Pick a starting folder on the next window that will come up.'));
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
  return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
  [singleSubFolder, remain] = strtok(remain, ';');
  if isempty(singleSubFolder)
    break;
  end
  listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)
% Process all image files in those folders.
for k = 1 : numberOfFolders
  % Get this folder and print it out.
  thisFolder = listOfFolderNames{k};
  fprintf('Processing folder %s\n', thisFolder);
  % Get ALL files.
  filePattern = sprintf('%s/*.jp2', thisFolder);
  baseFileNames = dir(filePattern);
  numberOfImageFiles = length(baseFileNames);
  if numberOfImageFiles >= 1
    % Go through all those files.
    for f = 1 : numberOfImageFiles
      fullFileName = fullfile(thisFolder, baseFileNames(f).name);
    % Reading bands
	  if f==1
      B=double((imread(fullFileName)));
      fprintf('B     Processing file %s\n', fullFileName);
      elseif f==2
      G=double((imread(fullFileName)));
	  fprintf('G     Processing file %s\n', fullFileName);
      elseif f==3
      R=double(imread(fullFileName));
      fprintf('R     Processing file %s\n', fullFileName);
      elseif f==4
      MIR=double((imread(fullFileName)));
      fprintf('MIR     Processing file %s\n', fullFileName);
      elseif f==5
      SWIR=double(imread(fullFileName));
      fprintf('SWIR     Processing file %s\n', fullFileName);
      elseif f==6
      NIR=double(imread(fullFileName));
      fprintf('NIR     Processing file %s\n', fullFileName);
      else
      TCI=imread(fullFileName);
      fprintf('TCI     Processing file %s\n', fullFileName);
    
      NDPI = (MIR-G)./(MIR+G);
      MDNWI=(G-MIR)./(G+MIR);
      NDVI = (NIR-R)./(NIR+R);
      NDTI= (R-G)./(R+G);
      gaoNDWI=(NIR-MIR)./(NIR+MIR); 
      NDWI=(G-NIR)./(G+NIR); 
      NDWI2=(R-MIR)./(R+MIR);
      EWI=((G-NIR-MIR)./(G+NIR+MIR));
      NWI=((B-(NIR+MIR+SWIR))./(B+(NIR+MIR+SWIR)))*-1;
      NEW = (B-SWIR)./(B+SWIR);
      NDWI_B = (B-NIR)./(B+NIR);
      AWEInsh = 4*(G-MIR)-(0.25*NIR+2.75*SWIR); %AWEI %feyisa et al. 2014(+)
      AWEIsh = (B)+(2.5*G) - 1.5*(NIR+MIR)-0.25*SWIR; %no shadow(+)
     
      I=imcrop(NDPI,pos);
      I2=imcrop(NDVI,pos);
      I3=imcrop(TCI,pos);
      I4=imcrop(MDNWI,pos);
      I5=imcrop(NDTI,pos);
      I6=imcrop(NDWI,pos);
      I7=imcrop(gaoNDWI,pos);
      I8=imcrop(EWI,pos);
      I9=imcrop(NWI,pos);
      I10=imcrop(NDWI2,pos);
      I11=imcrop(NEW,pos);
      I12=imcrop(NDWI_B,pos);
      I13=imcrop(AWEInsh,pos);
      I14=imcrop(AWEIsh,pos);
      figure('Name','NDPI');  
      imshow(I);
      figure('Name','NDVI');  
      imshow(I2);
      figure('Name','TCI');  
      imshow(I3);
      figure('Name','MNDWI');  
      imshow(I4);
      figure('Name','NDTI');  
      imshow(I5*255);
      figure('Name','NDWI');  
      imshow(I6);
      figure('Name','gaoNDWI');  
      imshow(I7);
      figure('Name','EWI');  
      imshow(I8*255);
      figure('Name','NWI');  
      imshow(I9);
      figure('Name','NDWI2');  
      imshow(I10*255);
      figure('Name','NEW');  
      imshow(I11*255);
      figure('Name','NDWI_B');  
      imshow(I12*255);
      figure('Name','AWEInsh');  
      imshow(I13);
      figure('Name','AWEIsh');  
      imshow(I14);
      end                      
    end
  else
    fprintf('Folder %s has no files in it.\n', thisFolder);
  end
end

