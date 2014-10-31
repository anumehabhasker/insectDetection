clc;

clear all;
close all;

% this variable should be the area of the bounding box of the smallest
% insect on all the images. This will help determine how many false
% positives we get.

area_of_smallest_insect=1500; % in pixels

cluster_counter=1;
pixel_counter=1;
temp=0;
location=zeros(5);
side_sweeper=30;

% This variable counts the number of insects we think exist in the picture

count=0;

% Anumehas code

Original=imread('img6.tif');   % Store the original image 

%  make the corners of the image white to avoid corner errors
   
sizes=size(Original);
   for x=1:sizes(2)
       for y=1:side_sweeper
           Original(y,x,:)=255;
       end
   end
   
   for y=1:sizes(1)
       for x=1:side_sweeper
            Original(y,x,:)=255;
       end
   end
   
   for x=1:sizes(2)
       for y=sizes(1)-side_sweeper:sizes(1)
           Original(y,x,:)=255;
       end
   end 
   
   for y=1:sizes(1)
       for x=sizes(2)-side_sweeper:sizes(2)
            Original(y,x,:)=255;
       end
   end

I=Original;                                                         % copy the original image into I
BW = im2bw(I, 0.8);
B = ordfilt2(BW,220,true(20));                                      % B the black and white, filtered copy of I
T1=~B;                                                              % T1 is the negative of B
iFill=imfill(T1,'holes');
[iLabel1 num]=bwlabel(iFill); % blob analysis starts here


iprops=regionprops(iLabel1);

ibox=[iprops.BoundingBox];
ibox=reshape(ibox, [4 num]);

% Show the original image

imshow(Original)

hold on;


for cnt=1:num
    
   % Store in a temporary variable
   
   temp=ibox(:,cnt);
   
   % Calculate the area of each bounding box
   
   area_of_box=temp(3)*temp(4);
   
   areas(cnt)=area_of_box;
   
   % If the area of the bounding box is smaller than the smallest insect we
   % neglect it, else we draw the rectangle around the insect
   
   if(area_of_box>area_of_smallest_insect)
   
   temp(1)=temp(1)-30;
   temp(2)=temp(2)-30;
   temp(3)=temp(3)+60;
   temp(4)=temp(4)+60;
   rect=rectangle('position', temp,'edgecolor', 'r'); 
   
   % make the bounding boxes white in the original image
   
   for x=temp(1)+0.5:temp(1)+temp(3)+0.5
       for y=temp(2)+0.5:1:temp(2)+temp(4)+0.5
          I(y,x,:)=255;
   
       end
   end
   
    
   %
   
   
   % This variable counts the number of insects that we have recognised 
   
   count=count+1;
   
   end
   
   
end

figure;

imshow(I);

% This is the image for the second round

edited_image=I;

% Filter the original image to spot the small objects
BW = im2bw(Original, 0.82);
B = ordfilt2(BW,70,true(10));
T2=~B;

% stop here and show this

figure;
imshow(T2);
   
% and it with the not of the edited image we just created

BW = im2bw(edited_image, 0.8);
imshow(BW);
B = ordfilt2(BW,70,true(10));                                      % B the black and white, filtered copy of I
T1=~B;
figure;
imshow(T1)
T3=T2&(~T1);

figure;
imshow(T3);

% stop here
iFill=imfill(T3,'holes');
[iLabel3 num]=bwlabel(iFill); % blob analysis starts here


iprops=regionprops(iLabel3);
ibox=[iprops.BoundingBox];
ibox=reshape(ibox, [4 num]);
imshow(Original)

hold on;

for cnt=1:num
    
   % Store in a temporary variable
   
   temp=ibox(:,cnt);
   
   % Calculate the area of each bounding box
   
   area_of_box=temp(3)*temp(4);
   
   areas(cnt)=area_of_box;
   
   % If the area of the bounding box is smaller than the smallest insect we
   % neglect it, else we draw the rectangle around the insect
   
   if(area_of_box<area_of_smallest_insect)
   
   temp(1)=temp(1)-30;
   temp(2)=temp(2)-30;
   temp(3)=temp(3)+60;
   temp(4)=temp(4)+60;
   rect=rectangle('position', temp,'edgecolor', 'r'); 
   
 
   
   % This variable counts the number of insects that we have recognised 
   
   count=count+1;
   
   end
   
   
end
