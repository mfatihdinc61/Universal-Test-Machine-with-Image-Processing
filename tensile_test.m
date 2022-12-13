cam = webcam('DroidCam Source 3');
preview(cam)
flag = 0;

for i=1:1:100
a= tic; 
img = snapshot(cam);
b{i}={img};
tEnd = toc(a);
pause(0.1-tEnd);
end

t=0;
for i=1:1:100

    
arealar = 0;
RGB = (cell2mat(b{i}));

% imshow(RGB)

I = rgb2gray(RGB);
bw = imbinarize(I);
bw = ~bw;

% imshow(bw)

bw = bwareaopen(bw,5);
% imshow(bw)

se = strel('disk',2);
% bw = imclose(bw,se);
% imshow(bw)

% bw = imfill(bw,'holes');
% imshow(bw)

[B,L] = bwboundaries(bw,'noholes');

 imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end

% imshow(bw)

stats = regionprops(L,'Area','Centroid','EquivDiameter');

threshold = 0.75;
threshold_up = 0.99;
% loop over the boundaries
  m=1;
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
  
  % display the results
  metric_string = sprintf('%2.2f',metric);
  
%   diameters = regionprops(L,'EquivDiameter');
%   diameters = struct2array(diameters);  

  % mark objects above the threshold with a black circle
  if metric > threshold && metric < threshold_up
      
    centroid = stats(k).Centroid;
%     diameters = regionprops(L,'EquivDiameter');
%     diameters = struct2array(diameters);

% added code for processed image
if i==50
if flag==0
    imshow(bw);
    hold on
end
    flag = 1;
    
    hold on
     plot(centroid(1),centroid(2),'ko');
     
      text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold')
   
   title(['Roundess Values ',...
       'of the detected parts'])
   hold on
end
if i==51
    hold off
end
% added code end

    x_cordinate(m)=centroid(1);
    arealar(m) = stats(k).Area;
    diameters(m)=stats(k).EquivDiameter;
    m=m+1;
  else 
      continue;
  end
  
 
   
  
end

 
% if m ~= 3
%     continue;
% end
   
if arealar ~=0
[sortedX, sortedInds] = sort(arealar(:),'descend');
if t==0
    reference=x_cordinate(sortedInds(1));
end
t=t+1;
pix_fixer = 40/diameters(sortedInds(1));
distance = x_cordinate(sortedInds(2))-reference;
real_distance(t) = pix_fixer*distance;

else
    continue;
end

end

% plot(x,real_distance);

for i=1:(t-1)
speed_distances(i) = real_distance(i+1)-real_distance(i);
end

speed = (speed_distances/0.1);

subplot(2,1,1);
x = 0.1:0.1:(t*(0.1));
plot(x,-real_distance)
xlabel('time (second)')
ylabel('distance (mm)')
title('time vs position')


subplot(2,1,2);
x = 0.1:0.1:((t-1)*0.1)
plot(x,speed)
xlabel('time (second)')
ylabel('speed (mm/s)')
ylim([-20 20])
title('time vs velocity')
