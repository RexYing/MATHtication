%% Export data for current jaw
% 
% raw
% sampling
% cropped
%

docNode = com.mathworks.xml.XMLUtils.createDocument('mathtication');
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('upper_jaw_name', 'upper_cropped-downsampled.ply');
docRootNode.setAttribute('lower_jaw_name', 'lower_cropped-downsampled.ply');

axesElem = docNode.createElement('axes');
docRootNode.appendChild(axesElem);

%% axes raw
axesSubElem = docNode.createElement('axes_raw');
axesElem.appendChild(axesSubElem);
axesLower = docNode.createElement('lower');
axesUpper = docNode.createElement('upper');
axesSubElem.appendChild(axesLower);
axesSubElem.appendChild(axesUpper);
for i = 1: 3
    % Lower Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axes_lower_raw(:, i)) ));
    axesLower.appendChild(axis);
    
    % Upper Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axes_upper_raw(:, i)) ));
    axesUpper.appendChild(axis);
end
clearvars axesRawElem;

%% axes sample 
sampleSize = 2000;

axesSubElem = docNode.createElement('axes_FM');
axesSubElem.setAttribute('sample_size', int2str(sampleSize));
axesElem.appendChild(axesSubElem);
axesLower = docNode.createElement('lower');
axesUpper = docNode.createElement('upper');
axesSubElem.appendChild(axesLower);
axesSubElem.appendChild(axesUpper);
for i = 1: 3
    % Lower Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axes_lower_sample(:, i)) ));
    axesLower.appendChild(axis);
    
    % Upper Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axes_upper_sample(:, i)) ));
    axesUpper.appendChild(axis);
end

%% axes adaptive cropping
axesSubElem = docNode.createElement('axes_adaptive_crop');
% TODO: attribute ...
axesElem.appendChild(axesSubElem);
axesLower = docNode.createElement('lower');
axesUpper = docNode.createElement('upper');
axesSubElem.appendChild(axesLower);
axesSubElem.appendChild(axesUpper);
for i = 1: 3
    % Lower Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axes_lower_cropped(:, i)) ));
    %adacrop_lower.Aux.axis(:, i)) ));
    axesLower.appendChild(axis);
    
    % Upper Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axes_upper_cropped(:, i)) ));
    %adacrop_upper.Aux.axis(:, i)) ));
    axesUpper.appendChild(axis);
end

%% Output
xmlFileName = ['data/jaw1', '.xml'];
xmlwrite(xmlFileName, docNode);
type(xmlFileName);
