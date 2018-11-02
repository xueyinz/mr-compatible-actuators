%% AMME4112
% Xue Yin Zhang
% 2018

clearvars;
close all;

%% file paths

path = '.../chosen-data-linac-haste/'; % put in your correct path
files = dir(path);
dirFlags = [files.isdir];
subFolders = files(dirFlags);

%% definitions

labels = {
    'Air motor',...
    'Baseline',...
    'Ceramic motor',...
    'Cylinder',...
    'Stepper motor'};

% regions of interest
x_roi = 45:83;
y_roi = 45:83;

%% calculate SNR

for ii = 3:length(subFolders)
    
    images = dir(strcat(path, subFolders(ii).name, '/*.IMA'));
    n_images  = numel(images);
    snr = zeros(1, n_images-1);
    
    for jj = 1:n_images-1
        
        file1 = images(jj).name;
        file2 = images(jj+1).name;

        % open dicom file
        info1 = dicominfo(strcat(images(jj).folder, '/', file1));
        info2 = dicominfo(strcat(images(jj+1).folder, '/', file2));
        IMG1 = dicomread(info1);
        IMG2 = dicomread(info2);
        IMG_diff_double = double(IMG1) - double(IMG2);

        % convert to the right range for storing as png
        IMG1_8 = uint8(255 * mat2gray(IMG1));
        IMG2_8 = uint8(255 * mat2gray(IMG2));

        % calculate snr
        snr(jj) = sqrt(2) * mean(mean(IMG1(x_roi, y_roi))) / std2(IMG_diff_double(x_roi, y_roi));
        
    end
    
    subFolders(ii).snr = snr;
    
end

%% plotting

t = 1/2:1/2:59.5;

h = figure;
plot(t, subFolders(3).snr, 'LineWidth', 1.5);
hold on;
plot(t, subFolders(4).snr, 'LineWidth', 1.5);
plot(t, subFolders(5).snr, 'LineWidth', 1.5);
plot(t, subFolders(6).snr, 'LineWidth', 1.5);
plot(t, subFolders(7).snr, 'LineWidth', 1.5);
legend(labels);
grid on;
ylabel('SNR');
xlabel('Time (s)');
title('SNR over time for each actuator tested on the 1.5T MRI-LINAC');

%% saving

set(h,'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
print(h, 'snr_ingham_long', '-dpdf', '-r0');