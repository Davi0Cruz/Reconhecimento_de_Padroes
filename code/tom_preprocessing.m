% Routines for opening face images and convert them to column vectors
% by stacking the columns of the face matrix one beneath the other.
%
% Last modification: 10/08/2021
% Author: Guilherme Barreto

clear; clc; close all;

pkg load image;
pkg load statistics;

Imagesize = 20; 
internos = glob('../faces/sub*');
externos = glob('../faces/*.gif');

X=[];
Xi=[];
Xe=[];
Y=[]; 
Z=[];

for i = 1:length(internos),  
    img = imread(internos{i});
    Ar = imresize(img, [Imagesize Imagesize]);   
    A = im2double(Ar);  
    a = A(:);  
    ROT = 1;
    X = [X a];
    Xi = [Xi a]; 
    Y = [Y ROT];
end

for i = 1:length(externos), 
    img = imread(externos{i});
    Ar = imresize(img, [Imagesize Imagesize]);   
    A = im2double(Ar);  
    a = A(:); 
    ROT = 2;
    X = [X a]; 
    Xe = [Xe a];
    Y = [Y ROT]; 
end
Z = [X; Y];  
Z = Z';

save -ascii model1.dat Z 
X1 = {Xi, Xe};
save -7 model11.dat X1;

[V L VEi] = pcacov(cov(X'));
VEq = cumsum(VEi);
q = find(VEq >= 98.0)(1);  
disp(sprintf('PCA: Variância explicada acumulada (98%% - %d componentes)', q));
Vq = V(:,1:q); Qq = Vq';
X = Qq * X; 
Z = [X; Y];
Z = Z';
save -ascii model2.dat Z
[V L VEi] = pcacov(cov(Xi'));
VEq = cumsum(VEi);
q = find(VEq >= 98.0)(1);
disp(sprintf('PCA: Variância explicada acumulada (98%% - %d componentes)', q));
Vq = V(:,1:q); Qq = Vq';
Xi = Qq * Xi;
Xe = Qq * Xe;
X2 = {Xi, Xe};
save -7 model22.dat X2;

