---
title: "LeetCode 152. Maximum Product Subarray"
date: 2018-04-09T16:21:15+08:00
tags:
    - Dynamic Programming
    - Divide and Conquer
categories:
    - LeetCode
---

![desc](/images/leetcode/152_1.png)

这一题有O(N)的DP解法和O(NlogN)的DC解法，与53 Maximum Subarray类似。

# 动态规划

maximum[i]表示以i结尾的subarray的最大乘积
minimum[i]表示以i结尾的subarray的最小乘积

初始状态：

maximum[0]=minimum[0]=nums[0]

递推公式：


`maximum[i] = max(nums[i], maximum[i-1]*nums[i], minimum[i-1]*nums[i])`
`minimum[i] = min(nums[i], maximum[i-1]*nums[i], minimum[i-1]*nums[i])`


```
class Solution:
    def maxProduct(self, nums):
        maximum = [0]*len(nums)
        minimum = [0]*len(nums)
        maximum[0], minimum[0], ret = nums[0], nums[0], nums[0]
        for i in range(1, len(nums)):
            maximum[i] = max(nums[i], maximum[i-1]*nums[i], minimum[i-1]*nums[i])
            minimum[i] = min(nums[i], maximum[i-1]*nums[i], minimum[i-1]*nums[i])
            ret = max(maximum[i], ret)
        return ret
```


降低空间复杂度：

```
class Solution:
    def maxProduct(self, nums):
        maximum, minimum, ret = [nums[0]]*3
        for n in nums[1:]:
            maximum, minimum = max(n, n*maximum, n*minimum), min(n, n*maximum, n*minimum)
            ret = max(maximum, ret)
        return ret
```

# 分而治之

三种情况：

* maxProduct在左边(递归)
* maxProduct在右边(递归)
* maxProduct一半在左边一半在右边(merge)

```
class Solution:
    def maxProduct(self, nums):
        def dc(arr, l, r):
            if l==r: return arr[l]
            mid = (l+r)>>1
            return max(dc(arr, l, mid), dc(arr, mid+1, r), merge(arr, l, r, mid))
        
        def merge(arr, l, r, m):
            lmax, lmin = arr[m], arr[m]
            rmax, rmin = 1, 1
            
            i, prod = m-1, arr[m]
            while i>=l:
                prod *= arr[i]
                lmax, lmin = max(prod, lmax), min(prod, lmin)
                if prod==0: break
                i -= 1
            
            j, prod = m+1, 1
            while j<=r:
                prod *= arr[j]
                rmax, rmin = max(prod, rmax), min(prod, rmin)
                if prod==0: break
                j += 1
            return max(lmax*rmax, lmin*rmin)
        
        return dc(nums, 0, len(nums)-1)         
```