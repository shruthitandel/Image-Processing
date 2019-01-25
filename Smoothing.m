clc;
clear all;
close all;

img_1=imread('capitol.jpg');
subplot(2,2,1);
imshow(img_1);
title('Input image with noise');
input_img = im2double(img_1);
[m,n]=size(input_img);
b=input('Enter the mask size: ');
z=ones(b);
[p,q]=size(z);

%Padding with zeroes
w=1:p;
x=round(median(w));
anz=zeros(m+2*(x-1),n+2*(x-1));

for i=x:(m+(x-1))
    for j=x:(n+(x-1))
        anz(i,j)=img_1(i-(x-1),j-(x-1));
    end
end


%smoothing the image by using a square filter of size entered by the user
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
        res(i,j)=(1/(p*q))*(sum);
        sum=0;
    end
end

subplot(2,2,2);
%mat2gray normalizes the image in the range 0 to 1. This is then multiplied
%by 255 and then we cast to uint8 to get values in the range 0 to 255.
imshow(uint8(255 * mat2gray(res)));
title('Filtered with 5x5 kernel');
