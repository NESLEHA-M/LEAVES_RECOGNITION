%% Marek Nesleha, 223631
%% Leaves recognizer
%% Done for Vision System VIS1-ME-A18, Exam date d.4.1.2019

%% Read each image and template. while also turning them to grayscale
IM = imread('LEAVES.jpg'); IM=rgb2gray(IM);               %% Template image to find leaves on    
T1 = imread('BIRCH_TEMPLATE.jpg'); T1=rgb2gray(T1);       %% Birch template         
T2 = imread('HAZEL_TEMPLATE.jpg'); T2=rgb2gray(T2);       %% Hazel template   
T3 = imread('OAK_TEMPLATE.jpg'); T3=rgb2gray(T3);         %% Oak template 
T4 = imread('BEECH_TEMPLATE.jpg'); T4=rgb2gray(T4);       %% Beech template           

% Ticking sound when running the code
[y,f]=audioread('CLOCK.WAV');
player = audioplayer(y,f);
play(player);

%% Images are too big, I will hide the warning as it is dependant on monitor
warning('off','all')

%% Extracting template data/size, for X and Y:

T1LengthX=size(T1,2);
T1LengthY=size(T1,1);

T2LengthX=size(T2,2);
T2LengthY=size(T2,1);

T3LengthX=size(T3,2);
T3LengthY=size(T3,1);

T4LengthX=size(T4,2);
T4LengthY=size(T4,1);

%% See the montage of parent vs template (Turned off):

% imshowpair(IM,T1,'montage');
% imshowpair(IM,T2,'montage');
% imshowpair(IM,T3,'montage');
% imshowpair(IM,T4,'montage');


%% Finding the correlation between image and each template:

C1=normxcorr2(T1,IM);
C2=normxcorr2(T2,IM);
C3=normxcorr2(T3,IM);
C4=normxcorr2(T4,IM);

%% Corners for the image in correlation matrix C1-C4 (floor=rounding, for boundaries)

Ymin1=floor(T1LengthY/2); Xmin1=floor(T1LengthX/2);  
Ymax1=size(C1,1)-Ymin1; Xmax1=size(C1,2)-Xmin1;      

Ymin2=floor(T2LengthY/2); Xmin2=floor(T2LengthX/2);  
Ymax2=size(C2,1)-Ymin2; Xmax2=size(C2,2)-Xmin2;      

Ymin3=floor(T3LengthY/2); Xmin3=floor(T3LengthX/2);  
Ymax3=size(C3,1)-Ymin3; Xmax3=size(C3,2)-Xmin3;      

Ymin4=floor(T4LengthY/2); Xmin4=floor(T4LengthX/2);  
Ymax4=size(C4,1)-Ymin4; Xmax4=size(C4,2)-Xmin4;      

%% Correlation matrix resized to image (the numbers from the matrix - show it as an image)

A1=C1(Ymin1:Ymax1,Xmin1:Xmax1);
A2=C2(Ymin2:Ymax2,Xmin2:Xmax2);
A3=C3(Ymin3:Ymax3,Xmin3:Xmax3);
A4=C4(Ymin4:Ymax4,Xmin4:Xmax4);

%% Surface plot of the correlation between the image and template (Turned off)

% figure('Name','Correlation Image A1 - Birch','NumberTitle','off'), surf(A1), shading flat;
% figure('Name','Correlation Image A2 - Hazel','NumberTitle','off'), surf(A2), shading flat;
% figure('Name','Correlation Image A3 - Oak','NumberTitle','off'), surf(A3), shading flat;
% figure('Name','Correlation Image A4 - Beech','NumberTitle','off'), surf(A4), shading flat;


%% Putting the marker on the results - finding the centres, then same steps for A2, A3, A4

%% Final figure - can be turned off and then turn on figure for each tree

figure('Name','Trees Found','NumberTitle','off'); hAx  = axes;
imshow(IM, 'Parent', hAx)

%% A1
% Normalize input data to range in [0,1].
Xmin1 = min(A1(:));
Xmax1 = max(A1(:));
if isequal(Xmax1,Xmin1)
    A1 = 0*A1;
else
    A1 = (A1 - Xmin1) ./ (Xmax1 - Xmin1);
end

% Threshold image - manual threshold
AMT1 = A1 > 0.9;

% Clear borders
AMT1 = imclearborder(AMT1);

% Finding the centroid to put a marker
s1  = regionprops(AMT1,'centroid');
c1=cat(1,s1.Centroid);
number1=size(c1); number1=number1(1,1);
% main graph with found trees marked with a rectangle
%hFig1=figure('Name','A1s Found','NumberTitle','off'); hAx  = axes;
%imshow(IM, 'Parent', hAx)
for a=1:number1
    Ycenter1=c1(a,2); Xcenter1=c1(a,1);
    YmarkerMin1 = Ycenter1-T1LengthY/2; XmarkerMin1 = Xcenter1-T1LengthX/2;
    RECT1=imrect(hAx, [XmarkerMin1, YmarkerMin1, T1LengthX, T1LengthY]);
    setColor(RECT1,'magenta');
    hold on
end


%% A2
Xmin2 = min(A2(:));
Xmax2 = max(A2(:));
if isequal(Xmax2,Xmin2)
    A2 = 0*A2;
else
    A2 = (A2 - Xmin2) ./ (Xmax2 - Xmin2);
end

AMT2 = A2 > 0.76;
AMT2 = imclearborder(AMT2);
s2  = regionprops(AMT2,'centroid');
c2=cat(1,s2.Centroid);
number2=size(c2); number2=number2(1,1);
%hFig2 = figure('Name','A2s Found','NumberTitle','off'); hAx  = axes;
%imshow(IM, 'Parent', hAx2)
for a=1:number2
    Ycenter2=c2(a,2); Xcenter=c2(a,1);
    YmarkerMin2 = Ycenter2-T2LengthY/2; XmarkerMin2 = Xcenter-T2LengthX/2;
    RECT2=imrect(hAx, [XmarkerMin2, YmarkerMin2, T2LengthX, T2LengthY]);
    setColor(RECT2,'blue');
    hold on
end

%% A3
Xmin3 = min(A3(:));
Xmax3 = max(A3(:));
if isequal(Xmax3,Xmin3)
    A3 = 0*A3;
else
    A3 = (A3 - Xmin3) ./ (Xmax3 - Xmin3);
end
AMT3 = A3 > 0.95;
AMT3 = imclearborder(AMT3);
s3  = regionprops(AMT3,'centroid');
c3=cat(1,s3.Centroid);
number3=size(c3); number3=number3(1,1);
%hFig = figure('Name','A3s Found','NumberTitle','off'); hAx  = axes;
%imshow(IM, 'Parent', hAx3)
for b=1:number3
    Ycenter3=c3(b,2); Xcenter3=c3(b,1);
    YmarkerMin3 = Ycenter3-T3LengthY/2; XmarkerMin3 = Xcenter3-T3LengthX/2;
    RECT3=imrect(hAx, [XmarkerMin3, YmarkerMin3, T3LengthX, T3LengthY]);
    setColor(RECT3,'green');
    hold on
end

%% A4
Xmin4 = min(A4(:));
Xmax4 = max(A4(:));
if isequal(Xmax4,Xmin4)
    A4 = 0*A4;
else
    A4 = (A4 - Xmin4) ./ (Xmax4 - Xmin4);
end

AMT4 = A4 > 0.9;
AMT4 = imclearborder(AMT4);
s4  = regionprops(AMT4,'centroid');
c4=cat(1,s4.Centroid);
number4=size(c4); number4=number4(1,1);
%hFig4 = figure('Name','A4s Found','NumberTitle','off'); hAx  = axes;
%imshow(IM, 'Parent', hAx4)
for i=1:number4
    Ycenter4=c4(i,2); Xcenter4=c4(i,1);
    YmarkerMin4 = Ycenter4-T4LengthY/2; XmarkerMin4 = Xcenter4-T4LengthX/2;
    RECT4=imrect(hAx, [XmarkerMin4, YmarkerMin4, T4LengthX, T4LengthY]);
    setColor(RECT4,'red');
    hold on
end

%% Adding the colored textbox to field - to recognize the brand

%We need to add it, since Matlabs Rectangle imrect function does not
%support ading a text box or a notation of it.

dim = [.0 .5 .3 .5];
str = ['Birches found : ',num2str(number1,'%d')];
annotation('textbox',dim,'String',str,'FitBoxToText','on','Color','magenta');

dim = [.0 .40 .3 .5];
str = ['Hazels found : ',num2str(number2,'%d')];
annotation('textbox',dim,'String',str,'FitBoxToText','on','Color','blue');

dim = [.0 .3 .3 .5];
str = ['Oaks found : ',num2str(number3,'%d')];
annotation('textbox',dim,'String',str,'FitBoxToText','on','Color','green');

dim = [.0 .2 .3 .5];
str = ['Beeches found : ',num2str(number4,'%d')];
annotation('textbox',dim,'String',str,'FitBoxToText','on','Color','red');

%% Display the number of trees found in the command window
disp(['Birches found : ' num2str(number1)]);
disp(['Hazels found : ' num2str(number2)]);
disp(['Oaks found : ' num2str(number3)]);
disp(['Beeches found : ' num2str(number4)]);

%% Play a sound when when the recognition is finished
stop(player)
 [y,Fs] = audioread('DING.wav');
 for a=1:4
    sound(y,Fs);
    pause(0.4);
 end
 
%% Trees should be found and shown at this moment
%% END  