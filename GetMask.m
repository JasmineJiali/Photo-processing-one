% I = imread('1230_3_1.bmp');
% H = rgb2ycbcr(I);
% J = H(:,:,3);
function mask = GetMask(J)
%利用Cr通道进行皮肤提取
[M,N] = size(J);
J_hist = imhist(J);
J_hist = J_hist/(M*N);

w = 0;
u = 0;
max_variance = 0;
for i = 1:256
    u = u + (i-1)*J_hist(i);
end
value = 0;
for i = 1:256
    w = w + J_hist(i);
    value = value + (i-1)*J_hist(i);
    t = value/w-u;
    variance = t*t*w/(1-w);
    if(variance>max_variance)
        max_variance = variance;
        threhold = i;
    end
end
J = im2double(J);
%threhold = graythresh(J);
threhold = threhold/256;
J = imbinarize(J,threhold);

mask = J;
% I = ycbcr2rgb(H);
% imshow(J);
