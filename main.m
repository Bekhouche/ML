% Salah Eddine Bekhouche (salah@bekhouche.com)
clc;clear;

%% DOwnload image
if ~ (exist('face.jpg', 'file') == 2)
    img = imread('http://dreamicus.com/data/face/face-04.jpg');
    imwrite(img,'face.jpg');
end

%% Download lbp.m if not exist
if ~ (exist('lbp.m', 'file') == 2)
    websave('lbp.m','http://www.cse.oulu.fi/wsgi/CMV/Downloads/LBPMatlab?action=AttachFile&do=get&target=lbp.m');
end

%% Download lbp.m if not exist
if ~ (exist('lpq.m', 'file') == 2)
    websave('lpq.m','http://www.cse.oulu.fi/wsgi/CMV/Downloads/LPQMatlab?action=AttachFile&do=get&target=lpq.m');
end

if ~ (exist('bsif.m', 'file') == 2)
    unzip('http://www.ee.oulu.fi/~jkannala/bsif/bsif_code_and_data.zip');
    movefile('bsif_code_and_data/bsif.m','./');
    movefile('bsif_code_and_data/texturefilters','./');
    rmdir('bsif_code_and_data','s');
end


%% ML-LBP features
%{
% ML params
options = [];
options.level = 3;
options.patterns = [256 256 256]; % LBP basic: 256
options.representation = true;

% get ML-LBP features of face.jpg
img = rgb2gray(imread('face.jpg'));
descriptor = lbp(img(:,:,1),[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1],0,'i');
features = ML(descriptor,options);

%}


%% ML-RGB-LBP features
%{
% ML params
options = [];
options.level = 3;
options.patterns = [256 256 256]; % LBP basic: 256
options.representation = true;

% get ML-RGB-LBP features of face.jpg
img = imread('face.jpg');
descriptor(:,:,1) = lbp(img(:,:,1),[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1],0,'i');
descriptor(:,:,2) = lbp(img(:,:,2),[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1],0,'i');
descriptor(:,:,3) = lbp(img(:,:,3),[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1],0,'i');
features = ML(descriptor,options);

%}


%% ML-HSV-LPQ features
%{
% ML params
options = [];
options.level = 3;
options.patterns = [256 256 256]; % LPQ patterns : 256
options.representation = true;

% get ML-HSV-LPQ features of face.jpg
img = rgb2hsv(imread('face.jpg'));
descriptor(:,:,1) = lpq(img(:,:,1),7,1,1,'im');
descriptor(:,:,2) = lpq(img(:,:,2),7,1,1,'im');
descriptor(:,:,3) = lpq(img(:,:,3),7,1,1,'im');
features = ML(descriptor,options);

%}


%% ML-BSIF features
%{%
load('texturefilters/ICAtextureFilters_9x9_8bit');
% ML params
options = [];
options.level = 3;
options.patterns = 2^size(ICAtextureFilters,3); % BSIF patterns : 2^NumberOfFilters
options.representation = true;

% get ML-HSV-LPQ features of face.jpg
img = rgb2gray(imread('face.jpg'));
descriptor = uint8(bsif(img(:,:,1),ICAtextureFilters,'im'));
features = ML(descriptor,options);

%}

