% function MakeDaysigrams
%MAKE Summary of this function goes here
%   Detailed explanation goes here

addpath('C:\Users\jonesg5\Documents\GitHub\d12pack');

projectDir = 'C:\Users\jonesg5\Desktop\Cree';

dataDir = fullfile(projectDir,'CroppedData');

ls = dir(fullfile(dataDir,'*.mat'));
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(dataDir,dataName);

exportDir = fullfile(projectDir,'Daysigrams');

DB = load(dataPath);

timestamp = upper(datestr(now,'mmmdd'));

objArray = DB.baseline;
for iObj = 1:numel(objArray)
    thisObj = objArray(iObj);
    
    if isempty(thisObj.Time)
        continue
    end
    
    titleText = {'Cree';['ID: ',thisObj.ID,', Session: ',thisObj.Session.Name,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.daysigram(thisObj,titleText);
    
    for iFile = 1:numel(d)
        d(iFile).Title = titleText;
        
        fileName = [thisObj.ID,'_',thisObj.Session.Name,'_',timestamp,'_p',num2str(iFile),'.pdf'];
        filePath = fullfile(exportDir,fileName);
        saveas(d(iFile).Figure,filePath);
        close(d(iFile).Figure);
        
    end
end

objArray = DB.intervention;
for iObj = 1:numel(objArray)
    thisObj = objArray(iObj);
    
    if isempty(thisObj.Time)
        continue
    end
    
    titleText = {'Cree';['ID: ',thisObj.ID,', Session: ',thisObj.Session.Name,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.daysigram(thisObj,titleText);
    
    for iFile = 1:numel(d)
        d(iFile).Title = titleText;
        
        fileName = [thisObj.ID,'_',thisObj.Session.Name,'_',timestamp,'_p',num2str(iFile),'.pdf'];
        filePath = fullfile(exportDir,fileName);
        saveas(d(iFile).Figure,filePath);
        close(d(iFile).Figure);
        
    end
end


% end

