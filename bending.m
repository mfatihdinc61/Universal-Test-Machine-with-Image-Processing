cam = webcam('DroidCam Source 3');
preview(cam)
% img = snapshot(cam)
k=1;

for i=1:1:50
a= tic; 
img = snapshot(cam);
b{i}={img};
tEnd = toc(a);
pause(0.1-tEnd);
end

disp("Photographing is done, you can move the camera")


for i=1:1:50
% A = imread('bending.jpeg');
I = rgb2gray(cell2mat(b{i}));
I = imbinarize(I);
I = ~I;

stats1 = regionprops('table', I, 'Centroid', 'Eccentricity', 'EquivDiameter');
stats = regionprops('table', I, 'Centroid', 'Eccentricity', 'EquivDiameter');


stats( stats.Eccentricity > .6 , : ) = [];
stats( stats.EquivDiameter > 30 | stats.EquivDiameter < 5 , : ) = [];

a = size(stats);
if a(1)<3
    continue
end


% stats.Eccentricity(3,1);

% maxx = max(stats.Centroid(:,1));
% minx =min(stats.Centroid(:,1));

X=sort(stats.Centroid(:,1));

X1=X(1);
X2=X(2);
X3=X(3);

Y=sort(stats.Centroid(:,2));
Y1=Y(1);
Y2=Y(2);
Y3=Y(3);

% midplane

x_mid = (X1+X3)/2;
y_mid = (Y1+Y2)/2;

% hypot

x_diff = abs(X2-x_mid);
y_diff = abs(Y1-y_mid);

base_distance = abs(X1-X3);

hyp_pixel = hypot(x_diff,y_diff);


% real-term converter

% max_D =max(stats.EquivDiameter(:,1));
% 
% Real_Dia = 4;
% factor = Real_Dia/max_D;
% 
% hyp_real = factor*hyp_pixel; %cm cinsinden



% strain rate

strain_rate(k) = hyp_pixel/base_distance;
k=k+1;

end

x = 1:1:length(strain_rate);
plot(x,strain_rate);

% I = rgb2gray(cell2mat(b{47}));
% I = imbinarize(I);
% imshow(I)


% % % [B,L] = bwboundaries(I,'noholes');
% % % 
% % % imshow(label2rgb(L,@jet,[.5 .5 .5]))
% % % hold on
% % % for k = 1:length(B)
% % %   boundary = B{k};
% % %   plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
% % % end

% stats = regionprops(L,'Area','Centroid');
% 
% threshold = 0.94;
% 
% % loop over the boundaries
% for k = 1:length(B)
% 
%     plot(centroid(1),centroid(2),'ko');
%   
% end
% 
% [centers,radii] = regionprops(I,'Centroid','EquivDiameter')

