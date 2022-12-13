I = imread('hardness.jpeg');
imshow(I);

I = rgb2gray(I);
I = imbinarize(I);
I = ~I;

stats = regionprops('table', I, 'Centroid', 'Eccentricity', 'EquivDiameter');

stats( stats.Eccentricity > .4 | stats.Eccentricity < 0.05, :) = [];
stats( stats.EquivDiameter > 150 | stats.EquivDiameter < 10 , : ) = [];

stats = sortrows(stats,3);

g=9.81;
D_indentor = 10;
fixer = (30/max(stats.EquivDiameter(:)));
d_min_real_mm = fixer*min(stats.EquivDiameter(:));

F = 3000*g;

BHN = (2*F)/(pi*D_indentor*g*(D_indentor-sqrt(D_indentor.^2-d_min_real_mm.^2))) ;
BHN = round(BHN);

results = table(BHN,d_min_real_mm,D_indentor)
figure
imshow(I)
% object check 

% [B,L] = bwboundaries(I,'noholes');
% 
% imshow(label2rgb(L,@jet,[.5 .5 .5]))
% hold on
% for k = 1:length(B)
%   boundary = B{k};
%   plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
% end