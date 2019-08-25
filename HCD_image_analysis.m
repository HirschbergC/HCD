%Image analysis of powder caking analyzed with the Hirschberg caking device
%(HCD)
%Authors: Cosima Hirschberg, Johan Boetker
%This script extracts the information of an image taken from above a sample
%setup after a sample has been sconditioned. The pixels of the entire setup
%and of the powder are counted and a fraction is calculated. Furthermore
%several images are created as quality control tools during the analysis.

clear; clc; close all;
% loading of the image file
imagefiles=('image.JPG');

currentimage=imread(imagefiles);
a=double(currentimage);
%the image is split in red green and blue channel to identify the HCD and
%the powder in the image.
red=a(:,:,1);
%this threshold might have to be corrected due to differences in the
%lighting. An image created lateron in the script is used as a control to
%identify if the threshold need to be changed.
R=red>110; 
%the number of identifyed pixels is counted
Rtotal=sum(R(:));

green=a(:,:,2);
G=a(:,:,2);

blue=a(:,:,3);
%this threshold might have to be corrected due to differences in the
%lighting. An image created lateron in the script is used as a control to
%identify if the threshold need to be changed.
B=blue>95; 

%Excluding false positives for identified powder on the setup mainly due to
%light reflections
B2=bwareaopen(B,200000);
%the number of pixels is counted
Btotal=sum(B2(:));
%Fraction of the HCD covered in powder is calculated
Powder=Btotal/Rtotal*100; 

%Quality control of the analysis, therefore several images are plotted
%showing the identified areas in the image with the HCD and the powder,
%furthermore a picture is generated in which the identified powder on the
%setup is circles in red
figure
subplot(4,2,1); imagesc(currentimage);
set(gca,'XTickLabel','');set(gca,'YTickLabel','');
subplot(4,2,3); imagesc(red);colormap 'jet' ;colorbar; title 'red';
set(gca,'XTickLabel','');set(gca,'YTickLabel','');
subplot(4,2,4); imagesc(blue);colorbar;title 'blue';
set(gca,'XTickLabel','');set(gca,'YTickLabel','');
subplot(4,2,5); hist(red(:),256);ylim([0 20000]);
subplot(4,2,6); hist(blue(:),256);ylim([0 20000]);
subplot(4,2,7); imagesc(R); colormap 'jet';
set(gca,'XTickLabel','');set(gca,'YTickLabel','');
subplot(4,2,8); imagesc(B2);colormap 'jet';
set(gca,'XTickLabel','');set(gca,'YTickLabel','');

B3=bwboundaries(B2);

for k = 1:length(B3)
   boundary = B3{k};
   if length(boundary)<200
           B3{k,:}=[];            
   end
end
Bound=B3(~cellfun('isempty',B3));

figure; zz=imshow(currentimage); 
axis image
hold on
for k = 1:length(Bound)
   boundary = Bound{k};
   plot(boundary(:,2), boundary(:,1), 'black', 'LineWidth', 3)
end




