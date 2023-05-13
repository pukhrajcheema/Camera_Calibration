# Camera_Calibration
clc;
clear;
close all;
%folder destination where all the images are kept
folderName = 'C:\Users\cheem\OneDrive\Documents\Desktop\Vision System\Lab8\photosforcalibration';
%making a dataset in matlab containing all the images
imageDataSet = imageSet(folderName);
%extracting images from the imageDataSet.ImageLocation location within the
%dataset
imageFileNames = imageDataSet.ImageLocation;

%detecting the image points means the pixel cordinates and boardsize for
%each checkerboard image
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
%square size is in mm
squareSize = 17;

sizeimagesUsed = size(imageDataSet.ImageLocation,2);

%plotting all the imagePoints on the checkerboard images
for i=1:sizeimagesUsed
im = readimage(imageDataSet,i);
figure;
imshow(im);
hold on;
scatter(imagePoints(:,1,i), imagePoints(:,2,i),'y','o');
hold off;
end


%generating thr real world dimensions in mm for the checkerborad
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

%extrcting, reading and saving first image from the dataset in variable
%imgRef
imgRef = readimage(imageDataSet,1); 
%getting the image size of the image imgRef
imageSize = [size(imgRef,1), size(imgRef,2)];

%getting the cameraParameters 
cameraParams = estimateCameraParameters(imagePoints, worldPoints, 'imageSize', imageSize);

%showing the graph that shows the error from the mean value
figure;
showReprojectionErrors(cameraParams);

%showing extrincis
figure;
showExtrinsics(cameraParams, 'PatternCentric');

%saving the cameraParams variable
save('cameraCalibrationsParams.mat', 'cameraParams');

