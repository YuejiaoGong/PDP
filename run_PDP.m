%% Saliency Detection Using Pseudo Depth Prior (PDP)
clear, clc, 
close all

%% 1. Parameter Settings
%dataset = 'ECSSD';
dataset = 'PASCAL-S';
algname = 'PDP';
multiscale = [150 250 350];  

SRC = ['Data\',dataset,'\Imgs'];                %Path of input images
RES = ['Data\',dataset,'\saliency_',algname ];   %Path for saving saliency maps
srcSuffix = '.jpg';                             %suffix for your input image

if ~exist(RES, 'dir')
    mkdir(RES);
end
addpath(genpath('Funcs'));

%% 2. Saliency Map Calculation
files = dir(fullfile(SRC, strcat('*', srcSuffix)));

for k=1 : length(files)   
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));
%     disp(k); disp(srcName);    
    srcImg = imread(fullfile(SRC, srcName));   
    PDP_multiLayer(srcImg, multiscale, algname, RES, noSuffixName);  
end


