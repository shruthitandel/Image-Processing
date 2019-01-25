clc;
close all;
clear all;

img_1=imread('capitol.jpg');
%img_1 = rgb2gray(a);
subplot(2,3,1);
imshow(img_1);
title('Input image');
input_img = im2double(img_1);
[m,n]=size(input_img); %size of input image
z=ones(3); %mask size is 3x3
[p,q]=size(z);
smooth = zeros(m,n);

%Padding with zeroes
w=1:p;
x=round(median(w));
anz=zeros(m+2*(x-1),n+2*(x-1));


for i=x:(m+(x-1))
    for j=x:(n+(x-1))
        anz(i,j)=img_1(i-(x-1),j-(x-1));
    end
end


% smoothing of image 
sum=0;
x=0;
y=0;
for i=1:m
    for j=1:n
        for k=1:p
            for l=1:q 
                sum= sum+anz(i+x,j+y)*z(k,l);
                y=y+1;
            end
            y=0;
            x=x+1;
        end
        x=0;
        smooth(i,j)=(1/(p*q))*(sum);
        sum=0;
    end
end
subplot(2,3,2);
imshow(uint8(smooth));
title('smoothed image');

C=double(smooth);
[e,f] = size(smooth);
edge = zeros(e,f);
dir = zeros(e,f);

% % Edge detection
  Gx = zeros(e,f);
  Gy = zeros(e,f);

for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %1x3 i.e. [-1,0,1] mask for x-derivative:
          dx = C(i+1,j+2)- C(i+1,j);
          Gx(i,j) = C(i+1,j+2)- C(i+1,j);
        % 3x1 i.e. [-1;0;1] mask for y-derivative:
          dy = C(i+2,j+1)- C(i,j+1);
          Gy(i,j) = C(i+2,j+1)- C(i,j+1);
        
        %The magnitude of the gradient of the image
        edge(i,j) =sqrt(dx.^2+dy.^2);
        %Direction of the gradient of image
        dir(i,j) = atan2(dy,dx);
        %dir(i,j) =((atan2(Gy,Gx)+pi)*180)/pi; 
      
    end
end



subplot(2,3,3);
imshow(uint8(255 * mat2gray(Gx))); 
title('x-derivative');

subplot(2,3,4);
imshow(uint8(255 * mat2gray(Gy))); 
title('y-derivative');

subplot(2,3,5);
imshow(uint8(255 * mat2gray(edge)));
title('Gradient Magnitude');
subplot(2,3,6);
imshow(uint8(255 * mat2gray(dir)));
title('Gradient Direction');
