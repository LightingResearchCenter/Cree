function exportData
%ANALYZEDATA Summary of this function goes here
%   Detailed explanation goes here
timestamp = datestr(now,'yyyy-mm-dd HH-MM');

[githubDir,~,~] = fileparts(pwd);
d12packDir = fullfile(githubDir,'d12pack');
addpath(d12packDir);

projectDir = '\\ROOT\projects\Cree';
dataDir = fullfile(projectDir,'CroppedData');


ls = dir([dataDir,filesep,'*.mat']);
[~,idxMostRecent] = max(vertcat(ls.datenum));
dataName = ls(idxMostRecent).name;
dataPath = fullfile(dataDir,dataName);

data = load(dataPath);

saveDir = fullfile(projectDir,'export','baseline');
objArray = data.baseline;

for iObj = 1:numel(objArray)
    filename = sprintf('subject%s-%s.csv',objArray(iObj).ID,objArray(iObj).Session.Name);
    filepath = fullfile(saveDir,filename);
    objArray(iObj).export(filepath)
end
%%

saveDir = fullfile(projectDir,'export','intervention');
objArray = data.intervention;

for iObj = 1:numel(objArray)
    filename = sprintf('subject%s-%s.csv',objArray(iObj).ID,objArray(iObj).Session.Name);
    filepath = fullfile(saveDir,filename);
    objArray(iObj).export(filepath)
end

end

