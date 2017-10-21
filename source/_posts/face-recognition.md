---
title: Face Detection & Recognition
date: 2017-10-14 00:14:02
tags: 
    - Recognition
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

$n$ weak classifiers $K=[K_1, K_2, \cdots, K_n]$ and their weights $\alpha=[\alpha_1, \alpha_2, \cdots, \alpha_n]$

Adaboost trains a strong classifier: $C=sgn(\displaystyle\sum_{i}\alpha_i*K_i)$

Weights array $W=[w_1, w_2, \cdots, w_m]$ for $m$ training images.

The algorithm is as following:

```
W = ones(m)

while len(K) > 0:
    choose K_i with minimum W_e    
    alpha_i = 1/2*ln((W-W_e)/W_e)
    for w in W_e:
        w *= ((W-W_e)/W_e)^(1/2)
    for w in W_c:
        w *= ((W-W_c)/W_c)^(1/2)
    remove K_i from K
```


# Face Recognition using eigenface

## Flatten
Flatten each image into 1D vector $[X_1, X_2, \cdots, X_m]$.

## PCA

Calculate $\overline{X}=\frac{1}{m}\displaystyle\sum_i{X_i}$.

Calculate covariance matrix $Cov$ for $[X_1-\overline{X}, \cdots, X_m-\overline{X}]$.

Calculate $eigValues=[\lambda_1, \cdots, \lambda_t]$ and related eigVectors for $Cov$.

Calculate coefficients for images by multiplying eigVectors $[g_1, \cdots, g_t]$.

Calculate eigFace for training images: $\overline{X} + \displaystyle\sum_i{g_i*eigV_i}$

## Get nearest Face

For a test face $X_{test}$

Calculate eigFace of $X_{test}$ and use nearest neighbor.