%% Use 2-D FFT to View the Frequency Components of an Image
% Visualize original image and its FFT magnitude response.
function FFT_Im = FFT(I)
%%
% Create the FFT object.
fftObj = vision.FFT;
%%
% Read the image.
I = im2single(I);
I=rgb2gray(I);
%%
% Compute the FFT.
J = fftObj(I);
%%
% Shift zero-frequency components to the center of spectrum.
J_shifted = fftshift(J);
%%
% Display original image and visualize its FFT magnitude response.
%figure; imshow(I);
%title('Input image, I'); 
%figure; 
%imshow(log(max(abs(J_shifted), 1e-6)),[]),colormap(jet(64));
%title('Magnitude of the FFT of I');
FFT_Im=log(max(abs(J_shifted), 1e-6));
