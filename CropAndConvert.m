function dbPath = CropAndConvert

%% Reset MATLAB
close all
clear
clc

%% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,'d12pack');
circadianDir      = fullfile(githubDir,'circadian');
addpath(d12packDir,circadianDir);

%% Map paths
timestamp = datestr(now,'yyyy-mm-dd_HHMM');
rootDir = '\\root\projects';
calPath = fullfile(rootDir,'DaysimeterAndDimesimeterReferenceFiles',...
    'recalibration2016','calibration_log.csv');
prjDir  = 'C:\Users\jonesg5\Desktop\Cree';
dbName  = [timestamp,'.mat'];
dbDir = fullfile(prjDir,'CroppedData');
dbPath  = fullfile(dbDir,dbName);

% Check for previous DB
dbListing = dir(fullfile(dbDir,'*.mat'));
if ~isempty(dbListing)
    [~,idxMostRecent] = max(vertcat(dbListing.datenum));
    previousDbName = dbListing(idxMostRecent).name;
    previousDbPath = fullfile(dbDir,previousDbName);
    previousDB = load(previousDbPath);
else
    previousDB = [];
end

baselineDir = fullfile(prjDir,'baseline');
interventionDir = fullfile(prjDir,'intervention');

BlistingCDF   = dir(fullfile(baselineDir,'*.cdf'));
BcdfPaths     = fullfile(baselineDir,{BlistingCDF.name});
BloginfoPaths = regexprep(BcdfPaths,'\.cdf','-LOG.txt');
BdatalogPaths = regexprep(BcdfPaths,'\.cdf','-DATA.txt');

IlistingCDF   = dir(fullfile(interventionDir,'*.cdf'));
IcdfPaths     = fullfile(interventionDir,{IlistingCDF.name});
IloginfoPaths = regexprep(IcdfPaths,'\.cdf','-LOG.txt');
IdatalogPaths = regexprep(IcdfPaths,'\.cdf','-DATA.txt');

%% Create DB file and object
DB = matfile(dbPath,'Writable',true);

nB = numel(BcdfPaths);
nI = numel(IcdfPaths);

%% Crop and convert baseline data
% ii = 1;
% for iSub = 1:nB
%     cdfData = daysimeter12.readcdf(BcdfPaths{iSub});
%     thisID = cdfData.GlobalAttributes.subjectID;
%     
%     thisLog = BloginfoPaths{iSub};
%     thisData = BdatalogPaths{iSub};
%     
%     % Convert data
%     thisObj = convertData(thisID,thisLog,thisData,'baseline','HumanData',calPath);
%     
%     if isempty(thisObj)
%         continue
%     end
%     
%     % Crop the data
%     thisObj = crop(thisObj);
%     
%     baseline(ii,1) = thisObj;
%     DB.baseline = baseline;
%     ii = ii + 1;
% end


%% Crop and convert intervention data
intervention = previousDB.intervention;
ii = 9;
for iSub = 9:nI
    cdfData = daysimeter12.readcdf(IcdfPaths{iSub});
    thisID = cdfData.GlobalAttributes.subjectID;
    
    thisLog = IloginfoPaths{iSub};
    thisData = IdatalogPaths{iSub};
    
    % Convert data
    thisObj = convertData(thisID,thisLog,thisData,'intervention','HumanData',calPath);
    
    if isempty(thisObj)
        continue
    end
    
    % Crop the data
    thisObj = crop(thisObj);
    
    intervention(ii,1) = thisObj;
    DB.intervention = intervention;
    ii = ii + 1;
end

end

function obj = convertData(ID,loginfoPath,datalogPath,session,objType,calPath)
switch objType
    case 'HumanData'
        obj = d12pack.HumanData;
    case 'StaticData'
        obj = d12pack.StaticData;
    otherwise
        error('Unsupported object type.');
end

obj.CalibrationPath = calPath;
obj.RatioMethod     = 'newest';
obj.ID              = ID;
obj.TimeZoneLaunch	= 'America/New_York';
obj.TimeZoneDeploy	= 'America/Los_Angeles';

% Import the original data
obj.log_info = obj.readloginfo(loginfoPath);
obj.data_log = obj.readdatalog(datalogPath);

% Add Session
obj.Session = struct('Name',session);

end
