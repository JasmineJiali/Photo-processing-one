% I = imread('1230_3.jpg'); 
% % imshow(I);
% I = rgb2gray(I);
function bimg = BLPF_sharp(I)
s=fftshift(fft2(I));
[M,N]=size(s);                    
n=2;                                  
d0=30; %BLPF滤波，d0=30,50（视图像大小及最终效果而定                  
n1=floor(M/2);                          
n2=floor(N/2);  
h = zeros(M,N);
for i=1:M 
    for j=1:N
        d=sqrt((i-n1)^2+(j-n2)^2);         
        h(i,j)=1/(1+(d0/d)^(2*n));   
        s(i,j)=h(i,j)*s(i,j);                   
    end
end
% h = glpf(15,M,N);
% s = h.*s;
s=ifftshift(s);                           
bImg=uint8(real(ifft2(s)));
bimg = I + bImg;
figure(3),                              
imshow(bImg); 