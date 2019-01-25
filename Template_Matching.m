clc;
%clear all;

a1=imread('benten.jpg');
a = rgb2gray(a1);
subplot(2,3,1);
imshow(a);
title('Input Image'); % Target image
A = double(a);
b1=imread('watch.jpg');
b = rgb2gray(b1);
subplot(2,3,2);
imshow(b);
title('Template'); % Template to be found.
B = double(b);
[m,n] = size(B);
[k,l] = size(A);
window = double(zeros(m,n));
win = double(zeros(m,n));
corr_map = zeros([size(A,1),size(A,2)]);

mean_B = mean2(B); %Mean intensity of the template
B_sub = B - mean_B; %zero-mean template 
norm_B_sub = norm(B_sub); 

%Correlation of image with the template
for i=1: k-m
    for j=1: l-n
        window = A(i: i+m -1,j: j+n-1); % window is selected of size of the template
        mean_win = mean2(window); 
        win= window - mean_win; % zero mean intensity of the window of the image
        norm_win = norm(win);
        corr(i,j) = sum(sum(win .* B_sub)); 
        norm_corr = corr/(norm_B_sub * norm_win); %normalized correlation
    end
end

%correlation map
uint8Image = uint8(255 * mat2gray(corr));
subplot(2,3,3);
imshow(uint8Image);
title('Correlation map');

 %normalized correlation
subplot(2,3,4);
imshow(uint8(255 * mat2gray(norm_corr)));
title('Normalized correlation');


%Maximum intesity value in correlation map
maxpt = max(corr(:));
[x,y]=find(corr==maxpt);



%Thresholding
threshold = maxpt;
for i=1:size( corr,1)
    for j=1:size( corr,2)
        value= corr(i,j);
        if value < threshold
            OutputIm2(i,j)=0;
        else
            OutputIm2(i,j)=255;
        end
    end
end 

subplot(2,3,5);
imshow(uint8(255 * mat2gray(OutputIm2)));
title('Threshold image');

%Displaying colored image
grayA = rgb2gray(a1);
Res   = a;
Res(:,:,1)=grayA;
Res(:,:,2)=grayA;
Res(:,:,3)=grayA;

% Matched image
Res(x:x+size(b,1)-1,y:y+size(b,2)-1,:)=a1(x:x+size(b,1)-1,y:y+size(b,2)-1,:);

subplot(2,3,6);
imshow(Res);
title('Matched image');


