---
title: Face Detection & Recognition
date: 2017-10-14 00:14:02
tags: 
    - Recognition System
---

# Preprocessing

## Histogram Equalization

Use cdf to transform intensity.

``` matlab
function eqimg = histogramequalization(img)
    maximum = round(max(img(:)));
    minimum = round(min(img(:)));
    counts = zeros(maximum-minimum+1, 1);
    
    [h, w] = size(img);
    
    for i = 1:h
        for j = 1:w
            counts(round(img(i, j)-minimum+1)) = counts((img(i, j)-minimum)+1) + 1;
        end
    end
    
    for i = 2:length(counts)
        counts(i) = counts(i) + counts(i-1);
    end
    
    eqimg = img;
    
    for i = 1:h
        for j = 1:w
            eqimg(i, j) = (counts(round(img(i, j)-minimum)+1)/(h*w)) * (maximum-minimum) + minimum;
        end
    end
    
end

```
# Face Detection

## Image Pyramid and Neural Network

![Image Pyramid and Neural Network](/images/face-recognition/detection1.png)
![Image Pyramid and Neural Network](/images/face-recognition/detection1-rotated.png)
![Image Pyramid and Neural Network](/images/face-recognition/detection1-rotated2.png)

## Integral Image and AdaBoost

Use Viola-Jones's method to get features and use AdaBoost to combine many weak classifiers into a strong classifier

### Integral Image

``` matlab
function [img] = integralimage(img)
    
    [h, w] = size(img);
    
    for i = 2:h
        img(i, 1) = img(i-1, 1) + img(i, 1);
    end
    
    for i = 2:w
        img(1, i) = img(1, i-1) + img(1, i);
    end

    for i = 2:h
        for j = 2:w
            img(i, j) = img(i-1, j) + img(i, j-1) - img(i-1, j-1) + img(i, j);
        end
    end
    
end
```

### AdaBoost

See [AdaBoost and the Super Bowl of Classifiers A Tutorial Introduction to Adaptive Boosting](/docs/adaboost.pdf)

# Face Recognition 

TBD