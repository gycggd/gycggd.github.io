---
title: "LeetCode 378. Kth Smallest Element in a Sorted Matrix"
date: 2018-03-28T16:44:36+08:00
tags:
    - Heap
    - Binary Search
categories:
    - LeetCode
---

![desc](/images/leetcode/378_1.png)

之前写过LeetCode 74: Search a 2-D matrix和LeetCode 240: Search a 2-D matrix II这两题，当时提到了这一题。这里要说的这一题的两种解法分别是`klogm`和`(m+n)log(max-min)`，其中k是O(mn)的，所以后者要快一点。还有一种最快的O(m)的解法下次再说。（m,n为矩阵长宽）

# 堆解法

这里是一个例子:

![example](/images/leetcode/378_2.png)

如上图所示，从左上角即最小的数字开始，每次取出最小的数字，并把该数字右边的数字加进去，如果该数字在最左边，把其下方数字也加入。重复取k次即得到第k小数字。

每次复杂度为O(logm)，所以复杂度为O(klogm)，代码如下：

```
class Solution(object):
    def kthSmallest(self, matrix, k):
        heap = []
        m, n = len(matrix), len(matrix[0])
        heapq.heappush(heap, (matrix[0][0], 0, 0))
        
        while k>0:
            v, i, j = heapq.heappop(heap)
            k -= 1
            if k==0:
                return v
            if j+1<n:
                heapq.heappush(heap, (matrix[i][j+1], i, j+1))
            if j==0 and i+1<m:
                heapq.heappush(heap, (matrix[i+1][j], i+1, j))
```

![heap](/images/leetcode/378_3.png)


# 二分查找解法

我们知道最大数为`matrix[i-1][j-1]`，最小数为`matrix[0][0]`，第k小的数肯定在这两货之间，所以可以用二分法。二分的判断条件是对于mid=(l+r)/2，判断矩阵中小于mid的数字个数与(k-1)的关系。而得到小于mid的数字个数复杂度为O(m+n)（方法与LeetCode 74: Search a 2-D matrix类似）。代码如下：

```
class Solution(object):
    def kthSmallest(self, matrix, k):
        m, n = len(matrix), len(matrix[0])
        def count(v):
            ret, i, j = 0, m-1, 0
            # mini是返回矩阵比k大的最小的数，因为v不一定在矩阵中，所以取比v大的最小的数才是第k小的
            mini = sys.maxsize
            while j<n:
                while i>=0 and matrix[i][j]>=v:
                    i -= 1
                mini = min(mini, matrix[i+1][j] if i+1<m else sys.maxsize)
                ret += (i+1)
                j += 1
            return ret, mini
        l, r = matrix[0][0]-1, matrix[m-1][n-1]+1
        while l+1<r:
            mid = (l+r)>>1
            cnt, mini = count(mid)
            if cnt==k-1:
                return mini
            elif cnt<k-1:
                l = mid
            else:
                r = mid
        return count(l)[1]
```

![bs](/images/leetcode/378_4.png)

复杂度为`O((max-min)(m+n))`不存在二次项，所以理论上要比`O(klogm)=O(mnlogm)`快不少。