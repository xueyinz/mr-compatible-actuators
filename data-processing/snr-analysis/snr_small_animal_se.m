%% AMME4112
% Xue Yin Zhang
% 2018

clearvars;
close all;

saving = false;
horizontal_ROI = true;  % direction 

%% file paths

path = '.../chosen-data-small-animal-se/'; % put in your correct path
files = dir(strcat(path,'*.dcm'));
n_files = length(files);

%% definitions

air_on.ii = 3:5;
air_off.ii = 7:9;
ceramic_off.ii = 12:14;
ceramic_on.ii = 15:17;
piston_off.ii = 18:20;
piston_on.ii = 21:23;
slide.ii = 24:26;
encoder.ii = 27:29;
phantom.ii = 30:32;

labels = {'Baseline',...
    'Air motor off', 'Air motor on',...
    'Ceramic motor off', 'Ceramic motor on',...
    'Cylinder off', 'Cylinder on',...
    'Encoder',...
    'Slide'};
c = categorical(labels);
c = reordercats(c, labels);

% regions of interest
x_signal = 96:160;
y_signal = 48:80;

if horizontal_ROI == true
    % horizontal ROI
    x_background1 = 200:240;
    y_background1 = 8:120;
    x_background2 = 16:56;
    y_background2 = 8:120;
else
    % vertical ROI
    x_background1 = 16:240;
    y_background1 = 8:30;
    x_background2 = 16:240;
    y_background2 = 100:120;
end

%% calculate SNR

for ii = 1:n_files
    
    info = dicominfo(strcat(path, files(ii).name));
    Y = dicomread(info);
    Y_double = double(Y);
    
    if (saving == true)
        
        % save dicom image
        Y_image = uint8(255 * mat2gray(Y));
        imshow(Y_image, []);
        name = strcat(files(ii).name(1:4), '.png');
        daspect([1 2 1]);
        F = getframe(gca);
        imwrite(F.cdata, name, 'png');
        
        % contrast adjusted images
        if (ii == 5) || (ii == 17) || (ii == 22) || (ii == 31)
            Y_image = imadjust(Y_image, [0 0.2],[]);
            imshow(Y_image, []);
            name = strcat(files(ii).name(1:4), 'contrast.png');
            daspect([1 2 1]);
            F = getframe(gca);
            imwrite(F.cdata, name, 'png');
        end
        
        % regions of interest
        if (ii == 17)
            
            % ceramic
            imshow(Y, []);
            rectangle('Position',[y_signal(1), x_signal(1), y_signal(end)-y_signal(1), x_signal(end)-x_signal(1)],...
                'LineStyle', '-', 'EdgeColor', 'r');
            rectangle('Position',[y_background1(1), x_background1(1), y_background1(end)-y_background1(1), x_background1(end)-x_background1(1)],...
                'LineStyle', '-', 'EdgeColor', 'b');
            rectangle('Position',[y_background2(1), x_background2(1), y_background2(end)-y_background2(1), x_background2(end)-x_background2(1)],...
                'LineStyle', '-', 'EdgeColor', 'b');
            daspect([1 2 1]);
            F = getframe(gca);
            imwrite(F.cdata, 'ROI_CPC.png');
            
            % ceramic contrast adjusted
            IMG_8 = uint8(255 * mat2gray(double(Y)));
            IMG_8 = imadjust(IMG_8, [0 0.2], [0 1]);
            imshow(IMG_8, []);
            rectangle('Position',[y_signal(1), x_signal(1), y_signal(end)-y_signal(1), x_signal(end)-x_signal(1)],...
                'LineStyle', '-', 'EdgeColor', 'r');
            rectangle('Position',[y_background1(1), x_background1(1), y_background1(end)-y_background1(1), x_background1(end)-x_background1(1)],...
                'LineStyle', '-', 'EdgeColor', 'b');
            rectangle('Position',[y_background2(1), x_background2(1), y_background2(end)-y_background2(1), x_background2(end)-x_background2(1)],...
                'LineStyle', '-', 'EdgeColor', 'b');
            daspect([1 2 1]);
            F = getframe(gca);
            imwrite(F.cdata, 'ROI_cer_horiz.png');
            
        end
        
    end
    
    % actual SNR calculation
    mu_signal = mean2(Y_double(x_signal, y_signal));
    sigma_background1 = std2([Y_double(x_background1, y_background1), Y_double(x_background2, y_background2)]);
    files(ii).snr = mu_signal/sigma_background1;

end

phantom.snr = mean([files(phantom.ii).snr]);
phantom.std = std([files(phantom.ii).snr]);
air_on.snr = mean([files(air_on.ii).snr]);
air_on.std = std([files(air_on.ii).snr]);
air_off.snr = mean([files(air_off.ii).snr]);
air_off.std = std([files(air_off.ii).snr]);
ceramic_on.snr = mean([files(ceramic_on.ii).snr]);
ceramic_on.std = std([files(ceramic_on.ii).snr]);
ceramic_off.snr = mean([files(ceramic_off.ii).snr]);
ceramic_off.std = std([files(ceramic_off.ii).snr]);
piston_on.snr = mean([files(piston_on.ii).snr]);
piston_on.std = std([files(piston_on.ii).snr]);
piston_off.snr = mean([files(piston_off.ii).snr]);
piston_off.std = std([files(piston_off.ii).snr]);
slide.snr = mean([files(slide.ii).snr]);
slide.std = std([files(slide.ii).snr]);
encoder.snr = mean([files(encoder.ii).snr]);
encoder.std = std([files(encoder.ii).snr]);

%% plotting

h = figure;
snr = [phantom.snr;
    air_off.snr; air_on.snr;
    ceramic_off.snr; ceramic_on.snr;
    piston_off.snr; piston_on.snr;
    encoder.snr;
    slide.snr];
st_dev = [phantom.std;
    air_off.std; air_on.std;
    ceramic_off.std; ceramic_on.std;
    piston_off.std; piston_on.std;
    encoder.std;
    slide.std];
b = bar(c, snr);

% colours
default_colours = get(gca,'colororder');
b.FaceColor = 'flat';
b.CData(1,:) = default_colours(1,:);
b.CData(2,:) = default_colours(2,:);
b.CData(3,:) = default_colours(2,:);
b.CData(4,:) = default_colours(3,:);
b.CData(5,:) = default_colours(3,:);
b.CData(6,:) = default_colours(4,:);
b.CData(7,:) = default_colours(4,:);
b.CData(8,:) = default_colours(5,:);
b.CData(9,:) = default_colours(6,:);

grid on;
ylabel('SNR');
hold on;
errorbar(c, snr, st_dev, '.k');
legend('Mean', 'Standard deviation', 'Location', 'southeast');
title('SNR for each item tested on the 7T small animal system');
if saving == true
    set(h,'Units', 'Inches');
    pos = get(h, 'Position');
    set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
    print(h, 'snr_CPC', '-dpdf', '-r0');
end
