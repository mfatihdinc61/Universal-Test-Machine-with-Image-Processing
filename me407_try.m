
horizontal_distance = zeros(100,1);
cam = webcam('Integrated camera');
preview(cam)

for i=1:1:100


img = snapshot(cam);

% dot_pic = imread('dots_2.jpg');
dot_pic = img;
% figure,imshow(dot_pic);

grayified = rgb2gray(dot_pic);
% figure,imshow(grayified);

se = strel('disk',18);
background = imclose(grayified,se);
% figure,imshow(background);

subtracted_photo = imsubtract(background,grayified);
% figure,imshow(subtracted_photo)

dots = imbinarize(subtracted_photo);
% figure,imshow(dots);

targetSize = [300 650];
r = centerCropWindow2d(size(dots),targetSize);

J = imcrop(dots,r);
imshow(J)
[labels,order] = bwlabel(J,4);


coordinate_dots = regionprops(labels,'centroid');


data_double = struct2array(coordinate_dots);

horizontal_distance(i) = data_double(3)-data_double(1);

end

x = 1:1:100;

horizontal_distance_mm = horizontal_distance*(300/1280);

plot(x,horizontal_distance_mm)
xlabel('picture order');
ylabel('horizontal distance');
