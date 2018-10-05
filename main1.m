I = imread('15_3.jpg');
% I = imrotate(I,90);
[M N] = size(I(:,:,1));
J = I;
Y = rgb2ycbcr(J);
Cr = Y(:,:,3);
%YCbCr通道的皮肤提取（另开了函数进行实现）
mask0 = GetMask(Cr);
imshow(mask0);
se = strel('disk',30);
mask = imdilate(mask0,se);
mask = imerode(mask,se);
mask0 = imerode(mask0,se);
H = zeros(M,N,3);
J = im2double(J);
H(:,:,1) = mask.*J(:,:,1);
H(:,:,2) = mask.*J(:,:,2);
H(:,:,3) = mask.*J(:,:,3);
%RGB提取皮肤（对脸部区域较大的图片较适用）
% for i = 1:M
%     for j = 1:N
%         R = I(i,j,1);G = I(i,j,2);B = I(i,j,3);
%         Imax = max([R,G,B]);
%         Imin = min([R,G,B]);
%         if(R>95 && G>40 && B>20 && (Imax - Imin >15)&&abs(R-G)>15&&R>G&&R>B)
%             H(i,j,1) = R;
%             H(i,j,2) = G;
%             H(i,j,3) = B;
%         else
%             if(R>20&&G>210&&B>170&&(R-B<=15)&&R>B&&G>B)
%                 H(i,j,1) = R;
%                 H(i,j,2) = G;
%                 H(i,j,3) = B;
%             end
%         end
%     end
% end
% mask0 = H(:,:,1);
% mask0(mask0>0) = 1;
% mask = imdilate(mask0,se);
Whiten = zeros(M,N,3); 
%美白图层
Whiten(:,:,1) = 10*mask;
Whiten(:,:,2) = 10*mask;
Whiten(:,:,3) = 10*mask;
H = H*256;
%模糊
w=fspecial('gaussian',[100 100],15);
F=imfilter(H,w);
F = F+Whiten;
F = uint8(F);
%图层融合
for i = 1:M
    for j = 1:N
        if(mask0(i,j)>0)
            I(i,j,1) = 0.5*I(i,j,1)+0.5*F(i,j,1);
            I(i,j,2) = 0.5*I(i,j,2)+0.5*F(i,j,2);
            I(i,j,3) = 0.5*I(i,j,3)+0.5*F(i,j,3);
        end
    end
end
%图像锐化
I(:,:,1) = BLPF_sharp(I(:,:,1));
I(:,:,2) = BLPF_sharp(I(:,:,2));
I(:,:,3) = BLPF_sharp(I(:,:,3));
I = uint8(I);
figure(2),
imshow(I);
