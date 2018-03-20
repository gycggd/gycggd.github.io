---
title: "Leetcode 240: Search a 2D matrix II"
date: 2018-03-20T19:18:59+08:00
tags:
    - Binary Search
    - Sorted Matrix
categories:
    - Leetcode
---

Leetcode中有许多关于Sorted Matrix的题目，非常有意思，其中Search 2-D matrix算是最简单的了。
后面还有[378. Kth Smallest Element in a Sorted Matrix](https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/description/)，以及很多可以转化成此类的题目，如[786. K-th Smallest Prime Fraction
](https://leetcode.com/problems/k-th-smallest-prime-fraction/description/), [668. Kth Smallest Number in Multiplication Table](https://leetcode.com/problems/kth-smallest-number-in-multiplication-table/) 等。

# LeetCode 74: Search a 2-D matrix

![74](/images/leetcode/74_1.png)

这一题非常简单，只需要将这个2-D矩阵看成一个1-D的数组，简单的进行二分查找即可。

只需要关注一下indexing的转变就好：

m, n = len(matrix), len(matrix[0])

* A[i]=matrix[i/n][i%n]
* matrix[i][j] = i\*n+j

代码如下:
```
def searchMatrix(self, matrix, target):
    if not matrix or not matrix[0] or target<matrix[0][0] or target>matrix[-1][-1]:
        return False
    m, n = len(matrix), len(matrix[0])
    l, r = 0, m*n-1
    while l<r:
        mid = (l+r)>>1
        i, j = mid//n, mid%n
        if matrix[i][j]==target:
            return True
        elif matrix[i][j]>target:
            r = mid-1
        else:
            l = mid+1
    return matrix[r//n][r%n]==target
```

# LeetCode 240: Search a 2-D matrix II

![240](/images/leetcode/240_1.png)

这一题变成了每一行每一列都是递增的，但我们无法把它当做一个已经排好序的数组来进行二分查找了。

## Brute-force solution

1行搞定，O(mn)效率低下但也可以Accepted:

```
def searchMatrix(self, matrix, target):
    return any([target in _ for _ in matrix])
```

## Binary Search for each row

还是1行搞定，O(mlogn):

```
def searchMatrix(self, matrix, target):
    return False if not matrix or not matrix[0] else any([_[min(len(_)-1, bisect.bisect_left(_, target))]==target for _ in matrix])
```

## O(m+n) tricky solution

我们知道每一行从左往右，每一列从上往下都是递增的，那么：

* matrix[i][j]>matrix[k][j] for all 0<=k<i
* matrix[i][j]<matrix[i][k] for all i<k<n

那么我们要在matrix[0:m][0:n]中寻找target，我们如果从左下角开始寻找，按照上面的公式，每一次对比我们就可以排除掉一行或一列。方法如下:

1. 初始化i=m-1, j=0
2. 对比matrix[i][j]与target:
	* matrix[i][j]==target, return True
	* matrix[i][j]>target, matrix[i][j:]就都比target大，i--
	* matrix[i][j]<target, matrix[0:i][j]就都比target小，j++
3. 重复第2步直至找到target或者i, j越界(i<0, j=n)

下面是两个例子和代码：


![240_example1](/images/leetcode/240_2.png)
![240_example2](/images/leetcode/240_3.png)

```
def searchMatrix(self, matrix, target):
    if not matrix or not matrix[0]: return False
    m, n = len(matrix), len(matrix[0])
    i, j = m-1, 0
    while i>=0 and j<n:
        if target==matrix[i][j]:
            return True
        elif target>matrix[i][j]:
            j += 1
        else:
            i -= 1
    return False
```

